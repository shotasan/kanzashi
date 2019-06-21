require 'rails_helper'

RSpec.describe Target, type: :model do
  describe '新規登録のテスト' do
    let(:target){ FactoryBot.build(:target) }
    context 'バリデーションのテスト' do
      it 'amountが0未満なら無効な状態であること' do
        target.amount = -1
        target.valid?
        # binding.pry
        expect(target.errors[:amount]).to include('は0以上の値にしてください')
      end

      it 'amountが100より多いなら無効な状態であること' do
        target.amount = 101
        target.valid?
        expect(target.errors[:amount]).to include('は100以下の値にしてください')
      end
    end
  end
end
