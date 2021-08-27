require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのチェック' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        post.title = ''
        is_expected.to eq false
      end
      it '20文字以下であること: 20文字は〇' do
        post.title = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字は×' do
        post.title = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
    end

    context 'dateカラム' do
      it '未来の日付でないこと' do
        post.date = Date.today + 1
        is_expected.to eq false
      end
    end

    context 'contentカラム' do
      it '1000文字以下であること: 1000文字は〇' do
        post.content = Faker::Lorem.characters(number: 1000)
        is_expected.to eq true
      end
      it '1000文字以下であること: 1001文字は×' do
        post.content = Faker::Lorem.characters(number: 1001)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end

  end
end