require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  setup do
    @song = songs
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:songs)
  end
end
