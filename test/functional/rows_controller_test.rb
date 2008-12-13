require 'test_helper'

class RowsControllerTest < ActionController::TestCase
  
  def setup
    super
    @request.session[:username] = @@config['user']
    @request.session[:password] = @@config['password']
    create_database 'rbdb_test1' do |datab|
      datab.create_table 'databs' do |t|
        t.string :field1, :limit => 1
        t.integer :association_id, :null => false
        t.boolean :test, :null => false, :default => false
      end
      datab.create_table 'associations' do |t|
        t.string :name
      end      
    end
  end
  
  should "display 0 result if no data found in association" do
    get :index, :id => 'databs', :datab_id => 'rbdb_test1', :field=>'association_id', :value => '82533'
    assert_response :success
  end
  
  
end
