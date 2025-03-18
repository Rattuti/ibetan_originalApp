# :relieved: はじめに
このアプリは、地域の講座やコミュニテ情報を手軽に検索・参加できるサービスをコンセプトにしています。  
※　講座情報は作成者の利用の範囲内での許可をいただき活用しています。  

# 💡アプリ制作背景
外出先で偶然、託児付き講座を見つけ、参加した際に親と子どものともに有意義な時間が過ごせました。  
今まで、参加の機会を逃していたことに驚き、事前に知る機会があればよかったのにと感じました。      
そこで、「忙しい方や子育て中の方が、もっと手軽に地域の講座やコミュニティ情報にアクセスできるようにしたい」という思いから、このアプリを開発しました。

# 💪アプリで出来ること
このアプリでは、以下の機能を提供し、地域やコミュニティとのつながりをスムーズにします。  

- **講座・イベントの検索**：日程や条件に合ったイベントを簡単に見つけられます。
- **講座・イベントのチェック**：タグチェックした講座はマイページで確認できます。
- **コミュニティ機能**：参加者同士が情報を共有したり、交流を深めることができます。


# ⚙️アプリ機能一覧
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

# 使用イメージ
## Top画面
### 新規登録機能
新規ユーザ登録ができます。
![image](https://github.com/user-attachments/assets/d54be70e-1abd-4b02-aac8-12cf2a44e8fe)

### ログイン機能
登録済なら、「メールアドレス」「パスワード」を入力しログインできます。
![image](https://github.com/user-attachments/assets/558a45a4-337b-4b85-8d2d-c9e59fcacb0d)

## ホーム画面
### ヘッダー
登録済なら、ユーザのアバター画像とニックネームが表示されます。  
ボタンを押すと名前と同じページへ遷移します。  
（※　管理者でログインすると「管理者画面」ボタンが表示される）  
![image](https://github.com/user-attachments/assets/b7128345-ac2b-4464-a622-bf635f8f3e56)

### 講座情報とタグチェック
開催予定の講座情報のタイトルが表示される。  
タグをチェックすると色が付き、マイページでも表示される。  
![image](https://github.com/user-attachments/assets/50ff6ccc-0be2-48eb-b198-86d2af3904ab)

### ライブメッセージ + いいね機能
メッセージを入力し投稿すると、アバター画像とニックネームありのメッセージが表示される。  
メッセージをダブルクリックすると、マーク（❤、⭐️、👍️）を選択できる。  
![image](https://github.com/user-attachments/assets/096d06ad-2313-4f06-ad10-28b236cedc6b)

#### カレンダー機能(CRUD)
講座の開催日が自動でマンスリーカレンダーに表示される。  
項目を選択すると、講座詳細が表示される。  
![image](https://github.com/user-attachments/assets/120563f9-4b37-4f6a-8c8d-ea32abff5752)

カレンダー上のイベントを選択すると、講座の詳細が確認できる。  
![image](https://github.com/user-attachments/assets/624b67bd-5f2c-4889-8d3a-1263ee5601bc)

ユーザごとに予定を入れることもできます。  
![image](https://github.com/user-attachments/assets/c1b5d98b-5f4c-47ae-82f7-d6f72ee52b91)


## マイページ 
マイページでは、ニックネームやアバター画像の登録ができます。  
講座タイトル一覧でチェックしたタグが同様に色付きで表示されます。  
![image](https://github.com/user-attachments/assets/f478e589-6bc5-4108-995f-50bb3cebdd37)

## お問い合わせ機能
お問い合わせフォームから管理者に対してメッセージを送ることができます。  
![image](https://github.com/user-attachments/assets/4dac0c72-ec17-4608-a519-18bd3ce0b6c9)

## 管理者画面
### 管理者権限
登録ユーザーを一覧で管理できます。  
actionsの「edit」を押すと、編集画面に切り替わり、名前と権限が変更できます。  
「delete」を押すと、対象のユーザ情報が削除されます。  
![image](https://github.com/user-attachments/assets/8a409917-8ce6-4fde-88ec-5f499d154a12)

お問い合わせのあった項目は、管理者画面で表示されます。  

![image](https://github.com/user-attachments/assets/ff2013d2-e653-4832-ab65-c8865408105e)

## ポリシーページ
アプリ利用上の注意点や規約を記述しています。
![image](https://github.com/user-attachments/assets/ca7c61cf-a38d-4342-ac41-b6f39dc3e3d6)

## インフラ構成図
### 新規登録や認証処理の流れ
![image](https://github.com/user-attachments/assets/17e515c5-dfe8-4b25-bde5-4d1c44a6f3ab)


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
|5|redis|ActionCableのバックエンドストレージとして使用|
|6|pg|PostgreSQLをデータベースとして使用|
|7|puma|Railsアプリのサーバー|
  
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


