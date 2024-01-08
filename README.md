# Meteoalarm

Meteoalarm gem serves as an API wrapper for meteoalarm.org, providing a user-friendly interface for retrieving weather warnings within the European region. Users can conveniently access warnings based on country, coordinates or area.

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
Meteoalarm::Client.alerts('FR', **options) # Example: France
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
Meteoalarm::Client.alerts('FR', latitude: 48.84307, longitude: 2.33662)

# Check alarms by area
Meteoalarm::Client.alerts('FR', area: 'Paris')

# Check currently active alarms
Meteoalarm::Client.alerts('FR', active_now: true)

# Check alarms by date
Meteoalarm::Client.alerts('FR', date: '2024-01-10')

# Include expired alarms
Meteoalarm::Client.alerts('FR', expired: true)

# Or combine the options
Meteoalarm::Client.alerts('FR', area: 'Paris', active_now: true)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/em-jov/meteoalarm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
