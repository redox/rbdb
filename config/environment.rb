RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

require "#{Rails.root}/lib/rails_ar_initializer.rb"

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_mbg_session',
    :secret      => '8131eeb6763dab3748795b74ff0257e3d55bd3608f6a829942d942abf1f7791f4784b7ce40d90c6f2f5c32652f907d77548da81076450ecff07d5f4aaeb738ac'
  }
end
