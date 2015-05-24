require 'test_helper'

class TalkShowsControllerTest < ActionController::TestCase
  setup do
    @talk_show = talk_shows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:talk_shows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create talk_show" do
    assert_difference('TalkShow.count') do
      post :create, talk_show: {  }
    end

    assert_redirected_to talk_show_path(assigns(:talk_show))
  end

  test "should show talk_show" do
    get :show, id: @talk_show
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @talk_show
    assert_response :success
  end

  test "should update talk_show" do
    patch :update, id: @talk_show, talk_show: {  }
    assert_redirected_to talk_show_path(assigns(:talk_show))
  end

  test "should destroy talk_show" do
    assert_difference('TalkShow.count', -1) do
      delete :destroy, id: @talk_show
    end

    assert_redirected_to talk_shows_path
  end
end
