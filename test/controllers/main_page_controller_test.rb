require 'test_helper'

class MainPageControllerTest < ActionDispatch::IntegrationTest
  test "should get display" do
    get main_page_display_url
    assert_response :success
  end

end
