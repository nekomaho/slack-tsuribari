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

## Supported versions
* Ruby 2.5, 2.6, 2.7, 3.0

## Usage
To post a message to a slack an easy way, create a hook object and send data with Angler.easy_throw!.
```ruby
hook = SlackTsuribari::Hook.config('https://hooks.slack.com/services/webhook_url')
SlackTsuribari::Angler.easy_throw!(hook, 'test message')
```
Use Angler.throw! If you need a bit more control, like adding color.

```ruby
hook = SlackTsuribari::Hook.config('https://hooks.slack.com/services/webhook_url')
payload = {
  attachments: [
    fallback: 'test message',
    text: 'test message',
    color: '#00FF00',
  ]
}
SlackTsuribari::Angler.throw!(hook, payload)
```

The second argument of throw! can specify the payload of slack's Incoming Webhook.
See Setup Instructions of Incoming Webhook and [Adding secondary attachment](https://api.slack.com/messaging/composing/layouts#attachments)
for arguments that can be specified in the payload.

### proxy setting
If a proxy is needed, it can be configured as follows

```ruby
hook = SlackTsuribari::Hook.config do |config|
  config.uri = 'https://hooks.slack.com/services/webhook_url'
  config.proxy_addr = '127.0.0.1'
  config.proxy_port = 8080
  config.proxy_user = 'test'
  config.proxy_pass = 'password'
  config.no_proxy = '192.168.1.1'
end
SlackTsuribari::Angler.easy_throw!(hook, 'test message')
```

### pre payload setting
In config you can also set the `channel`, `username`, `text` and icon to post.
The `channel` is set when you change the channel to post.
```ruby
hook = SlackTsuribari::Hook.config do |config|
  config.uri = 'https://hooks.slack.com/services/webhook_url'
  config.pre_payload.channel = 'sample_channel'
end
SlackTsuribari::Angler.easy_throw!(hook, 'test message')
```

The `username` allows you to change the name of the post.
```ruby
hook = SlackTsuribari::Hook.config do |config|
  config.uri = 'https://hooks.slack.com/services/webhook_url'
  config.pre_payload.username = 'Robot'
end
SlackTsuribari::Angler.easy_throw!(hook, 'test message')
```

The `text` allows you to set the text to be posted. If text is specified with `easy_throw!` or `throw!`, its setting is preferred.
```ruby
hook = SlackTsuribari::Hook.config do |config|
  config.uri = 'https://hooks.slack.com/services/webhook_url'
  config.pre_payload.text = 'pre payload text'
end
SlackTsuribari::Angler.easy_throw!(hook) # => throw 'pre payload text'
SlackTsuribari::Angler.throw!(hook) # => throw 'pre payload text'

SlackTsuribari::Angler.easy_throw!(hook, 'text') # => throw 'text'
SlackTsuribari::Angler.throw!(hook, {text: 'text'}) # => throw 'text'
```

If you want to set an icon, put a value in either `icon_url` or `icon_emoji`.
The `icon_url` is the URL of the icon.
The `icon_emoji` is the text of the emoji to be set for the icon.
```ruby
hook = SlackTsuribari::Hook.config do |config|
  config.uri = 'https://hooks.slack.com/services/webhook_url'
  config.pre_payload.icon_url = 'path to icon url'
end
SlackTsuribari::Angler.easy_throw!(hook, 'test message')
```

```ruby
hook = SlackTsuribari::Hook.config do |config|
  config.uri = 'https://hooks.slack.com/services/webhook_url'
  config.pre_payload.icon_emoji = ':+1:'
end
SlackTsuribari::Angler.easy_throw!(hook, 'test message')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nekomaho/slack-tsuribari. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

