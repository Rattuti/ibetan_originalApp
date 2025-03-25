# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#  movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# Character.create(name: 'Luke', movie: movies.first)
# 3.times do |number|
#     Message.create(content: "#{number}番目のメッセージです！", user_id: User.first.id)
#     puts "#{number}番目のメッセージを作成しました"
# end

require 'faker'

event_names = [
    "ミーティング", "イベント", "会議", "有給", "出張", "客先訪問", 
    "サークル", "誕生日", "旅行", "セミナー", "研修", "開発合宿"
]

event_colors = ["blue", "limegreen", "deepskyblue", "dimgray", "navy", "orange", "red", "teal", "royalblue"]

start_of_month = Date.today.beginning_of_month
end_of_month = Date.today.end_of_month

events = 20.times.map do |i|
    start_date = Faker::Date.between(from: start_of_month, to: end_of_month)
    end_date = start_date + rand(0..3) # 0〜3日間の範囲でイベントを設定
    {
        title: event_names.sample,
        start_date: start_date,
        end_date: end_date,
        color: event_colors.sample,
        judge: false,
    }
end

Event.create!(events)