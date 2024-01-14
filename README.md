# Meteoalarm

Meteoalarm serves as an API wrapper for [meteoalarm.org](https://meteoalarm.org/en/live/), a platform delivering hydrometeorological warnings across the European region. This gem simplifies the process of retrieving warnings based on country, specific coordinates or area, along with a few additional options.

## Installation

Add this line to your Gemfile:

```ruby
gem 'meteoalarm'
```

And then execute:

```bash
bundle install
```

Or install it directly:

```bash
gem install meteoalarm
```

## Usage

```ruby
require 'meteoalarm'

# Get alarms for a specific country by its ISO 3166-1 A-2 code
Meteoalarm::Client.alarms('FR', **options) # Example: France
```

#### Options

- `:latitude` and `:longitude`: Check alarms for a specific coordinates.
- `:area`: Check alarms for a specific area.
- `:active_now`: Check currently active alarms.
- `:date`: Check alarms by date.
- `:expired`: Include expired alarms.

#### Examples

```ruby
require 'meteoalarm'

# Check alarms by coordinates
Meteoalarm::Client.alarms('FR', latitude: 48.84307, longitude: 2.33662)

# Check alarms by area
Meteoalarm::Client.alarms('FR', area: 'Paris')

# Check future alarms
Meteoalarm::Client.alarms('FR', future_alarms: true)

# Check currently active alarms
Meteoalarm::Client.alarms('FR', active_now: true)

# Check alarms by date
Meteoalarm::Client.alarms('FR', date: Date.new(2024, 1, 21))

# Include expired alarms
Meteoalarm::Client.alarms('FR', expired: true)

# Or combine the options
Meteoalarm::Client.alarms('FR', area: 'Paris', active_now: true)
```

#### JSON format API response example

```json
[{:alert=>                                                                           
   {:identifier=>"2.49.0.0.250.0.FR.20240114100246.345025",                          
    :incidents=>"Alert",                                                             
    :info=>                                                                          
     [{:area=>
        [{:areaDesc=>"Paris", :geocode=>[{:value=>"FR101", :valueName=>"NUTS3"}]},
         {:areaDesc=>"Seine-Maritime", :geocode=>[{:value=>"FR232", :valueName=>"NUTS3"}]},
         {:areaDesc=>"Seine-et-Marne", :geocode=>[{:value=>"FR102", :valueName=>"NUTS3"}]}],
       :category=>["Met"],
       :certainty=>"Likely",
       :contact=>"METEO-FRANCE",
       :description=>
        "Des phénomènes habituels dans la région mais occasionnellement et localement dangereux sont prévus (exemple : mistral, orage d'été, montée des eaux, fortes vagues submergeant le littoral).",
       :effective=>"2024-01-14T10:00:00+01:00",
       :event=>"Vigilance jaune neige-verglas",
       :expires=>"2024-01-15T00:00:00+01:00",
       :headline=>"Vigilance jaune neige-verglas",
       :instruction=>
        "Soyez attentifs si vous pratiquez des activités sensibles au risque météorologique ou à proximité d'un rivage ou d'un cours d'eau. Tenez-vous au courant de l'évolution de la situation.",
       :language=>"fr-FR",
       :onset=>"2024-01-14T10:02:30+01:00",
       :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, 
                    {:value=>"2; snow-ice", :valueName=>"awareness_type"}],
       :responseType=>["Monitor"],
       :senderName=>"METEO-FRANCE",
       :severity=>"Moderate",
       :urgency=>"Future",
       :web=>"http://vigilance.meteofrance.com/"},
      {:area=>
        [{:areaDesc=>"Paris", :geocode=>[{:value=>"FR101", :valueName=>"NUTS3"}]},
         {:areaDesc=>"Seine-Maritime", :geocode=>[{:value=>"FR232", :valueName=>"NUTS3"}]},
         {:areaDesc=>"Seine-et-Marne", :geocode=>[{:value=>"FR102", :valueName=>"NUTS3"}]}],
       :category=>["Met"],
       :certainty=>"Likely",
       :contact=>"METEO-FRANCE",
       :description=>"Moderate damages may occur, especially in vulnerable or in exposed areas and to people who carry out weather-related activities.",
       :effective=>"2024-01-14T10:00:00+01:00",
       :event=>"Moderate snow-ice warning",
       :expires=>"2024-01-15T00:00:00+01:00",
       :headline=>"Moderate snow-ice warning",
       :instruction=>"Be careful, keep informed of the latest weather forecast.",
       :language=>"en-GB",
       :onset=>"2024-01-14T10:02:30+01:00",
       :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, 
                    {:value=>"2; snow-ice", :valueName=>"awareness_type"}],
       :responseType=>["Monitor"],
       :senderName=>"METEO-FRANCE",
       :severity=>"Moderate",
       :urgency=>"Future",
       :web=>"http://vigilance.meteofrance.com/"}],
    :msgType=>"Alert",
    :scope=>"Public",
    :sender=>"vigilance@meteo.fr",
    :sent=>"2024-01-14T10:02:46+01:00",
    :status=>"Actual"},
  :uuid=>"9a7190ce-fc8a-4165-a438-d1fe08feb3ed"}]

```

#### JSON format API response fields
- `alert` Contains one warning for one or more areas. 
    - `identifier` String which uniquely identifies the CAP (Common Alerting Protocol within meteoalarm.org) message.
    - `info` Contains warning in  a single language, with a separate segment for each translation.
        - `area` Container for all component parts in particular for the `geocode` segment.
            - `areaDesc` Human-readable description of the areas affected by the warning.
            - `geocode` Affected areas according to meteoalarm.org specifications.
        - `category` Code denoting the category of the warning (Met - Meteorological warning (including floods)).
        - `certainty` Type of event (Observed, Likely, Possible, Unlikely).
        - `contact` Contact information.
        - `description` Warning text message.
        - `effective` Date and time when the warning has been issued.
        - `event` Will be populated with information derived from `awareness_types` (Wind, Thunderstorm4, Fog, etc.) and `awareness_level` (Minor, Moderate, Severe, Extreme).
        - `expires` Date and time for the ending of the warning.
        - `headline` A brief human-readable headline (160 characters).
        - `instruction` Text describing recommended actions to be taken.
        - `language` Specification of language for `info` segment.
        - `onset` Date and time for the beginning of the warning.
        - `parameter` meteoalarm.org specific code indicating awareness type and alert level.
        - `responseType` Code denoting the type of action recommended (Evacuate, Avoid, Monitor, etc.).
        - `severity` Derived from the MeteoAlarm `awareness_level`.
        - `senderName` Human-readable name of the originator of the warning message. 
        - `urgency` Urgency of the event (Immediate, Expected, Future, Past).
        - `web` Link to website for additional information related to the warning.
    - `msgType` Used to distinguish between new warnings, updates or cancellation of warnings (Alert, Update, Cancel, etc.).
    - `scope` Used to distinguish between public and restricted warning information (Public, Restricted, etc.).         
    - `sender` Email address of originator of warning. 
    - `sent` Date and time when CAP warning message has been sent.
    - `status` Used to distinguish between actual and test messages (Actual, Test, etc.). 

For more information please visit [Meteoalarm Redistribution Hub](https://www.meteoalarm.org/en/live/page/redistribution-hub).

## Rake tasks

To incorporate Meteoalarm rake tasks into your project, include the following code in your `Rakefile`:
```ruby
require 'meteoalarm'

spec = Gem::Specification.find_by_name 'meteoalarm'
Dir.glob("#{spec.gem_dir}/lib/meteoalarm/tasks/*.rake").each { |f| import f }
```
By adding this code, you will gain access to the following rake tasks:
```
rake meteoalarm:countries
    List all countries in Meteoalarm system

rake meteoalarm:areas
    List all areas of given COUNTRY_CODE in Meteoalarm system
```

## Contributing

Your contributions are welcome and appreciated. If you find issues or have improvements, feel free to open an issue or submit a pull request.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
