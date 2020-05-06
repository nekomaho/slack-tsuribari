# Change log

## 0.2.0 / 2020-05-06
- [Add raise error when http response is not 200](https://github.com/nekomaho/slack-tsuribari/pull/4)

**BREAKING CHANGES**

From v0.2.0, if slack does not return 200 as HTTP status code, exception will be raised by default.
The exceptions are the same as those raised with `Net::HTTPResponse#value`.
If you don't want to raise the exception like the previous version, specify `raise_error: false` in config.

```
hook = SlackTsuribari::Hook.config do |config|
  config.uri = 'uri'
  config.raise_errror = false
end
```

## 0.1.1 / 2020-04-28
- [Specified the version of rubies ](https://github.com/nekomaho/slack-tsuribari/pull/3)
- [Use ruby/setup-ruby for CI ](https://github.com/nekomaho/slack-tsuribari/pull/2)
- [Add support versions to README](https://github.com/nekomaho/slack-tsuribari/pull/1)

## 0.1.0 / 2020-03-29
* first release
