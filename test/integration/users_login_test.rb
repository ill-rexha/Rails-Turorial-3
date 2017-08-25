require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
  		@user = users(:michael)
  end

  	test "login with valid infomations" do
 	# login用のpath
  	get login_path
  	#新しいセッションフォームが出来たことを確認
  	assert_template 'sessions/new'
  	# あえて無効なUser情報を入力
  	post login_path, params: { session: { email: "", password: "" } }
  	#flashが表示されているか確認する。
  	 assert_template 'sessions/new'
  	 assert_not flash.empty?
  	 # 別なページに飛ぶ
  	 get root_path
  	 # flashが表示されないか確認する
  	 assert flash.empty?

  	end

  	 test "layout when usr login with valid information " do
  	 get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # code for when user logged out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のwindowでlogoutしたユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  	end

    # チェックボックスのテスト
     test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
