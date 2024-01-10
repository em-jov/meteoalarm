# Meteoalarm

Meteoalarm serves as an API wrapper for [meteoalarm.org](https://meteoalarm.org/en/live/), a platform delivering hydrometeorological warnings across the European region. This gem simplifies the process of retrieving these warnings based on country, specific coordinates or area, along with a few additional options.

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

# Check currently active alarms
Meteoalarm::Client.alarms('FR', active_now: true)

# Check alarms by date
Meteoalarm::Client.alarms('FR', date: '2024-01-10')

# Include expired alarms
Meteoalarm::Client.alarms('FR', expired: true)

# Or combine the options
Meteoalarm::Client.alarms('FR', area: 'Paris', active_now: true)
```

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

Bug reports and pull requests are welcome on GitHub at https://github.com/em-jov/meteoalarm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
