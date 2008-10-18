require 'test_helper'

class SqlsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sqls)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sql
    assert_difference('Sql.count') do
      post :create, :sql => { }
    end

    assert_redirected_to sql_path(assigns(:sql))
  end

  def test_should_show_sql
    get :show, :id => sqls(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => sqls(:one).id
    assert_response :success
  end

  def test_should_update_sql
    put :update, :id => sqls(:one).id, :sql => { }
    assert_redirected_to sql_path(assigns(:sql))
  end

  def test_should_destroy_sql
    assert_difference('Sql.count', -1) do
      delete :destroy, :id => sqls(:one).id
    end

    assert_redirected_to sqls_path
  end
end
