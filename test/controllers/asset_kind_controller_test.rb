require 'test_helper'

class AssetKindControllerTest < ActionDispatch::IntegrationTest
  test "should get overview" do
    get asset_kind_overview_url
    assert_response :success
  end

end
