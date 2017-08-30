require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
  	@user = User.new(name: "example", email: "user@example.com",password:"foobar",password_confirmation:"foobar")
  end
    # test code about name
    #========================================================================================================================================

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be presence" do
  	@user.name = ""
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a"*51
  	assert_not @user.valid?
  end

  # test code about email
  #========================================================================================================================================

  test "email should be presence" do
  	@user.email = "  "
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a"* 244 + "@example.com"
  	assert_not @user.valid?
  end

   test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
	end

	test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

    # test code for password
    #========================================================================================================================================
  test "password should be present(nonblank)" do
  	@user.password = @user.password_confirmation = " "*6
  	assert_not @user.valid?
  end

  test "password should have a minimum length" do
  	@user.password = @user.password_confirmation = "a"*5
  	assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember,'')
  end

  # test code for micropost
    #========================================================================================================================================
  # if admin destroy user , it should delete with microposts
  test "associated microposts should be destroyed" do
    # ユーザーを作成
    @user.save
    # マイクロソフトを作成
    @user.microposts.create!(content: "Lorem ipsum")
    # マイクロソフトの数が当たっているか確認。
    assert_difference 'Micropost.count', -1 do
      # ユーザーを削除する。
      @user.destroy
    end
  end
end
