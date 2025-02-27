class Like < ApplicationRecord
    belongs_to :user
    belongs_to :message

    validates :click, inclusion: { in: [0, 1] }
    validates :mark_type, presence: true
end
