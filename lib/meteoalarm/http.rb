# frozen_string_literal: true

module Meteoalarm
  class HTTP
    BASE_URL = 'https://feeds.meteoalarm.org/api/v1/warnings/'

    def self.call(country)
      new.send(:call, country)
    end

    private
    
    def call(country)
      endpoint = "#{ BASE_URL }feeds-#{ country }"
      response = send_http_request(endpoint)
      check_status_code(response.code)

      JSON.parse(response.body, symbolize_names: true)[:warnings]
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
        raise Meteoalarm::APIError, "The requested page could not be found. Please consider upgrading the Meteoalarm gem or opening an issue."
      elsif status_code.to_i >= 500
        raise Meteoalarm::APIError, "Server error - status code: #{status_code}"
      elsif status_code.to_i != 200
        raise Meteoalarm::APIError, "Server returned unexpected status code: #{status_code}"
      end
    end
  end
end