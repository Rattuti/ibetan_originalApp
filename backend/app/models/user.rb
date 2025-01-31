# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :articles
  has_many :bookmarks
  has_many :favorites
  has_many :messages

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
end
