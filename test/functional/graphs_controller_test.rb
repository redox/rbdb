require 'test_helper'

class GraphsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:graphs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_graph
    assert_difference('Graph.count') do
      post :create, :graph => { }
    end

    assert_redirected_to graph_path(assigns(:graph))
  end

  def test_should_show_graph
    get :show, :id => graphs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => graphs(:one).id
    assert_response :success
  end

  def test_should_update_graph
    put :update, :id => graphs(:one).id, :graph => { }
    assert_redirected_to graph_path(assigns(:graph))
  end

  def test_should_destroy_graph
    assert_difference('Graph.count', -1) do
      delete :destroy, :id => graphs(:one).id
    end

    assert_redirected_to graphs_path
  end
end
