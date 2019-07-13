class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :reviews, dependent: :destroy
  has_many :beans, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fav_reviews, through: :favorites, source: :review

  validates :name, presence: true, length: { maximum: 30 }
  validates :profile, length: { maximum: 300 }

  # ユーザー編集でパスワードの入力を不要にし、パスワードの変更も可能にするためのメソッド
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    # パスワードの入力が無ければparamsからpasswordとpassword_confirmationを削除し既存パスワードを変更しないようにする
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    # バリデーションでparamsが正当か確認し、trueかfalseをresultに代入する。
    # clean_up_passwordsで既存のパスワードをリセットする。
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
end