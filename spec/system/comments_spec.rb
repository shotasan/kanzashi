# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'コメント機能' do
  include Devise::Test::IntegrationHelpers

  let(:current_user) { FactoryBot.create(:user) }
  let!(:current_user_bean){ FactoryBot.create(:bean, user: current_user) }
  let(:review){ FactoryBot.build(:review, user: current_user) }

  before do
    sign_in current_user
    review.targets.first.bean_id = current_user_bean.id
    review.save
    visit review_path(review)
  end

  describe '新規登録機能' do
    it 'コメントを入力して投稿するボタンをクリックすると登録される' do
      fill_in 'コメント内容', with: 'テストコメント'
      click_on '投稿する'
      expect(page).to have_content 'テストコメント'
    end

    it 'コメントを空欄で投稿するボタンをクリックすると警告が表示される' do
      fill_in 'コメント内容', with: ''
      click_on '投稿する'
      expect(page).to have_content 'コメント内容を入力してください'
      expect(page).to have_selector '.alert'
    end

    it 'コメントを140文字より多く入力して投稿するボタンをクリックすると警告が表示される' do
      fill_in 'コメント内容', with: 'a' * 141
      click_on '投稿する'
      expect(page).to have_content 'コメント内容は140文字以内で入力してください'
    end
  end

  describe '編集機能' do
    before do
      fill_in 'コメント内容', with: 'テストコメント'
      click_on '投稿する'
    end

    it '編集ボタンをクリックしてコメント内容を編集し、投稿するボタンをクリックすると編集に成功する' do
      within '#comments-area' do
        click_on '編集'
        fill_in 'コメント内容', with: '編集後テストコメント'
        click_on '投稿する'
      end
      expect(page).to have_content '編集後テストコメント'
      # save_and_open_page
    end
  end

  describe '削除機能' do
    before do
      fill_in 'コメント内容', with: 'テストコメント'
      click_on '投稿する'
    end

    it '削除ボタンをクリックすると投稿したコメントが削除される' do
      within '#comments-area' do
        click_on '削除'
      end
      expect(page).not_to have_content 'テストコメント'
    end
  end
end