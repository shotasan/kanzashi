# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザー機能', type: :system do
  let(:user){ FactoryBot.build(:user) }

  describe '新規登録機能' do
    before do
      visit new_user_registration_path
      fill_in 'ユーザー名', with: user.name
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      fill_in '確認用パスワード', with: user.password
    end

    context '登録に成功する場合' do
      it '登録に成功し、ユーザー詳細画面に遷移する' do
        click_on 'Sign up'
        expect(page).to have_content 'ユーザー詳細'
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end

    context '登録に失敗する場合' do
      it '名前を空欄で入力すると警告が表示される' do
        fill_in 'ユーザー名', with: ''
        click_on 'Sign up'
        expect(page).to have_content 'ユーザー名 が入力されていません。'
        expect(page).to have_selector '.alert'
      end

      it 'メールアドレスを空欄で入力すると警告が表示される' do
        fill_in 'メールアドレス', with: ''
        click_on 'Sign up'
        expect(page).to have_content 'メールアドレス が入力されていません。'
        expect(page).to have_selector '.alert'
      end

      it 'パスワードを空欄で入力すると警告が表示される' do
        fill_in 'パスワード', with: ''
        click_on 'Sign up'
        expect(page).to have_content 'パスワード が入力されていません。'
        expect(page).to have_selector '.alert'
      end

      it 'パスワードと確認用パスワードが不一致だと警告が表示される' do
        fill_in 'パスワード', with: 'wrong_password'
        click_on 'Sign up'
        expect(page).to have_content '確認用パスワード が内容とあっていません。'
        expect(page).to have_selector '.alert'
      end
    end
  end

  describe 'ログイン機能' do
    before do
      user.save
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
    end

    context 'ログインに成功する場合' do
      it 'ログインに成功し、ユーザー詳細画面に遷移する' do
        click_on 'Log in'
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_content 'ユーザー詳細'
      end
    end

    context 'ログインに失敗する場合' do
      it 'メールアドレスが誤っていると警告が表示される' do
        fill_in 'メールアドレス', with: 'wrong_email@example.com'
        click_on 'Log in'
        expect(page).to have_content 'メールアドレス もしくはパスワードが不正です。'
        expect(page).to have_selector '.alert'
      end

      it 'パスワードが誤っていると警告が表示される' do
        fill_in 'パスワード', with: 'wrong_password'
        click_on 'Log in'
        expect(page).to have_content 'メールアドレス もしくはパスワードが不正です。'
        expect(page).to have_selector '.alert'
      end
    end
  end

  describe 'ログイン後の機能' do
    before do
      user.save
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_on 'Log in'
    end

    describe 'ログアウト機能' do
      it 'ログアウトをクリックするとログアウトに成功し、ログイン画面に遷移する' do
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました。'
        expect(page).to have_content 'Log in'
      end
    end

    describe 'アカウント編集機能' do
      before do
        visit edit_user_registration_path
        fill_in 'ユーザー名', with: 'edit_user'
        fill_in 'メールアドレス', with: 'edit@example.com'
        fill_in 'プロフィール', with: 'Edit Test'
      end

      context '編集に成功する場合' do
        it '編集に成功し、ユーザー詳細画面に遷移する' do
          click_on '更新する'
          expect(page).to have_content 'アカウント情報を変更しました。'
          expect(page).to have_content 'edit_user'
          expect(page).to have_content 'edit@example.com'
          expect(page).to have_content 'Edit Test'
        end
      end

      context '編集に失敗する場合' do
        it 'ユーザー名が空欄だと警告が表示される' do
          fill_in 'ユーザー名', with: ''
          click_on '更新する'
          expect(page).to have_content 'ユーザー名 が入力されていません。'
          expect(page).to have_selector '.alert'
        end

        it 'メールアドレスが空欄だと警告が表示される' do
          fill_in 'メールアドレス', with: ''
          click_on '更新する'
          expect(page).to have_content 'メールアドレス が入力されていません。'
          expect(page).to have_selector '.alert'
        end

        it 'パスワードと確認用パスワードが不一致だと警告が表示される' do
          fill_in 'パスワード', with: 'edit_password'
          fill_in '確認用パスワード', with: 'wrong_password'
          click_on '更新する'
          expect(page).to have_content '確認用パスワード が内容とあっていません。'
          expect(page).to have_selector '.alert'
        end
      end
    end
  end
end