require 'test_helper'

class DatabsControllerTest < ActionController::TestCase
  
  context "once logged in" do
  
    setup do
      create_database 'sourceforge_test' do
        IO.read("#{Rails.root}/test/fixtures/sourceforge_database_short.sql").split(';').each do |s|
          next if s.blank?
          ActiveRecord::Base.connection.execute s
        end
      end
      @request.session[:username] = @@config['user']
      @request.session[:password] = @@config['password']
    end
  
    should "have 7 tables" do
      get :show, :id => 'sourceforge_test'
      assert_response :success
      assert 7, assigns(:datab).tables.size
    end

  end
end
