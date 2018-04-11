require 'rake'
require 'xgboost'

module Xgboost
  module Rake
    extend ::Rake::DSL

    def self.add_tasks
      namespace :xgboost do
        desc 'Clones and compiles xgboost'
        task :install, :sha do |_t, args|
          cmd_args = [args[:sha]].compact
          system(File.join(Xgboost.root, 'bin', 'install_xgboost'), *cmd_args)
        end
      end
    end
  end
end

Xgboost::Rake.add_tasks
