require_relative '../country_mapping'

namespace :meteoalarm do
  desc 'List all countries in Meteoalarm system'
  task :countries do
    Meteoalarm::COUNTRY_MAPPING.each do |code, country|
      p "#{code}: #{country}"
    end
  end  
end