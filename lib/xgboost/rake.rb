require 'rake'
require 'xgboost/root'

# Ugh, we can't ship it like this: people will put this in their Gemfile:
#
#     gem 'xgboost'
#
# On app boot, `Bundler.require` will call `require 'xgboost'`,
# which in turn calls `require 'xgboost/ffi'`. This will crash,
# because FFI is trying to load libxgbooost (which isn't compiled yet).
#
# This means that people would first need to put this in their Gemfile:
#
#     gem 'xgboost', require: false
#
# then add `require 'xgboost/rake'` to their Rakefile, run `rake xgboost:install`,
# and then remove `require: false` from Gemfile.
#
# I don't think we should install xgboost as part of `require 'xgboost'`,
# maybe we should recommend in the README that people put
# `gem 'xgboost', require: 'xgboost/booster'` in their Gemfiles, and
# `require 'xgboost/rake'` in their Rakefile. Then, all devs would need to run
# `rake xgboost:install` once (or have /usr/local/lib/libxgboost.(so|dylib)).
#
# We shouldn't force people to use our vendor'd xgboost without allowing them
# to lock it to a specific commit, for production we should either provide
# something like `rake xgboost:install[443ff74]` or encourage people to
# compile xgboost themselves and symlink it to /usr/local/lib.
module Xgboost
  module Rake
    extend ::Rake::DSL

    def self.install
      namespace :xgboost do
        desc 'Clones and compiles xgboost'
        task :install do
          `#{Xgboost.root}/bin/install_xgboost.sh`
        end
      end
    end
  end
end

Xgboost::Rake.install
