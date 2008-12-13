require File.dirname(__FILE__) + '/../test_helper'

class TablesControllerTest < ActionController::TestCase

  def setup
    super
    @request.session[:username] = @@config['user']
    @request.session[:password] = @@config['password']
    create_database 'rbdb_test1' do |datab|
      datab.create_table 'databs' do end
      datab.create_table 'TABLES' do end
      datab.create_table 'new_table1' do |t|
        t.string :field1, :limit => 1
        t.integer :parent_id, :null => false
        t.boolean :test, :null => false, :default => false
      end
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
  
  should "create but fail because table already exists" do
    post :create, :datab_id => 'rbdb_test1', :table => {
      :name => "databs",
      :fields => {
        'id' => {:name => 'id', :type => 'int'}
      }
    }
    assert_response :success
  end

  should "should go to the new table form" do
    get :new, :datab_id => 'rbdb_test1', :name => "toto"
    assert_response :success
  end
  
  should "get edit page" do
    get :edit, :datab_id => "rbdb_test1", :id => 'new_table1'
    assert_response :success
  end
    
  should "get an inexistant table edit page" do
    get :edit, :datab_id => "rbdb_test1", :id => 'DOES_NOT_EXIST'
    assert_response :redirect
    assert_redirected_to :controller => '/databs', :action => :index
  end
  
  should "add a field" do
    post :update, :datab_id => 'rbdb_test1', :id => 'new_table1', :table => {
      :name => 'new_table1',
      :fields => {
        'id' => {:name => 'id', :type => 'integer', :primary => "1", :default => '', :extra => 'auto_increment', :limit => 11, :null => "0"},
        'field1' => {:name => 'field1', :type => 'string', :primary => "0", :default => '', :extra => '', :limit => 255, :null => "1"},
        'parent_id' => {:name => 'parent_id', :type => 'integer', :primary => "0", :default => '', :extra => 'auto_increment', :limit => 11, :null => "0"},
        'test' => {:name => 'test', :type => 'boolean', :primary => "0", :default => '0', :extra => 'auto_increment', :limit => 1, :null => "0"},
      }
    }
    assert_response :redirect, assigns(:table).errors.inspect
    assert_redirected_to :controller => '/tables', :action => :show, :id => 'new_table1',
      :datab_id => 'rbdb_test1'
    assert_equal 4, assigns(:table).columns.size
    assert_equal 4, assigns(:table).fields.size
  end
    
  should "remove a field" do
    post :update, :datab_id => 'rbdb_test1', :id => 'new_table1', :table => {
      :name => 'new_table1',
      :fields => {
        'id' => {:name => 'id', :type => 'integer', :primary => "1", :default => '', :extra => 'auto_increment', :limit => 11, :null => "0"},
        'field1' => {:name => 'field1', :type => 'string', :primary => "0", :default => '', :extra => '', :limit => 255, :null => "1"}
      }
    }
    assert_response :redirect, assigns(:table).errors.inspect
    assert_redirected_to :controller => '/tables', :action => :show, :id => 'new_table1',
      :datab_id => 'rbdb_test1'
    assert_equal 2, assigns(:table).columns.size
    assert_equal 2, assigns(:table).fields.size
  end
    
end
