require 'rails_helper'

RSpec.describe Target, type: :model do
  describe '新規登録のテスト' do
    let(:first_user){ FactoryBot.create(:user) }
    let!(:review){ FactoryBot.build(:review, user: first_user) }
    let(:target){ review.targets.first }

    context 'バリデーションのテスト' do
      before do
        # @first_user = create(:user)
        # @first_bean = @first_user.bean.create(name: 'FirstUser Bean')
        # @second_user = create(:user)
        # @second_bean = @second_user.bean.create(name: 'SecondUser Bean')
      end

      it 'amountが0未満なら無効な状態であること' do
        target.amount = -1
        target.valid?
        expect(target.errors[:amount]).to include('は0以上の値にしてください')
      end

      it 'amountが100より多いなら無効な状態であること' do
        target.amount = 101
        target.valid?
        expect(target.errors[:amount]).to include('は100以下の値にしてください')
      end

      it 'bean_idがnilなら無効な状態であること' do
        target.bean_id = nil
        target.valid?
        expect(target.errors[:bean]).to include('を入力してください')
      end

      it 'bean_idに自身が登録したBean以外を入力すると無効な状態であること' do
        @first_user_bean = first_user.beans.create(name: 'Test')
        target.bean_id = @first_user_bean.id
        expect(target).to be_valid
      end

      it 'bean_idに自身が登録したBean以外を入力すると無効な状態であること' do
        @another_user_bean = FactoryBot.create(:bean, user: FactoryBot.create(:user))
        target.bean_id = @another_user_bean.id
        target.valid?
        expect(target.errors[:bean_id]).to include('は登録されていません')
      end
    end
  end
end
