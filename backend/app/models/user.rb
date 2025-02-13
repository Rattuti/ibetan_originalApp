class User < ActiveRecord::Base
  extend Devise::Models # DeviseTokenAuthを使用するために必要
  include DeviseTokenAuth::Concerns::User

  enum role: { user: "user", admin: "admin" }

  after_initialize :set_default_role, if: :new_record?



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :articles
  has_many :events, dependent: :destroy  # ユーザーが削除されたらイベントも削除
  has_many :favorites
  has_many :messages
  has_many :likes, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  
  private

  def set_default_role
    self.role ||= "user"
  end

end
