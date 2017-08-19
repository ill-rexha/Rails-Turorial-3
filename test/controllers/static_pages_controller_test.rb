require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

	def setup
		@base_title = "Ruby on Rails Tutorial Sample App"
	end
	
  test "shoud get root" do
  	get root_url
  	assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get help_path
    # Http status check
    assert_response :success
    # operate as selecter
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
  	get about_path
  	# Http status check
  	assert_response :success
  	# operate as selecter
  	assert_select "title", "About | #{@base_title}"
  end

  test "shoud get contact" do
  	get contact_path
  	assert_response :success
  	assert_select "title", "Contact | #{@base_title}"
  end

end
