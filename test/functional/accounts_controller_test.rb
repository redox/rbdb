require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  should "log in" do
    post :login, :username => @@config['user'], :password => @@config['password']
    assert_response :redirect, flash.inspect
    assert_redirected_to '/databs'
  end
  
end
