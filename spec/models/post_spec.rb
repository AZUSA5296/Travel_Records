require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { spot.valid? }

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
      it '空欄でないこと' do
        spot.content = ''
        is_expected.to eq false
      end
      it '1000文字以下であること: 1000文字は〇' do
        spot.content = Faker::Lorem.characters(number: 1000)
        is_expected.to eq true
      end
      it '1000文字以下であること: 1001文字は×' do
        spot.content = Faker::Lorem.characters(number: 1001)
        is_expected.to eq false
      end
    end

  end
end