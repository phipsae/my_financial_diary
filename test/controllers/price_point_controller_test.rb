require 'test_helper'

class sontrollerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get price_point_index_url
    assert_response :success
  end

end
