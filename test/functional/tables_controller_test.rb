require File.dirname(__FILE__) + '/../test_helper'

class TablesControllerTest < ActionController::TestCase

  def setup
    @request.session[:username] = 'root'
    create_database 'rbdb_test1' do |datab|
      datab.create_table 'databs' do end
      datab.create_table 'TABLES' do end
    end
  end
  
  should 'handle table names matching our file names' do
    get :show, :id => 'databs', :datab_id => 'rbdb_test1'
    assert_response :success
  end
  
  should 'handle the information_schema db' do
    get :show, :id => 'TABLES', :datab_id => 'rbdb_test1'
    assert_response :success
  end
    
end
