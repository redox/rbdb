require 'test_helper'

class DatabsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:databs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_datab
    assert_difference('Datab.count') do
      post :create, :datab => { }
    end

    assert_redirected_to datab_path(assigns(:datab))
  end

  def test_should_show_datab
    get :show, :id => databs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => databs(:one).id
    assert_response :success
  end

  def test_should_update_datab
    put :update, :id => databs(:one).id, :datab => { }
    assert_redirected_to datab_path(assigns(:datab))
  end

  def test_should_destroy_datab
    assert_difference('Datab.count', -1) do
      delete :destroy, :id => databs(:one).id
    end

    assert_redirected_to databs_path
  end
end
