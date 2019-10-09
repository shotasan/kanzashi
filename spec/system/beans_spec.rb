# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '豆の管理機能', type: :system do
  include Devise::Test::IntegrationHelpers

  let(:current_user) { FactoryBot.create(:user) }
  let!(:bean){ FactoryBot.build(:bean, user: current_user) }

  describe '新規登録機能' do
    before do
      sign_in current_user
      visit beans_path
      fill_in '名称', with: bean.name
      fill_in '原産国', with: bean.country
      fill_in '農園', with: bean.plantation
    end

    context '登録に成功する場合' do
      it '登録に成功し、レビュー新規作成画面に遷移する' do
        click_on '登録する'
        expect(page).to have_content '新しい豆を登録しました。'
        expect(page).to have_content 'レビュー投稿'
      end
    end

    context '登録に失敗する場合' do
      it '名称を空欄で入力すると警告が表示される' do
        fill_in '名称', with: ''
        click_on '登録する'
        expect(page).to have_content '名称を入力してください'
        expect(page).to have_selector '.alert'
      end

      it '名称を30文字より多く入力すると警告が表示される' do
        fill_in '名称', with: 'a' * 31
        click_on '登録する'
        expect(page).to have_content '名称は30文字以内で入力してください'
        expect(page).to have_selector '.alert'
      end

      it '原産国を30文字より多く入力すると警告が表示される' do
        fill_in '原産国', with: 'a' * 31
        click_on '登録する'
        expect(page).to have_content '原産国は30文字以内で入力してください'
        expect(page).to have_selector '.alert'
      end

      it '農園を30文字より多く入力すると警告が表示される' do
        fill_in '農園', with: 'a' * 31
        click_on '登録する'
        expect(page).to have_content '農園は30文字以内で入力してください'
        expect(page).to have_selector '.alert'
      end
    end
  end

  describe '一覧機能' do
    before do
      FactoryBot.create(:bean, name: 'first_bean', user: current_user)
      FactoryBot.create(:bean, name: 'second_bean', user: current_user)
      FactoryBot.create(:bean, name: 'third_bean', user: current_user)
      sign_in current_user
      visit beans_path
    end

    it '登録されている豆の一覧が表示される' do
      beans_name = all('.bean_name').map(&:text)
      expect(beans_name).to eq %w[third_bean second_bean first_bean]
    end
  end

  describe '編集機能' do
    before do
      bean.save
      sign_in current_user
      visit edit_bean_path(bean)
    end

    context '編集に成功する場合' do
      it '登録に成功し、豆の一覧画面に遷移する' do
        fill_in '名称', with: 'edit_bean_name'
        click_on '登録する'
        expect(page).to have_content '編集に成功しました。'
        expect(page).to have_content 'edit_bean_name'
      end
    end

    context '編集に失敗する場合' do
      it '名称を空欄で入力すると警告が表示される' do
        fill_in '名称', with: ''
        click_on '登録する'
        expect(page).to have_content '名称を入力してください'
        expect(page).to have_selector '.alert'
      end
    end
  end

  describe '削除機能' do
    let(:review) { FactoryBot.build(:review, title: 'Destroy', user: current_user) }

    before do
      bean.save
      review.targets.first.bean_id = bean.id
      review.save
      sign_in current_user
    end


    it '削除に成功し、メッセージが表示される' do
      visit beans_path
      click_on '削除'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content "#{bean.name}を削除しました。"
      within '.table' do
        expect(page).not_to have_content "#{bean.name}"
      end
    end

    it '登録したレビューがレビュー一覧に表示される' do
      visit reviews_path
      expect(page).to have_content 'Destroy'
    end

    it '豆の情報を削除すると、関連するレビューも削除される' do
      visit beans_path
      click_on '削除'
      page.driver.browser.switch_to.alert.accept
      visit reviews_path
      expect(page).not_to have_content 'Destroy'
    end
  end
end