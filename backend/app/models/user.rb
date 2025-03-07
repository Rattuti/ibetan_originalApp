class User < ActiveRecord::Base
  before_create :set_confirmed_at

  extend Devise::Models
  include DeviseTokenAuth::Concerns::User

  # Devise のモジュール（`extend Devise::Models` の後に書く）
  devise  :database_authenticatable, :registerable,
          :recoverable, :validatable

  # バリデーション（Devise の設定後に記述）
  validates_uniqueness_of :email, case_sensitive: false

  # Enum（定数的な役割なのでバリデーションの後）
  enum role: { user: "user", admin: "admin" }

  def confirmation_token
    nil
  end

  # `confirmation_token` も nil にする
  def confirmation_token=(_value)
    nil
  end

# `confirmation_sent_at` を Devise に誤認識されないようにする
def confirmation_sent_at
  nil
end

def confirmation_sent_at=(_value)
  nil
end


  has_many :articles
  has_many :events, dependent: :destroy
  has_many :favorites
  has_many :messages, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :contacts, dependent: :destroy


  validates :name, presence: true
  validates :name, length: { maximum: 30 }

  # コールバック（最後に記述）
  after_initialize :set_default_role, if: :new_record?

  
  private

  def set_default_role
    self.role ||= "user"
  end

  def set_confirmed_at
    self.confirmed_at ||= Time.current
  end

end
