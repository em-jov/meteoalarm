# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'
require 'time'
require 'geokit'
require_relative 'meteoalarm/version'
require_relative 'meteoalarm/country_mapping'

module Meteoalarm
  class Error < StandardError; end

  class Client
    BASE_URL = 'https://feeds.meteoalarm.org/api/v1/warnings/'

    # Use this class to retrieve meteo alarms for a specific country.
    #
    # Example:
    #   >> Meteoalarm::Client.alarms('FR')
    #
    # Arguments:
    #   country_code: (String) - ISO 3166-1 A-2 code representing the country
    #   options: (Hash) - Additional search options
    #     area: (String) - Area to filter alarms
    #     latitude:, longitude: (Float) - Coordinates for location-based alarm search
    #     active_now: (Boolean) - Search for currently active alarms
    #     expired: (Boolean) - List alarms that have expired
    #     date: (Date) - Search alarms by a specified future date
    #
    # Returns an array of weather alarms based on the provided criteria.

    def self.alarms(country_code, options = {})
      new.send(:alarms, country_code, options)
    end

    private

    def alarms(country_code, options = {})
      country = Meteoalarm::COUNTRY_MAPPING[country_code.upcase] #|| "invalid_country"
      raise Error, 'The provided country code is not supported. Refer to the rake tasks to view a list of available country codes.' unless country
      endpoint = "#{ BASE_URL }feeds-#{ country }"
      response = send_http_request(endpoint)
      check_status_code(response.code)

      warnings = JSON.parse(response.body, symbolize_names: true)[:warnings]
      show_expired_warnings!(warnings, options[:expired])

      raise Error, "Latitude and longitude must be provided." if (options[:latitude] && !options[:longitude]) || (!options[:latitude] && options[:longitude])

      if options[:latitude] && options[:longitude]
        warnings = check_warnings_in_coordinates(warnings, country, options[:latitude], options[:longitude])
      elsif options[:area]
        warnings = find_warnings_in_area(warnings, options[:area].downcase)
        check_area(country, options[:area]) if warnings == []
      end

      warnings = currently_active_alarms(warnings) if options[:active_now]
      warnings = alarms_filter_by_date(warnings, options[:date]) if options[:date] && options[:date].is_a?(Date)
      
      warnings
    end

    def check_area(country, area)
      data = File.read("countries/#{country}.json")
      spec = JSON.parse(data)
      unless spec.find { |s| s["area"].downcase == area.downcase }  
        raise Error, 'The provided area name is not supported. Refer to the rake tasks to view a list of available area names.'
      end
    end

    def send_http_request(endpoint)
      uri = URI.parse(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.path)
      http.request(request)
    end

    def check_status_code(status_code)
      if status_code == '404'
        raise Error, 'The provided country code is not supported. Refer to the rake tasks to view a list of available country codes.'
      elsif status_code.to_i >= 500
        raise Error, "Server error - status code: #{status_code}"
      elsif status_code.to_i != 200
        raise Error, "Server returned unexpected status code: #{status_code}"
      end
    end

    def show_expired_warnings!(warnings, expired_option)
      return if expired_option

      warnings.select! do |alert|
        Time.parse(alert.dig(:alert, :info, 0, :expires)) > Time.now
      end
    end

    def check_warnings_in_coordinates(warnings, country, latitude, longitude)
      country_spec = File.read("countries/#{country}.json")
      parsed_data = JSON.parse(country_spec)

      alerts = []
      parsed_data.each do |area|
        if area[:type] == 'MultiPolygon'
          multipolygon = area['coordinates'].first
          if point_in_multipolygon(longitude, latitude, multipolygon)       
            alerts << find_warnings_in_code(warnings, area['code'])
          end
        else
          polygon = area['coordinates'].first  
          if point_in_polygon(longitude, latitude, polygon)        
            alerts << find_warnings_in_code(warnings, area['code'])
          end
        end
      end
      alerts.flatten
    end

    def point_in_polygon(x, y, polygon)
      point = Geokit::LatLng.new(y, x)
      polygon_geom = Geokit::Polygon.new(polygon.map { |lon, lat| Geokit::LatLng.new(lat, lon) })
    
      polygon_geom.contains?(point)
    end

    def point_in_multipolygon(x, y, multipolygon)
      point = Geokit::LatLng.new(y, x)
    
      multipolygon.each do |polygon_coords|
        polygon_geom = Geokit::Polygon.new(polygon_coords.map { |lon, lat| Geokit::LatLng.new(lat, lon) })
        return true if polygon_geom.contains?(point)
      end
    
      false
    end

    def find_warnings_in_code(warnings, code)
      warnings.each_with_object([]) do |alert, area_alerts|
        alert.dig(:alert, :info, 0, :area).each do |area|
          area_alerts << alert if area[:geocode].any? { |geocode| geocode[:value] == code }
        end
      end
    end

    def find_warnings_in_area(warnings, area)
      warnings.select do |alert|
        alert.dig(:alert, :info, 0, :area).any? { |alert_area| alert_area[:areaDesc].downcase == area }
      end
    end

    def currently_active_alarms(warnings) 
      warnings.select do |alert|
        onset_time = Time.parse(alert.dig(:alert, :info, 0, :onset))
        expires_time = Time.parse(alert.dig(:alert, :info, 0, :expires))
    
        onset_time <= Time.now && expires_time > Time.now
      end
    end

    def alarms_filter_by_date(warnings, date)
      return if date < Date.today
    
      warnings.select do |alert|
        Time.parse(alert.dig(:alert, :info, 0, :onset)).to_date == date
      end
    end
  end
end
