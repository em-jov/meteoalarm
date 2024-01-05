# Meteoalarm

The Meteoalarm gem serves as an API wrapper for meteoalarm.org, providing a user-friendly interface for retrieving weather warnings within the European region. Users can conveniently access warnings based on country, coordinates, or area description.

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

# Get warnings for a specific country
warnings = Meteoalarm::Client.alerts('CountryName', options)
```

#### Options

- `:latitude` and `:longitude`: Check warnings for a specific location.
- `:area`: Check warnings for a specific area description.
- `:expired`: Include expired warnings (default is `false`).

## Examples

#### Check Warnings by Country and Coordinates

```ruby
warnings = Meteoalarm::Client.alerts('bosnia-herzegovina', latitude: 43.852276, longitude: 18.396182)
```

#### Check Warnings by Area Description

```ruby
warnings = Meteoalarm::Client.alerts('bosnia-herzegovina', area: 'Sarajevo')
```

#### Include Expired Warnings

```ruby
warnings = Meteoalarm::Client.alerts('bosnia-herzegovina', expired: true)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/em-jov/meteoalarm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/meteoalarm/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Meteoalarm project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/meteoalarm/blob/master/CODE_OF_CONDUCT.md).

