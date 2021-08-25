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

  describe '投稿のテスト' do
    describe 'トップ画面(top_path)のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
      it 'top_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
      it '新規登録リンクが表示される' do
        expect(sign_up_link).to match('新規登録')
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link.click
        expect(current_path).to eq('/users/sign_up')
      end
      it 'ログインリンクが表示される' do
        expect(log_in_link).to match('ログイン')
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link.click
        expect(current_path).to eq('/users/sign_in')
      end
    end
  end

  describe "投稿画面(posts_new_path)のテスト" do
    before do
      visit posts_new_path
    end
    context '表示の確認' do
      it 'posts_new_pathが"/posts/new"であるか' do
        expect(current_path).to eq('/posts/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button '投稿'
        expect(page).to have_current_path post_path(List.last)
      end
    end
  end

  describe "投稿一覧のテスト" do
    before do
      visit posts_path
    end
    context '表示の確認' do
      it '投稿されたものが表示されているか' do
        expect(page).to have_content post.title
        expect(page).to have_link post.title
      end
    end
  end

  describe "詳細画面のテスト" do
    before do
      visit post_path(post)
    end
    context '表示の確認' do
      it '削除リンクが存在しているか' do
        expect(page).to have_link '削除'
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link '編集'
      end
    end
    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
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

  describe '編集画面のテスト' do
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
end