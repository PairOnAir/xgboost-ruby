# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xgboost/version"

Gem::Specification.new do |spec|
  spec.name          = "xgboost"
  spec.version       = Xgboost::VERSION
  spec.authors       = ["Harald Wartig", "Olek Janiszewski"]
  spec.email         = ["hwartig@gmail.com", "olek.janiszewski@gmail.com"]

  spec.summary       = %q{Ruby binding for XGBoost}
  spec.description   = %q{Ruby binding for XGBoost}
  spec.homepage      = "https://github.com/hwartig/xgboost-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^spec/})
  end
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/xgboost/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec", "~> 3.0"
end
