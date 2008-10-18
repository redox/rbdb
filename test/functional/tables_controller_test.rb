require File.dirname(__FILE__) + '/../test_helper'

class TablesControllerTest < ActionController::TestCase
  
  setup do
    ActiveRecord::Base.connection.execute "create database sourceforge_test"
    ActiveRecord::Base.connection.execute "use sourceforge_test"
    ActiveRecord::Base.connection.execute IO.read("#{Rails.root}/test/fixtures/sourceforge_database_short.sql")
  end
  
  teardown do
    ActiveRecord::Base.connection.execute "drop database sourceforge_test"
  end
  
  should "have 7 tables" do
    get :controller => 'tables', :id => 'sourceforge'
    assert_response :success
  end
  
    
end
