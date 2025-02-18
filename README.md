## :relieved: はじめに

## 💡アプリ制作背景

## 💪アプリで出来ること

## アプリ機能一覧
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
##### ログイン機能

##### マイページ 

##### 管理者権限

##### 講座情報のタグチェック

##### カレンダー機能(CRUD)

##### ライブメッセージ + いいね機能

##### お問い合わせ機能

##### ポリシーページ

## インフラ構成図

## 使用言語
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
![ER図_ibetan_OriginalApp_](https://github.com/user-attachments/assets/ecfa2197-4750-4846-8a53-a007c3564d65)

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

## 何ができるのか
### 1.トップページ

### 2.ユーザログイン認証

### 3.ユーザ登録

### 4.スクレイピング機能

### 5.マイページ

### 6.


## URL

Qiitaに詳細を執筆しております。


