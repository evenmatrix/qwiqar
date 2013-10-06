require 'test_helper'

class TopUpsControllerTest < ActionController::TestCase
  setup do
    @top_up = top_ups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:top_ups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create top_up" do
    assert_difference('TopUp.count') do
      post :create, top_up: {  }
    end

    assert_redirected_to top_up_path(assigns(:top_up))
  end

  test "should show top_up" do
    get :show, id: @top_up
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @top_up
    assert_response :success
  end

  test "should update top_up" do
    put :update, id: @top_up, top_up: {  }
    assert_redirected_to top_up_path(assigns(:top_up))
  end

  test "should destroy top_up" do
    assert_difference('TopUp.count', -1) do
      delete :destroy, id: @top_up
    end

    assert_redirected_to top_ups_path
  end
end
