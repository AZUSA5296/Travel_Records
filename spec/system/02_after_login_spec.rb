require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:other_post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※「ログアウト」は『ユーザログアウトのテスト』でテスト済み' do
      subject { current_path }

      it 'ロゴを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it '「このサイトについて」を押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[1].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/'
      end
      it '「タイムライン」を押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[2].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/posts'
      end
      it '「新規投稿」を押すと、新規投稿画面に遷移する' do
        new_post_link = find_all('a')[3].native.inner_text
        new_post_link = new_post_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link new_post_link
        is_expected.to eq '/posts/new'
      end
      it '「マイページ」を押すと、ユーザー詳細画面に遷移する' do
        user_link = find_all('a')[4].native.inner_text
        user_link = user_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link user_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '「ユーザー」を押すと、ユーザー一覧画面に遷移する' do
        users_link = find_all('a')[5].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users.' + user.id.to_s
      end
        it '「通知」を押すと、通知一覧画面に遷移する' do
        notifications_link = find_all('a')[6].native.inner_text
        notifications_link = notifications_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link notifications_link
        is_expected.to eq '/notifications'
      end
        it '「ログアウト」を押すと、トップ画面に遷移する' do
        logout_link = find_all('a')[7].native.inner_text
        logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link logout_link
        is_expected.to eq '/'
      end
    end
  end

  describe "投稿一覧画面のテスト" do
    before do
      user.follow(other_user)
      other_user.follow(user)
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の投稿画像のリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post)
        expect(page).to have_link '', href: post_path(other_post)
      end
       it '自分と他人の投稿のタイトルが表示される' do
        expect(page).to have_content post.title
        expect(page).to have_content other_post.title
      end
      it '自分と他人の投稿の日付が表示される' do
        expect(page).to have_content post.date.strftime("%Y年%m月%d日")
        expect(page).to have_content other_post.date.strftime("%Y年%m月%d日")
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分と他人の投稿の投稿の内容が表示される' do
        expect(page).to have_content post.content
        expect(page).to have_content other_post.content
      end
      it '自分と他人の投稿のいいねボタンが表示される' do
        expect(page).to have_link '', href: post_favorites_path(post)
         expect(page).to have_link '', href: post_favorites_path(other_post)
      end
      it '自分と他人の投稿のいいね数が表示される' do
        expect(page).to have_content post.favorites.count
        expect(page).to have_content other_post.favorites.count
      end
      it '自分と他人の投稿のコメントボタンが表示される' do
        expect(page).to have_link '', href: post_path(post)
        expect(page).to have_link '', href: post_path(other_post)
      end
      it '自分と他人の投稿のコメント数が表示される' do
        expect(page).to have_content post.comments.count
         expect(page).to have_content other_post.comments.count
      end
    end
  end

  describe "新規投稿画面のテスト" do
    before do
      visit new_post_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq('/posts/new')
      end
      it '「タイトル」フォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it '「日付」フォームが表示される' do
        expect(page).to have_field 'post[date(1i)]'
        expect(page).to have_field 'post[date(2i)]'
        expect(page).to have_field 'post[date(3i)]'
      end
      it '画像選択のフォームが表示される' do
        expect(page).to have_field 'post[image]'
      end
      it '「テキスト」フォームが表示される' do
        expect(page).to have_field 'post[content]'
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        select '2021', from: 'post_date_1i'
        select '1', from: 'post_date_2i'
        select '1', from: 'post_date_3i'
        attach_file "post[image]", "app/assets/images/image1.jpg"
        fill_in 'post[content]', with: Faker::Lorem.characters(number: 50)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '投稿' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、タイムラインになっている' do
        click_button '投稿'
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe "自分の投稿詳細画面のテスト" do
    before do
      visit post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '投稿の画像が表示される' do
        expect(page).to have_selector("img[src$='image']")
      end
       it '投稿のタイトルが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿の日付が表示される' do
        expect(page).to have_content post.date.strftime("%Y年%m月%d日")
      end
      it '自分の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
      end
      it '投稿の内容が表示される' do
        expect(page).to have_content post.content
      end
      it '投稿のいいねボタンが表示される' do
        expect(page).to have_link '', href: post_favorites_path(post)
      end
      it '投稿のいいね数が表示される' do
        expect(page).to have_content post.favorites.count
      end
      it '投稿のコメント数が表示される' do
        expect(page).to have_content post.comments.count
      end
      it '削除リンクが存在しているか' do
        expect(page).to have_link '', href: post_path(post)
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link '', href: edit_post_path(post)
      end
    end

    context 'コメントエリアのテスト' do
      it '「コメント」と表示される' do
        expect(page).to have_content 'コメント'
      end
      it 'コメントの全件数が表示される' do
        expect(page).to have_content "#{post.comments.count}件"
      end
      it 'コメント入力エリアが表示される' do
        expect(page).to have_field 'comment[comment]'
        expect(page).to have_button 'コメントを送る'
      end
    end

    context 'リンクの内容を確認' do
      it '編集のボタンのリンク先が編集画面になっているか' do
        click_link 'edit-btn'
        expect(current_path).to eq('/posts/' + post.id.to_s + '/edit')
      end
    end

    context '投稿削除のテスト' do
      it '投稿の削除' do
        expect{ post.destroy }.to change{ Post.count }.by(-1)
      end
    end
  end

  describe '投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it '「Edit」と表示される' do
        expect(page).to have_content 'Edit'
      end
      it '編集前のタイトルがフォームに表示されている' do
        expect(page).to have_field 'post[title]', with: post.title
      end
      it '編集前の日付がフォームに表示されている' do
        expect(page).to have_field 'post[date(1i)]', with: 2020
        expect(page).to have_field 'post[date(2i)]', with: 1
        expect(page).to have_field 'post[date(3i)]', with: 1
      end
      it '画像フォームが表示されている' do
        expect(page).to have_field 'post[image]'
      end
      it '編集前のテキストがフォームに表示されている' do
        expect(page).to have_field 'post[content]', with: post.content
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新する'
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_title = post.title
        @post_old_date = post.date
        @post_old_image1 = post.image
        @post_old_content = post.content
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        select '2021', from: 'post_date_1i'
        select '1', from: 'post_date_2i'
        select '1', from: 'post_date_3i'
        attach_file "post[image]", "app/assets/images/image1.jpg"
        fill_in 'post[content]', with: Faker::Lorem.characters(number: 20)
        click_button '更新する'
      end

      it 'タイトルが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it '日付が正しく更新される' do
        expect(post.reload.date).not_to eq @post_old_date
      end
      it '画像が正しく更新される' do
        expect(post.reload.image).not_to eq @post_old_image
      end
      it 'テキストが正しく更新される' do
        expect(post.reload.content).not_to eq @post_old_content
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(other_user)
      end
      it '他人の名前が表示される' do
        expect(page).to have_content other_user.name
      end
      it '他人のニックネームが表示される' do
        expect(page).to have_content other_user.nickname
      end
      it '他人の自己紹介が表示される' do
        expect(page).to have_content other_user.introduction
      end
      it '他人の投稿数が表示される' do
        expect(page).to have_content other_user.posts.count
      end
      it '他人のフォロー数が表示される' do
        expect(page).to have_content other_user.following.count
      end
      it '他人のフォロワー数が表示される' do
        expect(page).to have_content other_user.followers.count
      end
      it 'フォローボタンが表示される' do
        expect(page).to have_button 'フォローする'
      end
      it '自分のアカウントが表示されない' do
        expect(page).not_to have_content user.name
      end
    end

    context '検索エリアの確認' do
      it '検索フォームが表示されている' do
        expect(page).to have_field 'keyword'
      end
      it '検索ボタンが表示される' do
        expect(page).to have_button ''
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '「My page」と表示されている' do
        expect(page).to have_content 'My page'
      end
      it '自分のプロフィール画像が表示される' do
        expect(page).to have_selector("img[src$='profile_image']")
      end
      it '自分のニックネームが表示される' do
        expect(page).to have_content user.nickname
      end
      it '自分の誕生日が表示される' do
        expect(page).to have_content user.birthday.strftime("%-m月%-d日")
      end
      it '自分の自己紹介が表示される' do
        expect(page).to have_content user.introduction
      end
      it '自分の投稿数が表示される' do
        expect(page).to have_content user.posts.count
      end
      it '自分のフォロー数が表示され、リンクが存在する' do
        expect(page).to have_content user.following.count
        expect(page).to have_link '0', href: following_user_path(user)
      end
      it '自分のフォロワー数が表示され、リンクが存在する' do
        expect(page).to have_content user.followers.count
        expect(page).to have_link '0', href: followers_user_path(user)
      end
      it '「プロフィール編集」のリンクが存在する' do
        expect(page).to have_link 'プロフィール編集', href: edit_user_path(user)
      end
    end

    context '投稿一覧の確認' do
      it '投稿一覧に自分の投稿画像が表示され、リンクが正しい' do
        expect(page).to have_selector("img[src$='image']")
        expect(page).to have_link '', href: post_path(post)
      end
      it '投稿一覧に自分の投稿のタイトルが表示される' do
        expect(page).to have_content post.title
      end
      it '自分の投稿のいいねボタンが表示される' do
        expect(page).to have_link '', href: post_favorites_path(post)
      end
      it '自分の投稿のいいね数が表示される' do
        expect(page).to have_content post.favorites.count
      end
      it '自分の投稿のコメントボタンが表示される' do
        expect(page).to have_link '', href: post_path(post)
      end
      it '自分の投稿のコメント数が表示される' do
        expect(page).to have_content post.comments.count
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link other_post.title
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '「Edit」と表示されている' do
        expect(page).to have_content 'Edit'
      end
      it '氏名編集フォームに自分の氏名が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it 'ニックネーム編集フォームに自分のニックネームが表示される' do
        expect(page).to have_field 'user[nickname]', with: user.nickname
      end
      it 'メールアドレス編集フォームに自分のメールアドレスが表示される' do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it '生年月日編集フォームに自分の生年月日が表示される' do
        expect(page).to have_field 'user[birthday(1i)]', with: 1990
        expect(page).to have_field 'user[birthday(2i)]', with: 1
        expect(page).to have_field 'user[birthday(3i)]', with: 1
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '「更新する」ボタンが表示される' do
        expect(page).to have_button '更新する'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_nickname = user.nickname
        @user_old_email = user.email
        @user_old_birthday = user.birthday
        @user_old_profile_image = user.profile_image
        @user_old_introduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[email]', with: Faker::Internet.email
        select '2001', from: 'user_birthday_1i'
        select '1', from: 'user_birthday_2i'
        select '1', from: 'user_birthday_3i'
        attach_file "user[profile_image]", "app/assets/images/image1.jpg"
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button '更新する'
      end

      it '氏名が正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'ニックネームが正しく更新される' do
        expect(user.reload.nickname).not_to eq @user_old_nickname
      end
      it 'メールアドレスが正しく更新される' do
        expect(user.reload.email).not_to eq @user_old_email
      end
      it '生年月日が正しく更新される' do
        expect(user.reload.birthday).not_to eq @user_old_birthday
      end
      it 'プロフィール画像が正しく更新される' do
        expect(user.reload.profile_image).not_to eq @user_old_profile_image
      end
      it '自己紹介が正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe 'コメント機能のテスト' do
    let!(:other_user2) { create(:user) }
    let!(:other_post2) { create(:post, user: other_user2) }
    let!(:comment) { create(:comment, user: user, post: other_post2) }
    let!(:other_comment) { create(:comment, user: other_user, post: other_post2) }

    before do
      visit post_path(other_post2)
    end

    context '表示の確認' do
      it '自分と他人のニックネームが表示される' do
        expect(page).to have_content user.nickname
        expect(page).to have_content other_user.nickname
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
        expect(page).to have_link '', href: user_path(other_user)
      end
      it '自分と他人のコメントの内容が表示される' do
        expect(page).to have_content comment.comment
        expect(page).to have_content other_comment.comment
      end
      it '自分と他人のコメントの送信日時が表示される' do
        expect(page).to have_content comment.created_at.strftime('%Y/%m/%d %H:%M')
        expect(page).to have_content other_comment.created_at.strftime('%Y/%m/%d %H:%M')
      end
      it '自分のコメントの削除リンクが表示される' do
        expect(page).to have_link 'delete-' + comment.id.to_s + '-btn'
      end
      it '他人のコメントの削除リンクは表示されない' do
        expect(page).not_to have_link 'delete-' + other_comment.id.to_s + '-btn'
      end
    end

    context '新規コメント送信のテスト' do
      before do
        fill_in 'comment[comment]', with: Faker::Lorem.characters(number: 10)
      end

      it '正しく送信される' , js: true do
        expect do
          click_button 'コメントを送る'
          sleep 1
        end.to change { user.comments.count }.by(1)
      end
      it 'リダイレクト先が、投稿詳細画面になっている', js: true do
        expect(current_path).to eq '/posts/' + other_post2.id.to_s
      end
    end

    context '削除のテスト' do
      it '正しく削除される' , js: true do
        expect do
          find(".trash").click
          sleep 1
        end.to change { user.comments.count }.by(-1)
      end
      it 'リダイレクト先が、投稿詳細画面になっている', js: true do
        expect(current_path).to eq '/posts/' + other_post2.id.to_s
      end
    end
  end

  describe 'フォロー機能のテスト' do
    context 'フォロー・フォロワー一覧のページのテスト' do
      let!(:other_user2) { create(:user) }

      before do
        user.follow(other_user)
        user.follow(other_user2)
        other_user.follow(user)
      end

      it 'フォロー一覧:「(自分のニックネーム)Following」と表示される' do
        visit following_user_path(user)
        expect(page).to have_content user.nickname
        expect(page).to have_content "Following"
      end
      it 'フォロー一覧:自分がフォローしているユーザーの情報が表示される' do
        visit following_user_path(user)
        expect(page).to have_selector("img[src$='profile_image']")
        expect(page).to have_content other_user.nickname
        expect(page).to have_content other_user.posts.count
        expect(page).to have_content other_user.introduction
        expect(page).to have_button 'フォローを外す'
      end
      it 'フォロワー一覧:「(自分のニックネーム)Followers」と表示される' do
        visit followers_user_path(user)
        expect(page).to have_content user.nickname
        expect(page).to have_content "Followers"
      end
      it 'フォロワー一覧:自分をフォローしているユーザーの情報が表示される' do
        visit followers_user_path(user)
        expect(page).to have_selector("img[src$='profile_image']")
        expect(page).to have_content other_user.nickname
        expect(page).to have_content other_user.posts.count
        expect(page).to have_content other_user.introduction
        expect(page).to have_button 'フォローを外す'
      end
    end

    context 'フォロー・フォロー解除のテスト' do
      before do
        visit user_path(other_user)
      end

      it 'フォローする：フォロー数が1となり、ボタンが「フォローを外す」に変化する', js: true do
        click_button 'フォローする'
        sleep 1
        expect(other_user.followers.count).to eq 1
        expect(page).to have_button 'フォローを外す'
      end
      it 'フォローを外す：フォロー数が0となり、ボタンが「フォローする」に変化する', js: true do
        click_button 'フォローする'
        sleep 1
        click_button 'フォローを外す'
        sleep 1
        expect(other_user.followers.count).to eq 0
        expect(page).to have_button 'フォローする'
      end
    end
  end

  describe '通知機能のテスト' do

    context 'いいね・コメント通知のテスト' do
      before do
        visit post_path(other_post)
      end

      it '他人がいいねした通知が表示される：他人のニックネームと「あなたの投稿」のリンク先が正しいか', js: true do
        find("#un-favorite-btn").click
        sleep 1
        click_link 'ログアウト'
        visit new_user_session_path
        fill_in 'user[email]', with: other_user.email
        fill_in 'user[password]', with: other_user.password
        click_button 'ログイン'
        visit notifications_path
        expect(page).to have_content "#{ user.nickname }があなたの投稿にいいねしました"
        expect(page).to have_link user.nickname, href: user_path(user)
        expect(page).to have_link 'あなたの投稿', href: post_path(other_post)
      end

      it '他人がコメントした通知が表示されるか：他人のニックネームと「あなたの投稿」のリンク先が正しいか', js: true  do
        fill_in 'comment[comment]', with: Faker::Lorem.characters(number: 50)
        click_button 'コメントを送る'
        sleep 1
        click_link 'ログアウト'
        visit new_user_session_path
        fill_in 'user[email]', with: other_user.email
        fill_in 'user[password]', with: other_user.password
        click_button 'ログイン'
        visit notifications_path
        expect(page).to have_content "#{ user.nickname }があなたの投稿にコメントしました"
        expect(page).to have_link user.nickname, href: user_path(user)
        expect(page).to have_link 'あなたの投稿', href: post_path(other_post)
      end
    end

    context 'フォロー、通知表示、通知削除のテスト' do
      before do
        visit user_path(other_user)
      end

      it '他人がフォローした通知が表示されるか:他人のニックネームのリンク先が正しいか', js: true do
        click_button 'フォローする'
        sleep 1
        click_link 'ログアウト'
        visit new_user_session_path
        fill_in 'user[email]', with: other_user.email
        fill_in 'user[password]', with: other_user.password
        click_button 'ログイン'
        sleep 1
        visit notifications_path
        expect(page).to have_content "#{ user.nickname }があなたをフォローしました"
        expect(page).to have_link user.nickname, href: user_path(user)
      end

      it '「全て削除」を押すと通知が消去され、「通知はありません」と表示されるか', js: true do
        click_button 'フォローする'
        sleep 1
        click_link 'ログアウト'
        visit new_user_session_path
        fill_in 'user[email]', with: other_user.email
        fill_in 'user[password]', with: other_user.password
        click_button 'ログイン'
        sleep 1
        visit notifications_path
        click_link '全て削除'
        expect(page).not_to have_content "#{ user.nickname }があなたをフォローしました"
        expect(page).to have_content "通知はありません"
      end
    end
  end

  describe 'いいね機能のテスト' do

    context '投稿詳細画面でのテスト' do
      before do
        visit post_path(post)
      end

      it 'いいねを押す', js: true do
        expect do
          find("#un-favorite-btn").click
          sleep 1
        end.to change { post.favorites.count }.by(1)
      end
      it 'いいねを取り消す', js: true do
        find("#un-favorite-btn").click
        sleep 1
        expect do
          find("#favorite-btn").click
          sleep 1
        end.to change { post.favorites.count }.by(-1)
      end
    end

    context '投稿一覧画面でのテスト' do
      before do
        visit posts_path
      end

      it 'いいねを押す', js: true do
        expect do
          find("#un-favorite-btn").click
          sleep 1
        end.to change { post.favorites.count }.by(1)
      end
      it 'いいねを取り消す', js: true do
        find("#un-favorite-btn").click
        sleep 1
        expect do
          find("#favorite-btn").click
          sleep 1
        end.to change { post.favorites.count }.by(-1)
      end
    end
  end

end