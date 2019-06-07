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

      it 'パスワードが6文字未満だと無効な状態であること' do
        user.password = 'a' * 5
        user.valid?
        expect(user.errors[:password]).to include('は6文字以上に設定して下さい。')
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

  describe '編集機能のテスト' do
    let(:user) { FactoryBot.create(:user) }

    context 'update_without_current_passwordのテスト' do
      context '正常なparamsを受け取った場合' do
        before do
          params = { name: 'edit_user', email: 'test@test.com', profile: 'This is TestUser', password: 'change_pass', password_confirmation: 'change_pass' }
          @result = user.update_without_current_password(params)
        end

        it '正常なparamsを受け取るとtrueを返す' do
          expect(@result).to be true
        end

        it '受け取ったparamsの値で更新される' do
          expect(user.name).to eq 'edit_user'
          expect(user.email).to eq 'test@test.com'
          expect(user.profile).to eq 'This is TestUser'
          expect(user.valid_password?('change_pass')).to be true
        end
      end

      context '不正なparamsを受け取った場合' do
        it 'nameが空ならfalseを返す' do
          result = user.update_without_current_password({ name: '' })
          expect(result).to be false
        end

        it 'emailが空ならfalseを返す' do
          result = user.update_without_current_password({ email: '' })
          expect(result).to be false
        end
      end

      it 'passwordの入力が無ければ現在のパスワードが変更されない' do
        params = { name: 'edit_user', email: 'test@test.com', profile: 'This is TestUser', password: '', password_confirmation: '' }
        @result = user.update_without_current_password(params)
        expect(user.valid_password?('password')).to be true
      end
    end
  end
end