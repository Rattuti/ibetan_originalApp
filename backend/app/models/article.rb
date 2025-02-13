class Article < ApplicationRecord
    # optional :true　テーブルの外部キーの〇〇_idというカラムがnillの場合バリデーションで弾かれるのを許可する
    has_many :events, dependent: :destroy  # 記事が削除されたら関連イベントも削除
    has_many :favorites, dependent: :destroy
end
