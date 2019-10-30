# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ゲストユーザー機能', type: :system do
  let(:user){ FactoryBot.create(:user, name: 'ゲストユーザー', email: 'guest@sample.com', password: 'guestuser')}

  describe 'ログイン機能' do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_on 'ログインする'
    end

    it 'ゲストユーザーとしてログインし、ユーザー詳細画面に遷移する' do
      expect(page).to have_content 'ログインしました'
      expect(page).to have_content 'ゲストユーザーの投稿一覧'
    end

    it 'ゲストユーザーではプロフィールの編集ボタンが表示されない' do
      expect(page).not_to have_content '編集'
    end

    it 'ゲストユーザーが編集画面に遷移しようとすると警告が表示される' do
      visit edit_user_registration_path
      expect(page).to have_content 'ゲストユーザーはプロフィールの編集はできません。'
    end
  end
end