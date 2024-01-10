# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'
require 'time'
require 'geokit'
require_relative "meteoalarm/version"
require_relative 'meteoalarm/country_mapping'

module Meteoalarm
  class Error < StandardError; end

  class Client
    BASE_URL = 'https://feeds.meteoalarm.org/api/v1/warnings/'

    def self.alarms(country, options = {})
      new.send(:alarms, country, options)
    end

    private

    def alarms(country, options = {})
      country = Meteoalarm::COUNTRY_MAPPING[country.upcase] || "invalid_country"
      endpoint = "#{ BASE_URL }feeds-#{ country }"
      response = send_http_request(endpoint)
      check_status_code(response.code)

      warnings = JSON.parse(response.body, symbolize_names: true)[:warnings]
      show_expired_warnings!(warnings, options[:expired])

      if options[:latitude] && options[:longitude]
        warnings = check_warnings_in_coordinates(warnings, country, options[:latitude], options[:longitude])
      elsif options[:area]
        warnings = find_warnings_in_area(warnings, options[:area].downcase)
      end

      warnings = currently_active_alarms(warnings) if options[:active_now]
      warnings = alarms_filter_by_date(warnings, options[:date]) if options[:date]
      
      warnings
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
        raise Error, 'Unsupported country name was specified'
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
      date_time = Time.parse(date)
      return if date_time.to_date < Time.now.to_date
    
      warnings.select do |alert|
        Time.parse(alert.dig(:alert, :info, 0, :onset)).to_date == date_time.to_date
      end
    end
  end
end
