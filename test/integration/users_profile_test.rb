require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
  	@user = users(:michael)
  end

  test "profile display" do
  	# ユーザーのホーム画面に行く
    get user_path(@user)
    # routesで表示されているtemplateが出ていることを確認。
    assert_template 'users/show'
    # タイトルが出ているか確認
    assert_select 'title', full_title(@user.name)
    # usernameがh1タグで出ているか確認。
    assert_select 'h1', text: @user.name
    # 画像が出ているか確認
    assert_select 'h1>img.gravatar'
    # 投稿したmicropostの個数と期待値の数が当たっているか確認。
    assert_match @user.microposts.count.to_s, response.body
    # pagination'があるか確認
    assert_select 'div.pagination', count: 1
   	# paginateで登録している数の分だけ表示されているか。
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
