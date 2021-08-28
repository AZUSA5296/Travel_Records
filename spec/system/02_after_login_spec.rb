require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
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
        is_expected.to eq '/user' + user.id.to_s
      end
      it '「ユーザー」を押すと、ユーザー一覧画面に遷移する' do
        users_link = find_all('a')[5].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link usesr_link
        is_expected.to eq '/users' + user.id.to_s
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
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の投稿画像のリンク先がそれぞれ正しい' do
        expect(page).to have_link '', href: post_path(post)
        expect(page).to have_link '', href: post_path(other_post)
      end
       it '自分と他人の投稿のタイトルが表示される' do
        expect(page).to have_content post.title
        expect(page).to have_content other_post.title
      end
      it '自分と他人の投稿の日付が表示される' do
        expect(page).to have_content post.date.strftime("%Y年%-m月%-d日")
        expect(page).to have_content other_post.date.strftime("%Y年%-m月%-d日")
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分の投稿と他人の投稿の内容が表示される' do
        expect(page).to have_content post.context
        expect(page).to have_content other_post.context
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
        expect(page).to have_link '', href: post_show_path(post)
        expect(page).to have_link '', href: post_favorites_path(other_post)
      end
      it '自分と他人の投稿のコメント数が表示される' do
        expect(page).to have_content post.comments.count
        expect(page).to have_content other_post.comments.count
      end
    end
  end

  describe "新規投稿画面のテスト" do
    before do
      visit posts_new_path
    end

    context '表示の確認' do
      it 'posts_new_pathが"/posts/new"であるか' do
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
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button 'post'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
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
        expect(page).to have_selector("img[src$='image.jpeg']")
      end
       it '投稿のタイトルが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿の日付が表示される' do
        expect(page).to have_content post.date.strftime("%Y年%-m月%-d日")
      end
      it '自分の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
      end
      it '投稿の内容が表示される' do
        expect(page).to have_content post.context
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
        expect(page).to have_link '削除'
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link '編集'
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
      it '編集のボタンのリンクは編集画面か' do
        edit_link = find_all('a')[3]
        edit_link.click
        expect(current_path).to eq('/posts/' + post.id.to_s + '/edit')
      end
    end
    context 'post削除のテスト' do
      it 'postの削除' do
        expect{ post.destroy }.to change{ Post.count }.by(-1)
      end
    end
  end

  describe '投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'post[title]', with: post.title
        expect(page).to have_field 'post[body]', with: post.body
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新する'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number:20)
        click_button '更新する'
        expect(page).to have_current_path post_path(post)
      end
    end
  end
end