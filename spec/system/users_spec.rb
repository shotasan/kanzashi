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
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(page).to have_selector '.alert'
      end

      it 'メールアドレスを空欄で入力すると警告が表示される' do
        fill_in 'メールアドレス', with: ''
        click_on 'Sign up'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_selector '.alert'
      end

      it 'パスワードを空欄で入力すると警告が表示される' do
        fill_in 'パスワード', with: ''
        click_on 'Sign up'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_selector '.alert'
      end

      it 'パスワードと確認用パスワードが不一致だと警告が表示される' do
        fill_in 'パスワード', with: 'wrong_password'
        click_on 'Sign up'
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
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
          expect(page).to have_content 'Edit Test'
        end

        it 'ユーザー画像を設定できる' do
          attach_file 'ユーザー画像', "#{Rails.root}/spec/factories/jon.png"
          click_on '更新する'
          expect(page).to have_css("img[src$='jon.png']")
        end

        it '画像を削除にチェックを入れて更新するとユーザー画像が削除される' do
          attach_file 'ユーザー画像', "#{Rails.root}/spec/factories/jon.png"
          click_on '更新する'
          click_on '編集'
          check 'remove_avatar'
          click_on '更新する'
          expect(page).not_to have_css("img[src$='jon.png']")
        end
      end

      context '編集に失敗する場合' do
        it 'ユーザー名が空欄だと警告が表示される' do
          fill_in 'ユーザー名', with: ''
          click_on '更新する'
          expect(page).to have_content 'ユーザー名を入力してください'
          expect(page).to have_selector '.alert'
        end

        it 'メールアドレスが空欄だと警告が表示される' do
          fill_in 'メールアドレス', with: ''
          click_on '更新する'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_selector '.alert'
        end

        it 'パスワードと確認用パスワードが不一致だと警告が表示される' do
          fill_in 'パスワード', with: 'edit_password'
          fill_in '確認用パスワード', with: 'wrong_password'
          click_on '更新する'
          expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
          expect(page).to have_selector '.alert'
        end
      end
    end

    describe 'ユーザー詳細画面' do
      let(:bean){ FactoryBot.create(:bean, user: user) }

      before do
        @review_a = build(:review, title: 'レビューA', user: user)
        @review_a.targets.first.bean_id = bean.id
        @review_a.save

        @review_b = build(:review, title: 'レビューB', user: user)
        @review_b.targets.first.bean_id = bean.id
        @review_b.save

        @review_c = build(:review, title: 'レビューC', user: user)
        @review_c.targets.first.bean_id = bean.id
        @review_c.save

        visit user_path(user)
      end

      it 'ユーザーの情報が表示される' do
        expect(page).to have_content 'ユーザー詳細'
        expect(page).to have_content 'テストユーザー'
      end

      it 'ユーザーが投稿したレビューが投稿が新しい順に表示される' do
        within '.user-reviews' do
          reviews_title = all('.card-header a').map(&:text)
          expect(reviews_title).to eq %w[レビューC レビューB レビューA]
        end
      end
    end
  end
end