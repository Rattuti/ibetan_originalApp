class Article < ApplicationRecord
    # optional :true　テーブルの外部キーの〇〇_idというカラムがnillの場合バリデーションで弾かれるのを許可する
    has_many :favorites, dependent: :destroy
end
