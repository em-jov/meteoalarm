# frozen_string_literal: true
require 'json'
require 'net/http'
require 'time'
require 'uri'
require_relative 'meteoalarm/country_mapping'
require_relative 'meteoalarm/http'
require_relative 'meteoalarm/version'


module Meteoalarm
  class Error < StandardError; end
  class ArgumentError < Error; end
  class APIError < Error; end

  class Client
    # Use this class to retrieve meteo alarms for a specific country.
    #
    # Example:
    #   >> Meteoalarm::Client.alarms('FR')
    #
    # Arguments:
    #   country_code: (String) - ISO 3166-1 A-2 code representing the country
    #   options: (Hash) - Additional search options
    #     latitude:, longitude: (Float) - Coordinates for location-based alarm search
    #     area: (String) - Area to filter alarms (ignored if coordinates are provided)
    #     active_now: (Boolean) - Search for currently active alarms
    #     expired: (Boolean) - List alarms that have expired
    #     date: (Date) - Search alarms by a specified future date
    #
    # Returns an array of weather alarms based on the provided criteria.

    def self.alarms(country_code, options = {})
      country = Meteoalarm::COUNTRY_MAPPING[country_code.upcase]
      raise Meteoalarm::ArgumentError, "The provided country code is not supported. Refer to the rake tasks to view a list of available country codes." unless country
      raise Meteoalarm::ArgumentError, "Both latitude and longitude must be provided." if (options[:latitude] && !options[:longitude]) || (!options[:latitude] && options[:longitude])
      raise Meteoalarm::ArgumentError, "Incorrect date format provided." if options[:date] && !options[:date].is_a?(Date)
      raise Meteoalarm::ArgumentError, "The date must be set in the future." if options[:date] && options[:date] < Date.today
      warn "Provided coordinates will override the specified area." if (options[:latitude] && options[:area]) 

      new.send(:alarms, country, options)
    end

    private

    def alarms(country, options = {})
      warnings = Meteoalarm::HTTP.call(country)
      reject_expired_warnings(warnings) unless options[:expired]

      if options[:latitude] && options[:longitude]
        warnings = check_warnings_in_coordinates(warnings, country, options[:latitude], options[:longitude])
      elsif options[:area]
        warnings = find_warnings_in_area(warnings, options[:area].downcase)
        check_area(country, options[:area]) if warnings == []
      end

      warnings = future_alarms(warnings) if options[:future_alarms]
      warnings = currently_active_alarms(warnings) if options[:active_now]
      warnings = alarms_filter_by_date(warnings, options[:date]) if options[:date]
      
      warnings
    end

    def check_area(country, area)
      path = File.expand_path(__dir__)
      data = File.read("#{path}/../countries/#{country}.json")
      spec = JSON.parse(data)
      unless spec.find { |s| s["area"].downcase == area.downcase }  
        raise Meteoalarm::ArgumentError, 'The provided area name is not supported. Refer to the rake tasks to view a list of available area names.'
      end
    end

    def reject_expired_warnings(warnings)
      warnings.reject! do |warning|
        Time.parse(warning.dig(:alert, :info, 0, :expires)) < Time.now
      end
    end

    def check_warnings_in_coordinates(warnings, country, latitude, longitude)
      path = File.expand_path(__dir__)
      country_spec = File.read("#{path}/../countries/#{country}.json")
      parsed_data = JSON.parse(country_spec)

      alerts = []
      parsed_data.each do |area|
        if area['type'] == 'MultiPolygon'
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

    def point_in_polygon(long, lat, polygon)
      odd_nodes = false
      j = polygon.length - 1
    
      (0...polygon.length).each do |i|
        if (polygon[i][1] < lat && polygon[j][1] >= lat) || (polygon[j][1] < lat && polygon[i][1] >= lat)
          if (polygon[i][0] + (lat - polygon[i][1]) / (polygon[j][1] - polygon[i][1]) * (polygon[j][0] - polygon[i][0]) < long)
            odd_nodes = !odd_nodes
          end
        end
        j = i
      end
    
      odd_nodes
    end

    def point_in_multipolygon(long, lat, multipolygon)    
      multipolygon.each do |polygon|
        return true if point_in_polygon(long, lat, polygon)
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

    def future_alarms(warnings) 
      warnings.select do |alert|
        onset_time = Time.parse(alert.dig(:alert, :info, 0, :onset))
    
        onset_time > Time.now
      end
    end

    def alarms_filter_by_date(warnings, date)
      warnings.select do |alert|
        Time.parse(alert.dig(:alert, :info, 0, :onset)).to_date == date
      end
    end
  end
end