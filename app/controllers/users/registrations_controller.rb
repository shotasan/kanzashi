# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :guest?, only: %i[edit update destroy]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    current_user.avatar.purge if params[:remove_avatar]
    super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name email avatar profile])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  # アカウント編集後、プロフィール画面に移動する
  def after_update_path_for(resource)
    user_path(resource)
  end

  # アカウント編集時にパスワード入力を不要にする
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  def guest?
    redirect_to reviews_url, notice: 'ゲストユーザーはプロフィールの編集はできません。' if view_context.guest?
  end
end
