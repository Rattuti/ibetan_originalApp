<template>
  <div class="container">
    <navHeaderBar />
    <div class="my-page">
      <h1>マイページ</h1>
      <div class="content">
        <!-- プロフィール部分 -->
        <div class="profile-section">
          <label class="profile-label">
            <div v-if="user.avatar && user.avatar !== ''" class="avatar-container">
              <img v-if="avatarUrl" :src="avatarUrl" alt="プロフィール画像" class="avatar" />
            </div>
            <div v-else class="avatar-placeholder">画像未設定</div>
              <input type="file" @change="onFileChange" class="file-input" id="file" />
              <label for="file" class="custom-file-label">画像を選択</label>
          </label>

          <div class="info-container">
            <label>
              ニックネーム:
              <input v-model="user.nickname" placeholder="ニックネームを入力" />
            </label>
            <p><strong>お名前:</strong> {{ user?.name || "未設定" }}</p>
            <p><strong>メールアドレス:</strong> {{ user?.email || "未設定" }}</p>
            <div class="button-container">
              <button @click="saveChanges">変更を保存</button>
            </div>
          </div>

        </div>
      </div>

    </div>
    <ArticleWindow />
    <contact />
    <navFooterBar />
  </div>
</template>

<script>
import { computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";
import navHeaderBar from "../components/navHeaderBar";
import ArticleWindow from "./ArticleWindow";
import contact from "../components/contact";
import navFooterBar from "../components/navFooterBar";
import { useAuthStore } from "@/stores/auth"; // Piniaのauthストアをインポート

export default {
  components: {
    navHeaderBar,
    contact,
    navFooterBar,
    ArticleWindow,
  },
  name: "UserMyPage",
  setup() {
    const authStore = useAuthStore(); //useAuthStoreの呼び出し
    const user = computed(() => authStore.user || { avatar: "", nickname: "", name: "", email: "" });

    // ヘッダーの取得
    const getAuthHeaders = authStore.getAuthHeaders;
    const router = useRouter();

    // ローカルストレージからユーザー情報を読み込む
    onMounted(() => {
      console.log("マイページのユーザーデータ:", user.value);
      console.log("authStore.user:", authStore.user);
      const savedUser = localStorage.getItem("user");
      if (savedUser) {
        user.value = JSON.parse(savedUser); // Pinia の user を更新
      } else {
        alert("ユーザー情報がありません。再度ログインしてください。");
      }
    });

    // ユーザー情報を更新
    const saveChanges = () => {
      axios
        .patch(`http://localhost:3000/api/users/${user.value.id}`, { nickname: user.value.nickname }, {
          headers: getAuthHeaders(),
        })
        .then((response) => {
          console.log("Response:", response);
          // サーバーからの最新情報を反映
          const updatedUser = response.data;
          user.value = updatedUser;
          authStore.user = updatedUser;  // ここで `authStore.user` も更新

          // ローカルストレージに保存
          localStorage.setItem("user", JSON.stringify(user.value));
          alert("変更が保存されました！");
        })
        .catch((error) => {
          console.error(error);
          alert("保存中にエラーが発生しました。");
        });
    };

    const avatarUrl = computed(() => {
      if (user.value?.avatar) {
        return `http://localhost:3000${user.value.avatar}`;
      }
      return null;
    });

    // アバター画像をアップロード
    const onFileChange = async (event) => {
      const file = event.target.files[0];
      if (!file) return;

      const formData = new FormData();
      formData.append("avatar", file);

      try {
        const response = await axios.patch(
          `http://localhost:3000/api/users/${user.value.id}`,
          formData,
          { headers: { ...getAuthHeaders(), "Content-Type": "multipart/form-data" } }
        );
        user.value.avatar = response.data.avatar; // サーバーから返された画像URLを反映
        localStorage.setItem("user", JSON.stringify(user.value));
        alert("アバターが更新されました！");
      } catch (error) {
        console.error("アバターのアップロードに失敗:", error);
      }
    };


    // プロフィール編集ページに遷移
    const goToProfile = () => {
      router.push("/UserMyPage/Profile");
    };

    return {
      user,
      avatarUrl, 
      onFileChange,
      saveChanges,
      goToProfile,
    };
  },
};
</script>


<style>
navHeaderBar, navFooterBar {
    margin: 0;
    padding: 0;
}

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
  width: 50px;
  height: 50px;
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