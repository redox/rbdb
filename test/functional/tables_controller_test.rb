require 'test_helper'

class TablesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:tables)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_table
    assert_difference('Table.count') do
      post :create, :table => { }
    end

    assert_redirected_to table_path(assigns(:table))
  end

  def test_should_show_table
    get :show, :id => tables(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => tables(:one).id
    assert_response :success
  end

  def test_should_update_table
    put :update, :id => tables(:one).id, :table => { }
    assert_redirected_to table_path(assigns(:table))
  end

  def test_should_destroy_table
    assert_difference('Table.count', -1) do
      delete :destroy, :id => tables(:one).id
    end

    assert_redirected_to tables_path
  end
end
