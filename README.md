# Bitok

The Ruby gem wrapper for Bitok! This gem is actively being developed. **Be sure to check the branch for the version you're using.**

## Installation

To install, type:

```ruby
gem install bitok
```

Add to your `Gemfile`:

```ruby
gem "bitok", "~> 0.0.1"
```

Run `bundle install`

## Configure

API keys *must* be configured in the gem setup. You can do this anywhere in your application before you make API calls using the gem.

```ruby
Bitok.configure do |config|
  config.api_key = 'api_key'
  config.private_key = 'private_key'
  config.base_url = 'url'
end
```

`config.base_url` - the default is set to `'https://kyt-api.bitok.org'`

## Usage

```ruby
# To get supported network
Bitok::API.get_networks
```

## Contributing

Bug reports and pull requests are welcome.

* Please be sure to include tests with your PRs.
* Run `bundle exec rubocop` to ensure style with the rest of the project
