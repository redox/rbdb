# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require "#{RAILS_ROOT}/vendor/plugins/override_rake_task/lib/override_rake_task.rb"

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
