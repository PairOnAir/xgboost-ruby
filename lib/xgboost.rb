module Xgboost
  def self.root
    File.expand_path(File.join('..', '..'), __FILE__)
  end

  # eager require wouldn't allow people to use `rake xgboost:install`
  autoload :FFI, 'xgboost/ffi'
end

require 'xgboost/booster'
require 'xgboost/version'
