# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

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
  # def update
  #   super
  # end

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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  # カスタムの新規登録アクションを追加
  def new
    super
  end

  # カスタムの新規登録アクションを追加
  def create
    super do |resource|
      # フォームで選択されたaccount_typeを保存する
    resource.account_type = params[:user][:account_type].to_i
    
    end
  end

  # カスタムの編集アクションを追加
  def edit
    super
  end

  # カスタムの更新アクションを追加
  def update
    super do |resource|
      # フォームで選択されたaccount_typeを更新する
      resource.account_type = params[:user][:account_type].to_i
    end
  end

  # その他の必要なカスタムアクションを追加

  private

  # サインアップや編集時に許可するパラメーターを設定
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :account_type)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :account_type)
  end
end
