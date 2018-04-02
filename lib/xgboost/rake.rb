require 'rake'
require 'xgboost'

module Xgboost
  module Rake
    extend ::Rake::DSL

    def self.add_tasks
      namespace :xgboost do
        desc 'Clones and compiles xgboost'
        task :install, :sha do |_t, args|
          system(File.join(Xgboost.root, 'bin', 'install_xgboost'), args[:sha])
        end
      end
    end
  end
end

Xgboost::Rake.add_tasks
