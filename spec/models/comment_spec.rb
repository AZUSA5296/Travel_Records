equire 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { comment.valid? }

    let(:user) { create(:user) }
    let(:post) { create(:post, user_id: user.id) }
    let!(:comment) { build(:comment, user_id: user.id, post_id: post.id) }

    context 'commentカラム' do
      it '空欄でないこと' do
        comment.comment = ''
        is_expected.to eq false
      end
      it '500文字以下であること: 500文字は〇' do
        comment.comment = Faker::Lorem.characters(number: 500)
        is_expected.to eq true
      end
      it '500文字以下であること: 501文字は×' do
        comment.comment = Faker::Lorem.characters(number: 501)
        is_expected.to eq false
      end
    end

  end
end