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

      it '飲んだ日に未来の日付を入力すると警告が表示される' do
        fill_in '飲んだ日', with: Date.tomorrow
        click_on '投稿する'
        expect(page).to have_content '飲んだ日に未来の日付は入力できません'
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

      it '評価の星を表示するためのIDが表示されていること' do
        expect(page).to have_selector '#rating-form'
        expect(page).to have_selector '#bitter-form'
        expect(page).to have_selector '#acidity-form'
        expect(page).to have_selector '#rich-form'
        expect(page).to have_selector '#sweet-form'
        expect(page).to have_selector '#aroma-form'
      end

      it '評価の星の画像が表示されていること' do
        expect(page).to have_css("img[src*='/assets/star-on.png'")
      end

      it '投稿する画像ファイルを選択するとプレビューが表示されること' do
        attach_file 'review[image]', "#{ Rails.root }/spec/factories/no_image.jpg"
        # save_and_open_page
        expect(page.find('#preview-image')['class']).to have_content 'no_image.jpg'
      end
    end
  end

  describe '編集機能' do
    before do
      sign_in current_user
      review.targets.first.bean_id = current_user_bean.id
      review.save
      visit review_url(review)
      click_on '編集'
    end

    it '編集画面に遷移すること' do
      expect(page).to have_content '編集'
    end

    context '編集に成功する場合' do
      it 'タイトルを編集して投稿するをクリックすると詳細画面に遷移し、編集が成功すること' do
        fill_in 'タイトル', with: 'after_edit_title'
        click_on '投稿する'
        expect(page).to have_content 'ビュー詳細'
        expect(page).to have_content '編集に成功しました。'
        expect(page).to have_content 'after_edit_title'
      end

      it 'レビューを編集して投稿するをクリックすると詳細画面に遷移し、編集が成功すること' do
        fill_in 'レビュー', with: 'This is review after editing'
        click_on '投稿する'
        expect(page).to have_content 'ビュー詳細'
        expect(page).to have_content '編集に成功しました。'
        expect(page).to have_content 'This is review after editing'
      end

      it '星の評価を5に変更して投稿するをクリックすると詳細画面に遷移し、編集が成功すること' do
        within '#rating-form' do
          find("img[alt='5']").click
        end
        click_on '投稿する'
        within '.rating-rating' do
          expect(page).to have_css("img[src*='/assets/star-on.png'", count: 5)
        end
      end
    end

    context '編集に失敗する場合' do
      it 'タイトルを空欄にして投稿するをクリックすると警告が表示されること' do
        fill_in 'タイトル', with: ''
        click_on '投稿する'
        expect(page).to have_content 'タイトルを入力してください'
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

  end
end