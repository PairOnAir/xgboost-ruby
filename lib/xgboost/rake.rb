require 'rake'
require 'xgboost'

module Xgboost
  module Rake
    extend ::Rake::DSL

    def self.add_tasks
      namespace :xgboost do
        desc 'Clones and compiles xgboost'
        task :install do
          `#{Xgboost.root}/bin/install_xgboost.sh`
        end
      end
    end
  end
end

Xgboost::Rake.add_tasks
