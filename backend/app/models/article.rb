class Article < ApplicationRecord
    belongs_to :feed, optional: true
    # optional :true　テーブルの外部キーの〇〇_idというカラムがnillの場合バリデーションで弾かれるのを許可する
    has_many :favorites, dependent: :destroy
    has_many :bookmarks, dependent: :destroy
end
