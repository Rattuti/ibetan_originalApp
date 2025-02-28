## :relieved: はじめに


## 💡アプリ制作背景
外出先で、たまたま託児付き講座に出会い有意義な時間が過ごせました。現地に足を運ばないと知る機会がなかったので、より手元で講座情報やコミュニティに参加できればと感じました。

## 💪アプリで出来ること
アプリ制作背景を元に感じたことが解消に近づくような機能を盛り込みました。下記がアプリ機能一覧になります。

## ⚙️アプリ機能一覧
| No | 機能 | 説明 |
|:-:|:-:|:-|
| 1 | ログイン認証機能  | 名前、メール、パスワード、管理者権限 |
| 2 | マイページ | ニックネーム登録、アイコン画像登録 |
| 2 | 管理者権限 | 登録ユーザ管理、お問い合わせ一覧 |
| 3 | 講座情報スクレイピング | タイトル、開催日、内容、託児有無、費用 |
| 4 | 3の記事のタグ付け | お気に入りの記事があればタグ付け可 |
| 5 | カレンダー機能(CRUD) | 講座名表示、個別イベント登録 |
| 6 | ライブメッセージ機能 | リアルタイムのメッセージ投稿可 |
| 7 | メッセージいいね機能 | メッセージにいいねマーク付け可 |
| 8 | お問い合わせ機能 | 管理者へ直談判可 |
| 9 | ポリシーページ | 利用者ポリシー |

## 使用イメージ
##### 新規登録機能
![image](https://github.com/user-attachments/assets/1c3325ea-61ca-4b9e-b394-0df8736aefb5)

##### ログイン機能
![image](https://github.com/user-attachments/assets/da07fb94-00a8-47fb-9afa-d73636a657f2)

##### マイページ 
![image](https://github.com/user-attachments/assets/f478e589-6bc5-4108-995f-50bb3cebdd37)

##### 管理者権限
　作成中

##### 講座情報のタグチェック
![image](https://github.com/user-attachments/assets/50ff6ccc-0be2-48eb-b198-86d2af3904ab)

##### カレンダー機能(CRUD)
![image](https://github.com/user-attachments/assets/890f9c31-1212-4101-8aab-2b0d0e1c4fa4)

![image](https://github.com/user-attachments/assets/624b67bd-5f2c-4889-8d3a-1263ee5601bc)


![image](https://github.com/user-attachments/assets/c1b5d98b-5f4c-47ae-82f7-d6f72ee52b91)

##### ライブメッセージ + いいね機能
![image](https://github.com/user-attachments/assets/3996dcb2-1417-4c09-9458-65560e9d57b5)

##### お問い合わせ機能
　作成中

##### ポリシーページ

![image](https://github.com/user-attachments/assets/ca7c61cf-a38d-4342-ac41-b6f39dc3e3d6)

## インフラ構成図
　作成中

## 🖥️使用言語
##### フロントエンド  
・Node　v14.19.1  
・npm　8.15.1  
・Vue3　3.5.13  
・Vue-CLI　5.0.8  
| No | 使用ツール | 機能 |
|:-:|:-:|:-:|
|1| vue-router | Vueページ操作 |
|2| pinia | 状態管理ライブラリ |
|3| vue-axios | Vueでaxiosを使うライブラリ |
|4|actioncable|RailsのWebSocket通信機能|
|5|moment|日付や時間を扱うライブラリ|
|6|fontawesome|アイコン|
|7|tailwindcss|CSSフレームワーク|


##### バックエンド
・Ruby　3.1.2  
・Ruby on Rails　7.2.2.1  
・PostgreSQL　17.2  
| No | 使用Gem | 機能 |
|:-:|:-:|:-:|
|1|rack-cors|CORS設定(データ送受信Vue.js⇔Rails)|
|2|devise|ログイン機能導入(Railsアプリ用)|
|3|devise_token_auth|tokenを用いたAPI向けログイン機能導入|
|4|mechanize|Webサイト自動操作用(スクレイピング)| 
  
## ER図
![ER図_ibetan_OriginalApp](https://github.com/user-attachments/assets/3f3d9363-fee7-44d6-bd1d-c979d1c16b4e)

## 各テーブルと説明
|No.| テーブル名 | 説明 |
|:-:|:-:|:-:|
|1|users| 登録ユーザ、役割(ユーザ、管理者) |
|2|articles| 講座情報をスクレイピングし保管 |
|3|favorites| スクレイピング記事のお気に入り登録 |
|4|events| カレンダーへのイベント登録 |
|5|messages| ライブメッセージ |
|6|likes| メッセージにいいね |
|7|comtems| お問い合わせ内容の保管 | 

## :blush:さいごに
## URL

Qiitaに詳細を執筆しております。


