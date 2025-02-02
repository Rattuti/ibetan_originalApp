<template>
  <div class="container">
  <navHeaderBar />
    <div class="my-page">
      <h1>マイページ</h1>
      <div class="content">
        <!-- プロフィール部分 -->
        <div class="profile-section">
          <label class="profile-label">
            <div v-if="user.avatar" class="avatar-container">
              <img :src="user.avatar"
                    alt="プロフィール画像"
                    class="avatar"
              />
            </div>
            <div v-else class="avatar-placeholder">
              画像未設定
            </div>
            <input
              type="file"
              @change="onFileChange"
              class="file-input"
              id="file"
              />
            <label for="file"
              class="custom-file-label">
                画像を選択
            </label>
          </label>
          <div class="info-container">
            <label>
            ニックネーム:
            <input v-model="user.nickname" 
              placeholder="ニックネームを入力"
            />
          </label>
            <p><strong>お名前:</strong>
                {{ user.name || '未設定' }}
            </p>
            <p><strong>メールアドレス:</strong>
                {{ user.email || '未設定' }}
            </p>
          </div>
        </div>
      </div>
      <div class="button-container">
        <button @click="saveChanges">変更を保存</button>
        <button @click="goToProfile">プロフィール編集</button>
      </div>
    </div>
    <ArticleWindow />
    <contact />
    <navFooterBar />
    </div>
</template>

<script>
import navHeaderBar from '../components/navHeaderBar';
import ArticleWindow from './ArticleWindow';
import contact from '../components/contact';
import navFooterBar from '../components/navFooterBar';


import{reactive, onMounted} from "vue";
import axios from 'axios'
//import setItem from '../auth/setItem'


export default {
  components:{
    navHeaderBar,
    contact,
    navFooterBar,
    ArticleWindow
},

  name: "UserMyPage",
  setup() {
    // ユーザーデータのリアクティブ管理
    const user = reactive( {
        name: '',
        email: '',
        nickname: '',
        avatar: null// 画像の情報
    });

    // ローカルストレージから初期化
    onMounted(() => {
      const savedUser = localStorage.getItem("user");
      if (savedUser) {
        const parsedUser = JSON.parse(savedUser);
        user.name = parsedUser.name;
        user.email = parsedUser.email;
        user.nickname = parsedUser.nickname;
        user.avatar = parsedUser.avatar;
      } else {
        alert("ユーザー情報がありません。再度ログインしてください。");
      }
    });

    //ファイル選択時の処理
    const onFileChange = (event) => {
        const file = event.target.files[0]
        if (file) {
            const reader = new FileReader()
            reader.onload = () => {
              user.avatar = reader.result; // Base64に変換して保存
            };
            reader.readAsDataURL(file)
        }
      };

      const saveChanges = () => {// ローカルストレージに変更を保存
        axios
        .post('http://localhost:3000/auth/sign_in', user)
        .then((response) => {
          console.log('Response:', response); 
          // サーバーからの最新情報を反映
          const updatedUser = response.data;
          user.name = updatedUser.name;
          user.email = updatedUser.email;
          user.nickname = updatedUser.nickname;
          user.avatar = updatedUser.avatar;

          // ローカルストレージに保存
          localStorage.setItem("user", JSON.stringify(user));
          alert("変更が保存されました！");
        })
        .catch((error) => {
          console.error(error);
          alert("保存中にエラーが発生しました。");
        });
      };

      // プロフィール編集ページに遷移
      const goToProfile = () => {
        window.location.href = "/UserMyPage/Profile";
      };

      return{ user, onFileChange, saveChanges, goToProfile };
    },
    async fetchFavoriteArticles() {
      try {
          const response = await this.$axios.get('/favorites');
          this.articles = response.data;
      } catch (error) {
          this.errorMessage = "お気に入り記事の取得に失敗しました。";
          console.error(error);
      }
    }
};
</script>

<style>
.button-container {
  display: flex;
  gap: 20px; /* ボタン間の間隔 */
  justify-content: center; /* ボタンを中央揃え */
  margin-top: 20px; /* 上のコンテンツとの間隔 */
}


.profile-section {
    display: flex;
    align-items: center; /* 画像とテキストを縦揃え */
    gap: 20px;
  }
  
.avatar-placeholder {
  width: 100px;
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px dashed #ccc;
  border-radius: 50%;
  background-color: #f0f0f0;
  color: #888;
}
  
  .my-page {
  padding: 20px;
  background-color: white;
  border: 1px solid #ccc;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  font-family: Arial, sans-serif;
}

.content {
  display: flex;
  gap: 20px; /* セクション間の間隔 */
}

.profile-section,
.info-section {
  flex: 1; /* 各セクションを均等に配置 */
  padding: 10px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
}

.profile-label {
  display: inline-block; /* ラベルをインラインブロック化 */
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: #f9f9f9;
  text-align: center;
  white-space: nowrap; /* 改行を防ぎます */
}

.avatar {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 50%;
}

.file-input {
  display: none; /* ファイル入力を非表示に */
}

.custom-file-label {
  display: inline-block;
  padding: 10px 20px;
  background-color: #007bff;
  color: white;
  border-radius: 4px;
  cursor: pointer;
  text-align: center;
}

.custom-file-label:hover {
  background-color: #0056b3;
}

button {
  display: block;
  margin: 20px 0;
  padding: 10px 20px;
  font-size: 1em;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}
</style>