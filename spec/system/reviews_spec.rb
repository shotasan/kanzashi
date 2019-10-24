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
      visit new_review_path
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
      context '動的フォームの挙動に関するテスト' do
        before do
          click_on '豆を増やす'
        end

        it '豆を増やすボタンをクリックすると選択する豆の入力フォームが増えること' do
          expect(page).to have_content('選択する豆', count: 2)
          expect(page).to have_selector('.nested-fields', count: 2)
        end

        it '豆を増やすボタンをクリックすると豆を減らすボタンが表示されること' do
          expect(page).to have_link '豆を減らす'
        end

        it '豆を減らすボタンをクリックすると選択する豆の入力フォームが減ること' do
          click_on '豆を減らす'
          expect(page).to have_content('選択する豆', count: 1)
          expect(page).to have_selector('.nested-fields', count: 1)
        end

        it '選択する豆の入力フォームが3つになると豆を増やすボタンが表示されないこと' do
          click_on '豆を増やす'
          expect(page).not_to have_content '豆を増やす'
        end

        it '選択する豆の入力フォームが1つになると豆を減らすボタンが表示されないこと' do
          click_on '豆を減らす'
          expect(page).not_to have_content '豆を減らす'
        end
      end

      context 'レビュー一覧画面のタグに関するテスト' do
        it '選択する豆が１種類の場合ストレートのタグが表示されること' do
          click_on '投稿する'
          visit reviews_path
          within '.card-header' do
            expect(page).to have_content 'ストレート'
          end
        end

        it '選択する豆が２種類以上の場合ブレンドのタグが表示されること' do
          click_on '豆を増やす'
          click_on '投稿する'
          visit reviews_path
          within '.card-header' do
            expect(page).to have_content 'ブレンド'
          end
        end
      end

      it '焙煎方法のセレクトボックスに項目が存在すること' do
        expect(page).to have_select('review[targets_attributes][0][roasted]', options: ['', 'ライトロースト', 'シナモンロースト', 'ミディアムロースト', 'ハイロースト', 'シティロースト', 'フルシティロースト', 'フレンチロースト', 'イタリアンロースト'])
      end

      it '挽き方のセレクトボックスに項目が存在すること ' do
        expect(page).to have_select('review[targets_attributes][0][grind]', options: ['', '極細挽き', '細挽き', '中細挽き', '中挽き', '粗挽き'])
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
        expect(page).to have_css("img[src*='star-on']")
      end

      it '投稿する画像ファイルを選択するとプレビューが表示されること' do
        attach_file 'review[image]', "#{ Rails.root }/spec/factories/no_image.jpg"
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
          expect(page).to have_css("img[src*='star-on']", count: 5)
        end
      end

      context '画像の投稿に関するテスト' do
        before do
          attach_file '画像', "#{Rails.root}/spec/factories/jon.png"
          click_on '投稿する'
        end

        it '画像を添付して投稿するをクリックすると詳細画面に遷移し、添付した画像が表示されること' do
          expect(page.find('#review_image')['src']).to have_content'jon.png'
        end

        it 'デフォルト画像に戻すにチェックを入れて投稿するをクリックすると詳細画面に遷移し、デフォルト画像が表示されること' do
          click_on '編集'
          check 'デフォルト画像に戻す'
          click_on '投稿する'
          expect(page).to have_css("img[src*='no_image']")
          expect(page).not_to have_css("img[src*='jon']")
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

  describe '詳細機能' do
    before do
      sign_in current_user
      review.targets.first.bean_id = current_user_bean.id
      review.save
      visit reviews_path
    end

    context '自身のレビューの場合' do
      before do
        click_on 'MyString'
      end

      it 'レビュー一覧でタイトルをクリックすると詳細画面に遷移する' do
        expect(page).to have_content 'レビュー詳細'
      end

      it '自身のレビューの詳細画面では編集リンクが表示される' do
        expect(page).to have_link '編集'
      end

      it '自身のレビューの詳細画面では削除リンクが表示される' do
        expect(page).to have_link '削除'
      end

      it '他ユーザーのレビューの詳細画面ではお気に入りリンクが表示される' do
        expect(page).not_to have_link 'お気に入り'
      end
    end

    context '他ユーザーのレビューの場合' do
      before do
        another_user = create(:user, name: 'another_user')
        another_user_bean = FactoryBot.create(:bean, user: another_user)
        another_user_review = FactoryBot.build(:review, user: another_user, title: 'Other')
        another_user_review.targets.first.bean_id = another_user_bean.id
        another_user_review.save
        visit reviews_path
        click_on 'Other'
      end

      it 'レビュー一覧でタイトルをクリックすると詳細画面に遷移する' do
        expect(page).to have_content 'Other'
      end

      it '他ユーザーのレビューの詳細画面では編集リンクが表示されない' do
        expect(page).not_to have_link '編集'
      end

      it '他ユーザーのレビューの詳細画面では編集リンクが表示されない' do
        expect(page).not_to have_link '削除'
      end

      it '他ユーザーのレビューの詳細画面ではお気に入りリンクが表示される' do
        expect(page).to have_link 'お気に入り'
      end

      # Ajaxの関係で通らない場合がある
      it 'お気に入りリンクをクリックすると、表示がお気に入り解除リンクに変わる', js: true do
        click_on 'お気に入り'
        wait_for_ajax
        expect(page).to have_content 'お気に入り解除'
        expect(current_user.favorites.count).to eq 1
      end
    end
  end
end