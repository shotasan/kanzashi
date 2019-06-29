# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'レビュー機能' do
  include Devise::Test::IntegrationHelpers

  let(:current_user) { FactoryBot.create(:user) }
  let!(:current_user_bean){ FactoryBot.create(:bean, user: current_user) }
  let(:review){ FactoryBot.build(:review, user: current_user) }

  describe '新規登録機能' do
    before do
      sign_in current_user
      visit new_review_url
      fill_in 'タイトル', with: review.title
      fill_in 'レビュー内容', with: review.content
    end

    context '登録に成功する場合' do
      it '登録に成功し、レビュー詳細画面に遷移する' do
        click_on '投稿する'
        expect(page).to have_content '登録に成功しました。'
        expect(page).to have_content 'レビュー詳細'
      end
    end

    context '登録に失敗する場合' do
      it 'タイトルを空欄で入力すると警告が表示される' do
        fill_in 'タイトル', with: ''
        click_on '投稿する'
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_selector '.alert'
      end

      it 'タイトルを30文字より多く入力すると警告が表示される' do
        fill_in 'タイトル', with: 'a' * 31
        click_on '投稿する'
        expect(page).to have_content 'タイトルは30文字以内で入力してください'
        expect(page).to have_selector '.alert'
      end

      it 'レビュー内容を空欄で入力すると警告が表示される' do
        fill_in 'レビュー内容', with: ''
        click_on '投稿する'
        expect(page).to have_content 'レビュー内容を入力してください'
        expect(page).to have_selector '.alert'
      end

      it 'レビュー内容を1000文字より多く入力すると警告が表示される' do
        fill_in 'レビュー内容', with: 'a' * 1001
        click_on '投稿する'
        expect(page).to have_content 'レビュー内容は1000文字以内で入力してください'
        expect(page).to have_selector '.alert'
      end
    end

    context '表示に関するテスト' do
      it '焙煎方法のセレクトボックスに項目が存在すること' do
        expect(page).to have_select('roasted', options: ['', 'ライトロースト', 'シナモンロースト', 'ミディアムロースト', 'ハイロースト', 'シティロースト', 'フルシティロースト', 'フレンチロースト', 'イタリアンロースト'])
      end

      it '挽き方のセレクトボックスに項目が存在すること ' do
        expect(page).to have_select('grind', options: ['', '極細挽き', '細挽き', '中細挽き', '中挽き', '粗挽き'])
      end

      it '評価の星を表示するためのIDが表示されている' do
        expect(page).to have_selector '#rating-form'
        expect(page).to have_selector '#bitter-form'
        expect(page).to have_selector '#acidity-form'
        expect(page).to have_selector '#rich-form'
        expect(page).to have_selector '#sweet-form'
        expect(page).to have_selector '#aroma-form'
      end
    end
  end
end