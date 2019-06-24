# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '豆の管理機能', type: :system do
  include Devise::Test::IntegrationHelpers

  let(:current_user) { FactoryBot.create(:user) }
  let(:bean){ FactoryBot.build(:bean) }

  describe '新規登録機能' do
    before do
      sign_in current_user
      visit new_bean_path
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
end