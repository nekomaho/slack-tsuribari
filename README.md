# SlackTsuribari
SlackTsuribari is a Slack Incoming Webhook wrapper for ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack_tsuribari'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slack_tsuribari

## Usage
To post a message to slack, create a hook object and send data with Angler.throw!.

```ruby
hook = SlackTsuribari::Hook.config('https://hooks.slack.com/services/')
SlackTsuribari::Angler.throw!(hook, {text: 'test'})
```

The second argument of throw! can specify the payload of slack's Incoming Webhook.
See Setup Instructions of Incoming Webhook for arguments that can be specified in the payload.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/slack_tsuribari. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

