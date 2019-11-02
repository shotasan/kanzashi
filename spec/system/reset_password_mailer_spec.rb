# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パスワード再設定機能', type: :system do
  let!(:user){ FactoryBot.create(:user, email: 'correct@address.com')}

  describe 'パスワード再設定リクエスト画面' do
    before do
      visit new_user_session_path
      click_on 'パスワードを忘れましたか？'
    end

    it 'パスワード再設定リクエスト画面に遷移する' do
      expect(page).to have_content 'パスワード再設定リクエスト'
    end

    it 'メールアドレスを空のまま送信ボタンをクリックすると警告が表示される' do
      click_on '送信'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_selector '.alert'
    end

    it '登録されていないメールアドレスを入力し、送信ボタンを押すと警告が表示される' do
      fill_in 'メールアドレス', with: 'wrong@address.com'
      click_on '送信'
      expect(page).to have_content 'メールアドレスは見つかりませんでした。'
      expect(page).to have_selector '.alert'
    end

    it '送信が成功するとメッセージが表示される' do
      fill_in 'メールアドレス', with: 'correct@address.com'
      expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
    end
  end
end

# describe 'パスワード再設定画面' do
#   before do
#     visit new_user_password_path
#     puts user.reset_password_token
#     fill_in 'メールアドレス', with: user.email
#     click_on '送信'
#   end
#
#   it '送信されたメールのリンクからパスワード再設定画面に遷移する' do
#     # トークンの取得
#     user = User.last
#     token = user.reset_password_token
#     # トークンを使用してリンク先に遷移
#     visit edit_user_password_path(reset_password_token: token)
#     expect(page).to have_content 'パスワードを変更'
#
#     # 【Fix】画面遷移後にformのvalueに設定されるトークンの値が変更されるため、トークンの値が不正となりテストが通らない
#     fill_in '新しいパスワード', with: 'newpassword'
#     fill_in '確認用新しいパスワード', with: 'newpassword'
#     click_on 'パスワードを変更する'
#     expect(page).to have_content 'パスワードが正しく変更されました'
#   end
# end