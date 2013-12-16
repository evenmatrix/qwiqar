require 'test_helper'

class VaultsControllerTest < ActionController::TestCase
  setup do
    @vault = vaults(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vaults)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vault" do
    assert_difference('Vault.count') do
      post :create, vault: {  }
    end

    assert_redirected_to vault_path(assigns(:vault))
  end

  test "should show vault" do
    get :show, id: @vault
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vault
    assert_response :success
  end

  test "should update vault" do
    put :update, id: @vault, vault: {  }
    assert_redirected_to vault_path(assigns(:vault))
  end

  test "should destroy vault" do
    assert_difference('Vault.count', -1) do
      delete :destroy, id: @vault
    end

    assert_redirected_to vaults_path
  end
end
