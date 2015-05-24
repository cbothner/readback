require 'test_helper'

class FreeformShowsControllerTest < ActionController::TestCase
  setup do
    @freeform_show = freeform_shows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:freeform_shows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create freeform_show" do
    assert_difference('FreeformShow.count') do
      post :create, freeform_show: {  }
    end

    assert_redirected_to freeform_show_path(assigns(:freeform_show))
  end

  test "should show freeform_show" do
    get :show, id: @freeform_show
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @freeform_show
    assert_response :success
  end

  test "should update freeform_show" do
    patch :update, id: @freeform_show, freeform_show: {  }
    assert_redirected_to freeform_show_path(assigns(:freeform_show))
  end

  test "should destroy freeform_show" do
    assert_difference('FreeformShow.count', -1) do
      delete :destroy, id: @freeform_show
    end

    assert_redirected_to freeform_shows_path
  end
end
