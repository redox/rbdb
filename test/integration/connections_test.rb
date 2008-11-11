require File.dirname(__FILE__) + '/../test_helper'

class ConnectionsTest < ActionController::IntegrationTest
  
  def setup
    super
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_one_valid_user_and_one_fake
    valid_user = open_session
    valid_user.post '/accounts/login', :username => @@config['user'],
      :password => @@config['password']
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
