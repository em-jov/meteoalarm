require_relative '../country_mapping'
require 'json'

namespace :meteoalarm do
  desc 'List all areas of given COUNTRY_CODE in Meteoalarm system'
  task :areas do
    country =  Meteoalarm::COUNTRY_MAPPING[ENV['COUNTRY_CODE']&.upcase]
    if country
      path = File.expand_path(__dir__)
      data = File.read("#{path}/../../../countries/#{country}.json")
      spec = JSON.parse(data)
      spec.each { |s| p s["area"] }
    else
      p 'Error: Invalid country code'
    end
  end  
end