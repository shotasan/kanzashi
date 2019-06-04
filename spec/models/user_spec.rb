require 'rails_helper'

RSpec.describe User, type: :model do

  describe '新規登録のテスト' do
    let(:user){ FactoryBot.build(:user) }

    context 'バリデーションのテスト' do
      it '名前、メールアドレス、パスワードが入力されていれば有効な状態であること' do
        expect(user).to be_valid
      end

      it '名前が無ければ無効な状態であること' do
        user.name = ''
        user.valid?
        expect(user.errors[:name]).to include('が入力されていません。')
      end

      it '名前が30文字以下なら有効な状態であること' do
        user.name = 'a' * 30
        expect(user).to be_valid
      end

      it '名前が30文字より多いなら無効な状態であること' do
        user.name = 'a' * 31
        user.valid?
        expect(user.errors[:name]).to include('は30文字以下に設定して下さい。')
      end

      it 'メールアドレスが無ければ無効な状態であること' do
        user.email = ''
        user.valid?
        expect(user.errors[:email]).to include('が入力されていません。')
      end

      it 'メールアドレスが登録済みであれば無効な状態であること' do
        user.save
        @second_user = FactoryBot.build(:user, email: user.email)
        @second_user.valid?
        expect(@second_user.errors[:email]).to include('は既に使用されています。')
      end

      it 'パスワードが無ければ無効な状態であること' do
        user.password = ''
        user.valid?
        expect(user.errors[:password]).to include('が入力されていません。')
      end

      it 'プロフィールが300文字以内なら有効な状態であること' do
        user.profile = 'a' * 300
        expect(user).to be_valid
      end

      it 'プロフィールが300文字より多いなら無効な状態であること' do
        user.profile = 'a' * 301
        user.valid?
        expect(user.errors[:profile]).to include('は300文字以下に設定して下さい。')
      end
    end
  end
end