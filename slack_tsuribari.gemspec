# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slack_tsuribari/version'

Gem::Specification.new do |spec|
  spec.name          = "slack_tsuribari"
  spec.version       = SlackTsuribari::VERSION
  spec.authors       = ["nekomaho"]
  spec.email         = ["nekosatoru@gmail.com"]

  spec.summary       = %q{This gem can post messages to the channel using slack's incoming webhook.}
  spec.description   = %q{A gem to help post to slack using webhook}
  spec.homepage      = "https://github.com/nekomaho/slack-tsuribari"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "< 1.0"
  spec.add_development_dependency "pry"
end
