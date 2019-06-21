require 'rails_helper'

RSpec.describe Bean, type: :model do
  describe '新規登録のテスト' do
    let(:bean){ FactoryBot.build(:bean) }

    context 'バリデーションのテスト' do
      it '正常に登録できる場合' do
        expect(bean).to be_valid
      end

      it 'nameが無ければ無効な状態であること' do
        bean.name = ''
        bean.valid?
        expect(bean.errors[:name]).to include('を入力してください')
      end

      it 'nameが30文字以下なら有効な状態であること' do
        bean.name = 'a' * 30
        expect(bean).to be_valid
      end

      it 'nameが30文字より多いなら無効な状態であること' do
        bean.name = 'a' * 31
        bean.valid?
        expect(bean.errors[:name]).to include('は30文字以内で入力してください')
      end

      it 'countryが30文字以下なら有効な状態であること' do
        bean.country = 'a' * 30
        expect(bean).to be_valid
      end

      it 'countryが30文字より多いなら無効な状態であること' do
        bean.country = 'a' * 31
        bean.valid?
        expect(bean.errors[:country]).to include('は30文字以内で入力してください')
      end

      it 'plantationが30文字以下なら有効な状態であること' do
        bean.plantation = 'a' * 30
        expect(bean).to be_valid
      end

      it 'plantationが30文字より多いなら無効な状態であること' do
        bean.plantation = 'a' * 31
        bean.valid?
        expect(bean.errors[:plantation]).to include('は30文字以内で入力してください')
      end
    end
  end
end
