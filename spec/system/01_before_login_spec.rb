require 'rails_helper'
describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    let(:user) { create(:user) }

    before do
      visit top_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'Travel Recordsと表示される' do
        expect(page).to have_content 'Travel Records'
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit top_path
    end

    context '表示内容の確認' do
      it 'Aboutリンクが表示される: 左上から1番目のリンクが「このサイトについて」である' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match('このサイトについて')
      end
      it '新規登録リンクが表示される: 左上から2番目のリンクが「新規登録」である' do
        signup_link = find_all('a')[2].native.inner_text
        expect(signup_link).to match('新規登録')
      end
      it 'ログインリンクが表示される: 左上から3番目のリンクが「ログイン」である' do
        login_link = find_all('a')[3].native.inner_text
        expect(login_link).to match('ログイン')
      end
    end

    context 'リンクの内容を確認' do
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
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[2].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[3].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規会員登録」と表示される' do
        expect(page).to have_content '新規会員登録'
      end
      it '氏名フォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it '「ニックネーム」フォームが表示される' do
        expect(page).to have_field 'user[nickname]'
      end
      it '「生年月日」フォームが表示される' do
        expect(page).to have_field 'user[birthday(1i)]'
        expect(page).to have_field 'user[birthday(2i)]'
        expect(page).to have_field 'user[birthday(3i)]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
      it '「会員の方はこちら」と表示されている' do
        expect(page).to have_content '会員の方はこちら'
      end
      it '「こちら」を押すとログイン画面に遷移する' do
        login_link = find_all('a')[3]
        login_link.click
        expect(current_path).to eq '/users/sign_in'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
        select '2000', from: 'user_birthday_1i'
        select '1', from: 'user_birthday_2i'
        select '1', from: 'user_birthday_3i'
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it '「メールアドレス」フォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it '「ログイン状態を保持する」のチェックボックスが表示されている' do
        expect(page).to have_field 'ログイン状態を保持する'
      end
      it '「新規登録はこちら」と表示されている' do
        expect(page).to have_content '新規登録はこちら'
      end
      it '「こちら」を押すと新規登録画面に遷移する' do
        signup_link = find_all('a')[2]
        signup_link.click
        expect(current_path).to eq '/users/sign_up'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'Aboutリンクが表示される: 左上から1番目のリンクが「このサイトについて」である' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match('このサイトについて')
      end
      it 'タイムラインリンクが表示される: 左上から2番目のリンクが「タイムライン」である' do
        posts_link = find_all('a')[2].native.inner_text
        expect(posts_link).to match('タイムライン')
      end
      it '新規投稿リンクが表示される: 左上から3番目のリンクが「新規投稿」である' do
        new_posts_link = find_all('a')[3].native.inner_text
        expect(new_posts_link).to match('新規投稿')
      end
      it 'マイページリンクが表示される: 左上から4番目のリンクが「マイページ」である' do
        user_link = find_all('a')[4].native.inner_text
        expect(user_link).to match('マイページ')
      end
      it 'ユーザーリンクが表示される: 左上から5番目のリンクが「ユーザー」である' do
        users_link = find_all('a')[5].native.inner_text
        expect(users_link).to match('ユーザー')
      end
      it '通知リンクが表示される: 左上から6番目のリンクが「通知」である' do
        notifications_link = find_all('a')[6].native.inner_text
        expect(notifications_link).to match('通知')
      end
      it 'ログアウトリンクが表示される: 左上から7番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[7].native.inner_text
        expect(logout_link).to match('ログアウト')
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[7].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/#about-visual'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
