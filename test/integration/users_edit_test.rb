require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  	def setup
  		@user = users(:michael)
  	end


  	test 'unsuccessful edit' do
	  	# ログインしていないユーザーに対して、ログインを促すようテストに書いたため、ここでは一度ログインさせたように見せる
	  	log_in_as(@user)
	  	# check users/edit viewfile
	  	 get edit_user_path(@user)
	  	 assert_template 'users/edit'
	  	 # invalid user info
	  	 patch user_path(@user),params: { user: { name:  "",
	                                              email: "foo@invalid",
	                                              password:              "foo",
	                                              password_confirmation: "bar" } }
	    # if we fail to update, move to users/edit viewfile again
	     assert_template 'users/edit'
	     # test for correct alert
	     assert_select "div.alert", "The form contains 4 errors."
  	end

  	test 'successful edit with friendly forwarding' do
	  	# ログインしていないユーザーに対して、ログインを促すようテストに書いたため、ここでは一度ログインさせたように見せる
	  	get edit_user_path(@user)
	  	assert session[:forwarding_url]
	    log_in_as(@user)
	    assert_redirected_to edit_user_url(@user) || default
	    name  = "Foo Bar"
	    email = "foo@bar.com"
	    patch user_path(@user), params: { user: { name:  name,
	                                              email: email,
	                                              password:              "",
	                                              password_confirmation: "" } }
	    # if we success flashed
	    assert_not flash.empty?
	    # check redirect
	    assert_redirected_to @user
	    @user.reload
	    # check name is equal
	    assert_equal name,  @user.name
	    # check email is equal
	    assert_equal email, @user.email
  	end

  	end
