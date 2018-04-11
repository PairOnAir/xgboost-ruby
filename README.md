# Xgboost - Ruby bindings for Xgboost

[![Build Status](https://travis-ci.org/PairOnAir/xgboost-ruby.svg?branch=master)](https://travis-ci.org/PairOnAir/xgboost-ruby)

This gem provides Ruby bindings to the [Xgboost](https://github.com/dmlc/xgboost) library. Xgboost is a Scalable, Portable and Distributed Gradient Boosting Library.

The gem itself is currently in alpha stage and is not yet tested for use in production.

## Dependency on the XGBoost shared library

The gem uses FFI to communicate with the shared XGBoost library (libxgboost.so on Linux or libxgboost.dylib on Mac). It'll look for it in `/usr/lib`, `/usr/local/lib`, or its own `vendor/xgboost/lib` directories.

To compile the library, you have the following options:

1. (easiest) Run `rake -r xgboost/rake xgboost:install`

   This will clone and compile the **latest version** of dmlc/xgboost, using [this script](https://github.com/PairOnAir/xgboost-ruby/blob/master/bin/install_xgboost).

2. (easy, stable) Run `rake -r xgboost/rake xgboost:install[GIT_SHA]`

   This will clone and compile the given commit SHA1 of [dmlc/xgboost](https://github.com/dmlc/xgboost). This way you're making sure you're locking to the same version of XGBoost across development, CI, staging, and production.

3. (full control) Compile xgboost yourself and put it in `/usr/local/lib`, e.g.:

   ```bash
   git clone --recurse-submodules https://github.com/dmlc/xgboost.git && cd xgboost && make
   ln -s $(pwd)/lib/libxgboost.[ds]* /usr/local/lib
   # or:
   cp $(pwd)/lib/libxgboost.[ds]* /usr/local/lib
   ```

   Depending on your platform, compiling xgboost from source will probably be more tricky than that, please consult the [XGBoost docs](http://xgboost.readthedocs.io/en/latest/build.html) for help.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xgboost'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xgboost

## Usage

This gem is mostly useful for inference, for example as part of a Rails request, when you've trained your model using Python or xgboost4j and saved its serialized state to a file, e.g. `my.model`:

```ruby
booster = Xgboost::Booster.new
booster.load('my.model')

# Predict a single example
booster.predict([-7.0, 0.0, 2.0]) # => 0.87

# Predict an array of examples
booster.predict([
  [-7.0, 1.0, 2.0],
  [15.0, 3.0, 1.1, 1.0],
  [3.0, Float::NAN, 0.0],
]) # => [0.87, 0.01, 0.15]
```

By default, `Float::NAN` is used to impute missing values. You can change that using the `missing` argument:

```ruby
booster.predict([-7.0, nil, 2.0], missing: 0.0) # same as booster.predict([-7.0, 0.0, 2.0])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies and compile XGBoost. Then, run `rake` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment. To install this gem onto your local machine, run `bundle exec rake install`. To release
a new version, update the version number in `version.rb` and in `CHANGELOG.md`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/PairOnAir/xgboost. This
project is intended to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Xgboost project’s codebases, issue trackers, chat rooms and mailing
lists is expected to follow the [code of conduct](https://github.com/PairOnAir/xgboost/blob/master/CODE_OF_CONDUCT.md).
