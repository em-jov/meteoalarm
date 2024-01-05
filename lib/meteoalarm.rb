# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'
require 'time'
require 'geokit'
require_relative "meteoalarm/version"

module Meteoalarm
  class Error < StandardError; end

  class Client
    BASE_URL = 'https://feeds.meteoalarm.org/api/v1/warnings/'

    def self.alerts(country, options = {})
      endpoint = "#{BASE_URL}feeds-#{country.downcase}"
      response = send_http_request(endpoint)
      check_status_code(response.code)

      warnings = JSON.parse(response.body)['warnings']
      show_expired_warnings!(warnings, options[:expired])

      if options[:latitude] && options[:longitude]
        warnings = check_warnings_in_coordinates(warnings, country, options[:latitude], options[:longitude])
      elsif options[:area]
        warnings = find_warnings_in_area(warnings, options[:area])
      end
      
      sort_warnings_by_onset!(warnings)
    end

    def self.point_in_polygon(x, y, polygon)
      point = Geokit::LatLng.new(y, x)
      polygon_geom = Geokit::Polygon.new(polygon.map { |lon, lat| Geokit::LatLng.new(lat, lon) })
    
      polygon_geom.contains?(point)
    end

    def self.point_in_multipolygon(x, y, multipolygon)
      point = Geokit::LatLng.new(y, x)
    
      multipolygon.each do |polygon_coords|
        polygon_geom = Geokit::Polygon.new(polygon_coords.map { |lon, lat| Geokit::LatLng.new(lat, lon) })
        return true if polygon_geom.contains?(point)
      end
    
      false
    end
    
    private

    def self.send_http_request(endpoint)
      uri = URI.parse(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.path)
      http.request(request)
    end

    def self.check_status_code(status_code)
      if status_code == '404'
        raise Error, 'Unsupported country name was specified'
      elsif status_code.to_i >= 500
        raise Error, "Server error - status code: #{status_code}"
      elsif status_code.to_i != 200
        raise Error, "Server returned unexpected status code: #{status_code}"
      end
    end

    def self.show_expired_warnings!(warnings, expired_option)
      return if expired_option

      warnings.select! do |alert|
        Time.parse(alert.dig("alert", "info", 0, "expires")) > Time.now
      end
    end

    def self.check_warnings_in_coordinates(warnings, country, latitude, longitude)
      country_spec = File.read("countries/#{country}.json")
      parsed_data = JSON.parse(country_spec)

      parsed_data.each do |area|
        if area['type'] == 'MultiPolygon'
          multipolygon = area['coordinates'].first
          if point_in_multipolygon(longitude, latitude, multipolygon)       
            warnings = find_warnings_in_code(warnings, area['code'])
            break
          end
        else
          polygon = area['coordinates'].first  
          if point_in_polygon(longitude, latitude, polygon)        
            warnings = find_warnings_in_code(warnings, area['code'])
            break
          end
        end
      end

      warnings
    end

    def self.find_warnings_in_code(warnings, code)
      warnings.each_with_object([]) do |alert, area_alerts|
        alert.dig("alert", "info", 0, "area").each do |area|
          area_alerts << alert if area['geocode'].any? { |geocode| geocode['value'] == code }
        end
      end
    end

    def self.find_warnings_in_area(warnings, area)
      warnings.select do |alert|
        alert.dig("alert", "info", 0, "area").any? { |alert_area| alert_area['areaDesc'] == area }
      end
    end

    def self.sort_warnings_by_onset!(warnings)
      warnings.sort_by! { |alert| Time.parse(alert.dig("alert", "info", 0, "onset")) }.reverse!
    end
  end
end
