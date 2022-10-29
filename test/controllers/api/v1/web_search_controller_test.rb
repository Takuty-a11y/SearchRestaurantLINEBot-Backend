require "test_helper"

class Api::V1::WebSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_web_search_index_url
    assert_response :success
  end
end
