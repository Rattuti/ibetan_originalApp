class User < ActiveRecord::Base
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User

  enum role: { user: "user", admin: "admin" }

  after_initialize :set_default_role, if: :new_record?

  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :confirmable

  has_many :articles
  has_many :events, dependent: :destroy
  has_many :favorites
  has_many :messages
  has_many :likes, dependent: :destroy
  has_many :contacts, dependent: :destroy

  validates :name, presence: true
  validates :name, length: { maximum: 30 }

  private

  def set_default_role
    self.role ||= "user"
  end
end
