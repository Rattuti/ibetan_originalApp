<template>
    <nav>
        <div>
            <p class="title">ibetan</p>
            <div class="error">{{ error }}</div>
        </div>

        <div class="login-container">
            <button @click="handleGuestLogin" class="btn guest-btn">ゲストログイン</button>
        </div>
    </nav>
</template>

<script>
import { ref, computed } from "vue";
import { useAuthStore } from "@/stores/auth"; // Piniaのauthストアをインポート
import axios from "axios";

export default {
    setup() {
        const authStore = useAuthStore(); // 認証ストアを利用
        const error = ref(null);// エラーメッセージの管理

        // ユーザー情報をcomputedでリアクティブに取得
        const user = computed(() => authStore.user);

        // ゲストログイン成功後にトークンをlocalStorageに保存
        const handleGuestLogin = async () => {
            try {
                const response = await axios.post('/auth/guest_login');
                const { auth_token } = response.data;
                
                // トークンをlocalStorageに保存
                localStorage.setItem('authToken', auth_token);
                
                // 認証ヘッダーを設定
                axios.defaults.headers['Authorization'] = `Bearer ${auth_token}`;
                
                console.log('ゲストログイン成功');
                // 他の処理...
            } catch (error) {
                console.error('ゲストログイン失敗:', error);
            }
        };


        return {
            user,
            error,
            handleGuestLogin,
        };
    },
};
</script>

<style scoped>
nav {
    padding: 0px 10px 2px 40px;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: white;
}

nav p {
    margin: 2px auto;
    font-size: 16px;
    color: #444;
}

.title {
    font-weight: bold;   /* 太字 */
    font-size: 24px;     /* 文字サイズ */
    color: #39cccc;         /* 文字色 */
}

.btn {
    color: white; /* 文字色を白に */
    border: none;
    padding: 0px 15px 0px 10px;
    cursor: pointer;
    font-size: 16px;
    border-radius: 5px;
    transition: background-color 0.3s;
}

button {
    font-size: 1.1rem;
    /* ボタン文字のサイズを小さく */
    padding: 5px 10px;
    /* ボタン内余白を調整 */
    white-space: nowrap;
    /* 1行に収める */
}

.login-container {
    display: flex;
    justify-content: center; /* ボタンを中央に配置 */
}

/* ゲストログインボタン (赤) */
.guest-btn {
    min-width: 150px;
    background-color: #FF0000;
    color: white;
}
.guest-btn:hover {
    background-color: #CC0000; /* 少し暗めの赤 */
}

</style>