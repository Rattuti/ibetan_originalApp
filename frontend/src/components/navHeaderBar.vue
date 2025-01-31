<template>
    <nav>
        <div v-if="user && user.avatar" class="avatar-container">
            <img :src="user.avatar" alt="プロフィール画像" class="avatar-icon" />
        </div>
        <div v-else class="avatar-placeholder">
            アイコン未設定
        </div>
        <div>
            <p>こんにちは、<span class="name">{{ displayName }}</span>さん</p>
            <p class="email">現在、 {{ email }} でログイン中です</p>
            <div class="error">{{ error }}</div>
        </div>
        <div class="button-container">
            <button @click="goToHome">ホーム</button>
            <button @click="goToMyPage">マイページ</button>
            <button @click="logout">ログアウト</button>
        </div>
    </nav>
</template>

<script>
import { ref,onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";

export default {
    setup() {
        const router = useRouter();
        const name = ref("ゲスト");
        const email = ref("未設定");
        const user = ref({});
        const error = ref(null);

        const displayName = ref("ゲスト");
    // ユーザー情報をローカルストレージから取得
        onMounted(() => {
            try {
                name.value = window.localStorage.getItem("name") || "ゲスト";
                email.value = window.localStorage.getItem("uid") || "未設定";
                user.value = localStorage.getItem("user")
                ? JSON.parse(localStorage.getItem("user"))
                : {};

                displayName.value = user.value.nickname || name.value;
            } catch (err) {
                console.error("ユーザー情報の取得に失敗しました:", err);
                error.value = "ユーザー情報の取得に失敗しました。";
            }
        });

        const goToHome = () => {
            router.push("/ChatRoom");
        };

        const goToMyPage = () => {
            router.push("/UserMyPage");
        };

        const logout = async () => {
            error.value = null;

            try {
                const res = await axios.delete("http://localhost:3000/auth/sign_out", {
                    headers: {
                        uid: email.value,
                        "access-token": window.localStorage.getItem("access-token"),
                        client: window.localStorage.getItem("client"),
                    },
                });

                if (res.status === 200) {
                    console.log("ログアウトしました");
                    ["access-token", "client", "uid", "name", "user"].forEach((key) =>
                        window.localStorage.removeItem(key)
                    );
                    router.push({ name: "Welcome" });
                } else {
                    throw new Error("ログアウトできませんでした");
                }
            } catch (err) {
                console.error("ログアウト中にエラーが発生しました:", err);
                error.value = "ログアウトに失敗しました。";
            }
        };

        return {
            name,
            email,
            user,
            error,
            displayName,
            goToHome,
            goToMyPage,
            logout,
        };
    },
};
</script>

<style scoped>
nav {
    padding: 10px;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
nav p {
    margin: 2px auto;
    font-size: 16px;
    color: #444;
}
nav p.email {
    font-size: 14px;
    color: #999;
}
.logo-container{
    display: flex;
    align-items: center;
}
.logo{
    width: 80px; /* ロゴ画像の幅を設定 */
    height: auto; /* 比率を維持 */
    margin-right: 10px; /* テキストとの間隔 */
    margin-left: 20px; /* 左からの余白を追加 */
}
.button-container {
    display: flex;
    gap: 10px; /* ボタン間のスペースを設定 */
    justify-content: flex-end; /* ボタンを右詰めに配置 */
    margin-top: 5px; /* 上部余白を小さく */
}
button {
    font-size: 1.1rem; /* ボタン文字のサイズを小さく */
    padding: 5px 10px; /* ボタン内余白を調整 */
    white-space: nowrap; /* 1行に収める */
}
.avatar-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-left: 10px;
}
.avatar-placeholder {
    text-align: center; /* 中央寄せ */
    font-size: 11px; /* 文字サイズを小さく調整 */
}

.avatar-icon {
  width: 40px; /* アイコンの幅 */
  height: 40px; /* アイコンの高さ */
  border-radius: 50%; /* 円形にする */
  object-fit: cover; /* 画像のトリミング */
}

</style>