require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '新規登録のテスト' do
    let(:user){ create(:user) }
    let(:bean){ create(:bean, user: user) }
    let(:review){ build(:review, user: user) }
    let(:comment){ build(:comment, user_id: user.id, review_id: review.id) }

    context 'バリデーションのテスト' do
      before do
        review.targets.first.bean_id = bean.id
        review.save
      end

      it '正常に登録できる場合' do
        expect(comment).to be_valid
      end

      it 'contentが空欄だと無効な状態であること' do
        comment.content = ''
        comment.valid?
        expect(comment.errors[:content]).to include 'を入力してください'
      end

      it 'contentが140字以内なら有効な状態であること' do
        comment.content = 'a' * 140
        expect(comment).to be_valid
      end

      it 'contentが140文字より多いと無効な状態であること' do
        comment.content = 'a' * 141
        comment.valid?
        expect(comment.errors[:content]).to include 'は140文字以内で入力してください'
      end
    end
  end
end
