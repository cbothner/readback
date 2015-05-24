require 'test_helper'

class SpecialtyShowsControllerTest < ActionController::TestCase
  setup do
    @specialty_show = specialty_shows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:specialty_shows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create specialty_show" do
    assert_difference('SpecialtyShow.count') do
      post :create, specialty_show: {  }
    end

    assert_redirected_to specialty_show_path(assigns(:specialty_show))
  end

  test "should show specialty_show" do
    get :show, id: @specialty_show
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @specialty_show
    assert_response :success
  end

  test "should update specialty_show" do
    patch :update, id: @specialty_show, specialty_show: {  }
    assert_redirected_to specialty_show_path(assigns(:specialty_show))
  end

  test "should destroy specialty_show" do
    assert_difference('SpecialtyShow.count', -1) do
      delete :destroy, id: @specialty_show
    end

    assert_redirected_to specialty_shows_path
  end
end
