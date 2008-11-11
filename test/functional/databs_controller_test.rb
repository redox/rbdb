require 'test_helper'

class DatabsControllerTest < ActionController::TestCase
  
  context "once logged in" do
  
    setup do
      ActiveRecord::Base.connection.execute "drop database sourceforge_test" rescue nil
      ActiveRecord::Base.connection.execute "create database sourceforge_test"
      ActiveRecord::Base.connection.execute "use sourceforge_test"
      IO.read("#{Rails.root}/test/fixtures/sourceforge_database_short.sql").split(';').each do |s|
        next if s.blank?
        ActiveRecord::Base.connection.execute s
      end
      @request.session[:username] = 'root'
    end
  
    should "have 7 tables" do
      get :show, :id => 'sourceforge_test'
      assert_response :success
      assert 7, assigns(:datab).tables.size
    end

  end
end
