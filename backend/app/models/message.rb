class Message < ApplicationRecord
    belongs_to :user
    has_many :bookmarks
    has_many :favorites

    validates :content, presence: true
end
