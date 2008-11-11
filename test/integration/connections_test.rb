require File.dirname(__FILE__) + '/../test_helper'

class ConnectionsTest < ActionController::IntegrationTest

  def test_one_valid_user_and_one_fake
    conf = YAML.load_file("#{Rails.root}/config/database.yml")['test']
    valid_user = open_session
    valid_user.post '/accounts/login', :username => conf[:username],
      :password => conf[:password]
    valid_user.assert_response :redirect
    valid_user.assert_redirected_to '/databs'
    valid_user.get '/databs'
    valid_user.assert_response :success
    fake_user = open_session
    fake_user.post '/accounts/login', :username => 'phony', :password => 'so fake'
    fake_user.assert_response :success    
    valid_user.get '/databs'
    valid_user.assert_response :success
  end
  
end
