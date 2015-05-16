require 'test_helper'

class SignoffInstancesControllerTest < ActionController::TestCase
  setup do
    @signoff_instance = signoff_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:signoff_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create signoff_instance" do
    assert_difference('SignoffInstance.count') do
      post :create, signoff_instance: {  }
    end

    assert_redirected_to signoff_instance_path(assigns(:signoff_instance))
  end

  test "should show signoff_instance" do
    get :show, id: @signoff_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @signoff_instance
    assert_response :success
  end

  test "should update signoff_instance" do
    patch :update, id: @signoff_instance, signoff_instance: {  }
    assert_redirected_to signoff_instance_path(assigns(:signoff_instance))
  end

  test "should destroy signoff_instance" do
    assert_difference('SignoffInstance.count', -1) do
      delete :destroy, id: @signoff_instance
    end

    assert_redirected_to signoff_instances_path
  end
end
