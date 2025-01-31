class Feed < ApplicationRecord
    has_many :articles, dependent: :destroy
end
