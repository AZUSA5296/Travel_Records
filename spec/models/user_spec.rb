require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.fullname = ''
        is_expected.to eq false
      end
      it '20文字以下であること: 20文字は〇' do
        user.fullname = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字は×' do
        user.fullname = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
    end

    context 'nicknameカラム' do
      it '空欄でないこと' do
        user.nickname = ''
        is_expected.to eq false
      end
      it '20文字以下であること: 20文字は〇' do
        user.nickname = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字は×' do
        user.nickname = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it '一意性があること' do
        user.nickname = other_user.nickname
        is_expected.to eq false
      end
    end

    context 'birthdayカラム' do
      it '未選択でないこと' do
        user.birthday = nil
        is_expected.to eq false
      end
      it '未来の日付でないこと' do
        user.birthday = Date.today + 1
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '150文字以下であること: 150文字は〇' do
        user.introduction = Faker::Lorem.characters(number: 150)
        is_expected.to eq true
      end
      it '150文字以下であること: 151文字は×' do
        user.introduction = Faker::Lorem.characters(number: 151)
        is_expected.to eq false
      end
    end

  end
end