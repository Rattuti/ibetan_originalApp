# :relieved: はじめに
このアプリは、地域の講座やコミュニテ情報を手軽に検索・参加できるサービスをコンセプトにしています。  
※　講座情報は作成者の利用の範囲内での許可をいただき活用しています。  

# 💡アプリ制作背景
ある日、外出先で偶然見つけた「託児付き講座」に参加しました。
親としても充実した時間が過ごせるだけでなく、子どもも楽しい時間を過ごせることを実感しました。
「こんなに素敵な講座があったのに、今まで知らなかったなんて…！」
そう思い、忙しい方や子育て中の方が、もっと簡単に地域の講座情報にアクセスできるようにしたいと考え、このアプリを開発しました。  

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
### ログイン機能
登録済ユーザなら、「メールアドレス」と「パスワード」の入力でログインできます。  
※　「ゲストログイン」からアプリを使うことができます。  
![image](https://github.com/user-attachments/assets/a06976a5-ac68-45d9-b87a-1598e5a3a567)

### 新規登録機能
ログインボタン下の「こちら」を選択する新規ユーザ登録画面に切り替わります。  
![image](https://github.com/user-attachments/assets/4206b333-0fd0-429c-8b12-16fdf4be1634)

https://github.com/user-attachments/assets/1a29d3c4-2d90-48d6-b7ab-4f27400a48eb


## ヘッダー
基本的に「ホーム」「マイページ」「ログアウト」ボタンを押すと対応するページへ移動します。  
新規ユーザ登録すると、登録した時の名前が表示されます。  
（※　マイページで、アバター画像とニックネームを入れて登録ができます。）  
![image](https://github.com/user-attachments/assets/524c0c65-a056-4f80-8826-0d55772a5a9a)

管理者権限を持つユーザがログインすると「管理者画面」ボタンが表示されます。  
![image](https://github.com/user-attachments/assets/3a641487-ff0c-4446-bd14-a37988f0e243)

## ホーム画面
### 講座情報とタグチェック
開催予定の講座情報のタイトルが一覧で表示されます。  
気になる講座のタグをチェックすると赤色が付き、マイページでも確認ができます。  
![image](https://github.com/user-attachments/assets/219f7dff-b08f-4e92-90dc-6b50da8ae94c)

### ライブメッセージ + いいね機能
メッセージを入力し投稿すると、アバター画像と登録名を含むメッセージがリアルタイムで表示されます。  
意見交換の場として用意しました。  
メッセージをダブルクリックすると、マーク（❤、⭐️、👍️）が選択できます。  
![image](https://github.com/user-attachments/assets/5c254730-9d3a-47cb-92b9-ae929d3dff9e)



https://github.com/user-attachments/assets/fb80facb-43ce-44d9-8249-d48a4c8a10d9



ログインユーザのメッセージは右側の列（メッセージ枠の背景が藍色）として表示されます。  
※　他のユーザは左列（メッセージ枠の背景が灰色）で表示されます。  
![image](https://github.com/user-attachments/assets/638b8e15-8869-45b1-8513-edfb7c2e1dca)

#### カレンダー機能(CRUD)
講座の開催日は自動でマンスリーカレンダーに登録表示されます。  
![image](https://github.com/user-attachments/assets/c1a00862-43d7-4eea-9550-494afd17333a)

カレンダー上で対応する講座を選択すると、講座内容の詳細が確認できます。  
※　講座への申し込みは公式HPより申請してください。  
![image](https://github.com/user-attachments/assets/624b67bd-5f2c-4889-8d3a-1263ee5601bc)

ユーザごとにカレンダーへ予定を登録し編集することもできます。  
![image](https://github.com/user-attachments/assets/c1b5d98b-5f4c-47ae-82f7-d6f72ee52b91)



https://github.com/user-attachments/assets/101b342a-cae8-4e52-a337-20f3a0b5ef31




## マイページ 
マイページでは、ニックネームやアバター画像の登録ができます。  
ホーム画面と同様の講座タイトルとチェックしたタグが表示されます。  
![image](https://github.com/user-attachments/assets/4e808995-1090-47f4-af86-fed043b8cc37)

## お問い合わせ機能
お問い合わせフォームから管理者へメッセージを送ることができます。  
![image](https://github.com/user-attachments/assets/4dac0c72-ec17-4608-a519-18bd3ce0b6c9)

## 管理者画面
### 管理者権限
登録ユーザーの一覧管理ができます。  
Actions列では登録ユーザの編集操作ができます。  
「Edit」を押すと、登録ユーザの編集モードに切り替わり、名前と役割の変更が可能です。  
※「Delete」を押すと、対象のユーザと紐づく履歴がすべて削除されます。    
ユーザからのお問い合わせは、Contact列で確認ができます。  
![image](https://github.com/user-attachments/assets/0e13a3f1-c442-4ef5-ba6f-91c50c90e5b1)


## ポリシーページ
アプリ利用上の注意点や規約を記述しています。  
![image](https://github.com/user-attachments/assets/a4b72829-c49a-48db-8930-38e204a03b77)

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
|8|faker|ダミーデータ（テストデータ）作成|
  
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
アプリ開発を振り返ると、考えた分だけ使い勝手が良くなっていくので、本当に楽しい経験でした。
初めての要件定義やER図作成、エラーとの戦いもありましたが、形になった瞬間の感動は忘れられません！
没頭できる幸せを感じると同時に、「もっと効率的に」「さらに使いやすく」といった課題も見え、次の目標の糧になりました。

最後まで読んでいただき、ありがとうございました！
ご感想やアドバイスをいただけると嬉しいです！
