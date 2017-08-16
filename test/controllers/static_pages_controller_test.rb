require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    # Http status check
    assert_response :success
    # operate as selecter
    assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    get static_pages_help_url
    # Http status check
    assert_response :success
    # operate as selecter
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
  	get static_pages_about_url
  	# Http status check
  	assert_response :success
  	# operate as selecter
  	assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end

end
