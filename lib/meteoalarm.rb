# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'
require 'time'
require_relative "meteoalarm/version"

module Meteoalarm
  class Error < StandardError; end
  # Your code goes here...
  class Client
    BASE_URL = 'https://feeds.meteoalarm.org/api/v1/warnings/'

    def self.alarms(country, options = {})
      endpoint = "#{BASE_URL}feeds-#{country.downcase}"
      url = URI.parse(endpoint)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url.path)
      response = http.request(request)
      check_status_code(response.code)

      warnings = JSON.parse(response.body)['warnings']

      area_alerts = []

      if options[:area]
        warnings.each do |alert|
          alert.dig("alert", "info", 0, "area").each do |area|
            if area["areaDesc"] == options[:area] && 
             Time.parse(alert.dig("alert", "info", 0, "expires")) > Time.now
             area_alerts << alert
            end
          end
        end
      end
     area_alerts.sort_by! { |alert| Time.parse(alert.dig("alert", "info", 0, "onset")) }.reverse!
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
  end
end
