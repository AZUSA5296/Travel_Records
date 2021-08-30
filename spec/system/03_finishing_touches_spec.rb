
require 'rails_helper'

describe '[STEP3] 仕上げのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  describe 'サクセスメッセージのテスト' do
    subject { page }

    it 'ユーザ新規登録成功時' do
      visit new_user_registration_path
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
      fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
      fill_in 'user[email]', with: 'a' + user.email
      select '2000', from: 'user_birthday_1i'
      select '1', from: 'user_birthday_2i'
      select '1', from: 'user_birthday_3i'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button '新規登録'
      is_expected.to have_content 'アカウント登録が完了しました。'
    end
    it 'ユーザログイン成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      is_expected.to have_content 'ログインしました。'
    end
    it 'ユーザログアウト成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[7].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
      is_expected.to have_content 'ログアウトしました。'
    end
    it 'ユーザのプロフィール情報更新成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit edit_user_path(user)
      click_button '更新する'
      is_expected.to have_content 'プロフィールを更新しました。'
    end
    it '新規投稿成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit new_post_path
      fill_in 'post[title]', with: Faker::Lorem.characters(number: 10)
      select '2021', from: 'post_date_1i'
      select '1', from: 'post_date_2i'
      select '1', from: 'post_date_3i'
      attach_file "post[image]", "app/assets/images/image1.jpg"
      fill_in 'post[content]', with: Faker::Lorem.characters(number: 50)
      click_button '投稿'
      is_expected.to have_content '投稿しました。'
    end
    it '投稿の更新成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit edit_post_path(post)
      click_button '更新する'
      is_expected.to have_content '投稿を変更しました。'
    end
    it '投稿の削除成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit post_path(post)
      find(".trash").click
      sleep 1
      is_expected.to have_content '投稿を削除しました。'
    end
  end

  describe '処理失敗時のテスト' do
    context 'ユーザ新規会員登録失敗: 誕生日を未来の日付にする' do
      before do
        visit new_user_registration_path
        @name = Faker::Lorem.characters(number: 10)
        @nickname = Faker::Lorem.characters(number: 10)
        @email = 'a' + user.email
        fill_in 'user[name]', with: @name
        fill_in 'user[nickname]', with: @nickname
        fill_in 'user[email]', with: @email
        select '2021', from: 'user_birthday_1i'
        select '12', from: 'user_birthday_2i'
        select '31', from: 'user_birthday_3i'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '新規登録されない' do
        expect { click_button '新規登録' }.not_to change(User.all, :count)
      end
      it '新規会員登録画面を表示しており、フォームの内容が正しい' do
        click_button '新規登録'
        expect(page).to have_content '新規会員登録'
        expect(page).to have_field 'user[name]', with: @name
        expect(page).to have_field 'user[nickname]', with: @nickname
        expect(page).to have_field 'user[email]', with: @email
        expect(page).to have_field 'user[birthday(1i)]', with: 2021
        expect(page).to have_field 'user[birthday(2i)]', with: 12
        expect(page).to have_field 'user[birthday(3i)]', with: 31
      end
      it 'バリデーションエラーが表示される' do
        click_button '新規登録'
        expect(page).to have_content "誕生日 が無効な日付です。"
      end
    end

    context 'ユーザのプロフィール情報編集失敗: 誕生日を未来の日付にする' do
      before do
        @user_old_birthday = user.birthday
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_user_path(user)
        select '2021', from: 'user_birthday_1i'
        select '12', from: 'user_birthday_2i'
        select '31', from: 'user_birthday_3i'
        click_button '更新する'
      end

      it '更新されない' do
        expect(user.reload.birthday).to eq @user_old_birthday
      end
      it 'ユーザ編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'user[name]', with: user.name
        expect(page).to have_field 'user[nickname]', with: user.nickname
        expect(page).to have_field 'user[email]', with: user.email
        expect(page).to have_field 'user[birthday(1i)]', with: 2021
        expect(page).to have_field 'user[birthday(2i)]', with: 12
        expect(page).to have_field 'user[birthday(3i)]', with: 31
        expect(page).to have_selector("img[src$='profile_image']")
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_content "誕生日"
        expect(page).to have_content "が無効な日付です。"
      end
    end

    context '投稿データの新規投稿失敗: タイトルを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit new_post_path
        @content = Faker::Lorem.characters(number: 50)
        select '2021', from: 'post_date_1i'
        select '1', from: 'post_date_2i'
        select '1', from: 'post_date_3i'
        fill_in 'post[content]', with: @content
      end

      it '投稿が保存されない' do
        expect { click_button '投稿' }.not_to change(Post.all, :count)
      end
      it '新規投稿フォームの内容が正しい' do
        click_button '投稿'
        expect(find_field('post[title]').text).to be_blank
        expect(page).to have_field 'post[date(1i)]', with: 2021
        expect(page).to have_field 'post[date(2i)]', with: 1
        expect(page).to have_field 'post[date(3i)]', with: 1
        expect(page).to have_field 'post[content]', with: @content
      end
      it 'バリデーションエラーが表示される' do
        click_button '投稿'
        expect(page).to have_content "タイトル"
        expect(page).to have_content "を入力してください。"
      end
    end

    context 'コメント送信失敗: コメントを空にする' do
      let!(:other_user2) { create(:user) }
      let!(:other_post2) { create(:post, user: other_user2) }
      let!(:comment) { create(:comment, user: user, post: other_post2) }
      let!(:other_comment) { create(:comment, user: other_user, post: other_post2) }

      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit post_path(other_post2)
      end

      it 'コメントが保存されない', js: true do
        click_button 'コメントを送る'
        sleep 3
        expect.not_to change { user.comments.count }.by(1)
      end
      it 'コメントフォームの内容が正しい', js: true do
        click_button 'コメントを送る'
        sleep 2
        expect(find_field('comment[comment]').text).to be_blank
      end
      it 'バリデーションエラーが表示される', js: true do
        click_button 'コメントを送る'
        sleep 2
        expect(page).to have_content "コメント"
        expect(page).to have_content "を入力してください。"
      end
    end
  end

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'ユーザ一覧画面' do
      visit users_path
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ詳細画面' do
      visit user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ情報編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿編集画面' do
      visit edit_post_path(post)
      is_expected.to eq '/users/sign_in'
    end
    it 'フォロー一覧画面' do
      visit following_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'フォロワー一覧画面' do
      visit followers_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
  end

  describe '他人の画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '他人の投稿詳細画面のテスト' do
      before do
        visit post_path(other_post)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/posts/' + other_post.id.to_s
        end
        it '投稿の画像が表示される' do
          expect(page).to have_selector("img[src$='image']")
        end
        it '投稿のタイトルが表示される' do
          expect(page).to have_content other_post.title
        end
        it '投稿の日付が表示される' do
          expect(page).to have_content other_post.date.long("%Y%m%d")
        end
        it 'ユーザー画像のリンク先が正しい' do
          expect(page).to have_link '', href: user_path(other_post.user)
        end
        it '投稿の内容が表示される' do
          expect(page).to have_content other_post.content
        end
        it '投稿のいいねボタンが表示される' do
          expect(page).to have_link '', href: post_favorites_path(other_post)
        end
        it '投稿のいいね数が表示される' do
          expect(page).to have_content other_post.favorites.count
        end
        it '投稿のコメント数が表示される' do
          expect(page).to have_content other_post.comments.count
        end
        it '削除リンクが存在しない' do
          expect(page).not_to have_link '', href: post_path(other_post)
        end
        it '編集リンクが存在しない' do
          expect(page).not_to have_link '', href: edit_post_path(other_post)
        end
      end

      context 'コメントエリアのテスト' do
        it '「コメント」と表示される' do
          expect(page).to have_content 'コメント'
        end
        it 'コメントの全件数が表示される' do
          expect(page).to have_content "#{other_post.comments.count}件"
        end
        it 'コメント入力エリアが表示される' do
          expect(page).to have_field 'comment[comment]'
          expect(page).to have_button 'コメントを送る'
        end
      end
    end

    describe '他人の投稿編集画面' do
      it '遷移できず、トップ画面にリダイレクトされる' do
        visit edit_post_path(other_post)
        expect(current_path).to eq '/'
      end
    end

    describe '他人のユーザ詳細画面のテスト' do
      before do
        visit user_path(other_user)
      end

      context '表示の確認' do
        it '他人のニックネーム名が表示される' do
          expect(page).to have_content "#{other_user.nickname}"
        end
        it '他人のプロフィール画像が表示される' do
           expect(page).to have_selector("img[src$='profile_image']")
        end
        it '他人のニックネームが表示される' do
          expect(page).to have_content other_user.nickname
        end
        it '他人の誕生日が表示される' do
          expect(page).to have_content other_user.birthday.strftime("%-m月%-d日")
        end
        it '他人の自己紹介が表示される' do
          expect(page).to have_content other_user.introduction
     　  end
        it '他人の投稿数が表示される' do
          expect(page).to have_content other_user.posts.count
          expect(page).to have_content other_user.introduction
        end
        it '他人のフォロー数が表示され、リンクが存在する' do
          expect(page).to have_content other_user.following.count
          expect(page).to have_link '0', href: following_user_path(other_user)
        end
        it '他人のフォロワー数が表示され、リンクが存在する' do
          expect(page).to have_content other_user.followers.count
          expect(page).to have_link '0', href: followers_user_path(other_user)
        end
        it '「プロフィール編集」のリンクが存在しない' do
          expect(page).not_to have_link 'プロフィール編集', href: edit_user_path(user)
        end
        it 'フォローボタンが存在する' do
          expect(page).to have_button 'フォローする'
        end
      end

      context '投稿一覧の確認' do
        it '投稿一覧に他人の投稿画像が表示される' do
          expect(page).to have_selector("img[src$='image']")
        end
         it '投稿一覧に他人の投稿のタイトルが表示される' do
          expect(page).to have_content other_post.title
        end
        it '他人の投稿のいいねボタンが表示される' do
          expect(page).to have_link '', href: post_favorites_path(other_post)
        end
        it '他人の投稿のいいね数が表示される' do
          expect(page).to have_content other_post.favorites.count
        end
        it '他人の投稿のコメントボタンが表示される' do
          expect(page).to have_link '', href: post_path(other_post)
        end
        it '他人の投稿のコメント数が表示される' do
          expect(page).to have_content other_post.comments.count
        end
        it '自分の投稿は表示されない' do
          expect(page).not_to have_link post.title
        end
      end
    end

    describe '他人のユーザ情報編集画面' do
      it '遷移できず、トップ画面にリダイレクトされる' do
        visit edit_user_path(other_user)
        expect(current_path).to eq '/'
      end
    end
  end

end