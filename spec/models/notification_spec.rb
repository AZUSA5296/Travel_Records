require 'rails_helper'

RSpec.describe 'Notificationモデルのテスト', type: :model do
  
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'visiterとN:1となっている' do
        expect(Notification.reflect_on_association(:visiter).macro).to eq :belongs_to
      end
      it 'visitedとN:1となっている' do
        expect(Notification.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
    
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    
    context 'Commentモデルとの関係' do
      it '1:1となっている' do
        expect(Notification.reflect_on_association(:comment).macro).to eq :belongs_to
      end
    end
    
  end
end
