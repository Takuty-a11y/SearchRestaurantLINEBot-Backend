require "test_helper"

class Line::V1::LineBotControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get line_v1_line_bot_callback_url
    assert_response :success
  end
end
