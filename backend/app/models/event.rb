class Event < ApplicationRecord
  belongs_to :user, optional: true  # ユーザーに紐づく
  belongs_to :article, optional: true
  #validates :title, :start_date, :end_date, presence: true
end
