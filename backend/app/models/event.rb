class Event < ApplicationRecord
  belongs_to :article
  #validates :title, :start_date, :end_date, presence: true
end
