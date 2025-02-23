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
            <p class="email">現在、 {{ user?.email }} でログイン中です</p>
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
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/auth"; // Piniaのauthストアをインポート


export default {
    setup() {
        const router = useRouter();
        const authStore = useAuthStore(); // 認証ストアを利用
        const error = ref(null);

        // ユーザー情報をcomputedでリアクティブに取得
        const user = computed(() => authStore.user);
        const displayName = computed(() => user.value?.nickname || user.value?.name || "ゲスト");

        // コンポーネントがマウントされたらユーザー情報を取得
        onMounted(async () => {
            if (!user.value) {
                try {
                    await authStore.fetchUser();
                } catch (err) {
                    console.error("ユーザー情報の取得に失敗しました:", err);
                    error.value = "ユーザー情報の取得に失敗しました。";
                }
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
                await authStore.logout();
                router.push({ name: "Welcome" });
            } catch (err) {
                console.error("ログアウト中にエラーが発生しました:", err);
                error.value = "ログアウトに失敗しました。";
            }
        };

        return {
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

.logo-container {
    display: flex;
    align-items: center;
}

.logo {
    width: 80px;
    /* ロゴ画像の幅を設定 */
    height: auto;
    /* 比率を維持 */
    margin-right: 10px;
    /* テキストとの間隔 */
    margin-left: 20px;
    /* 左からの余白を追加 */
}

.button-container {
    display: flex;
    gap: 10px;
    /* ボタン間のスペースを設定 */
    justify-content: flex-end;
    /* ボタンを右詰めに配置 */
    margin-top: 5px;
    /* 上部余白を小さく */
}

button {
    font-size: 1.1rem;
    /* ボタン文字のサイズを小さく */
    padding: 5px 10px;
    /* ボタン内余白を調整 */
    white-space: nowrap;
    /* 1行に収める */
}

.avatar-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-left: 10px;
}

.avatar-placeholder {
    text-align: center;
    /* 中央寄せ */
    font-size: 11px;
    /* 文字サイズを小さく調整 */
}

.avatar-icon {
    width: 40px;
    /* アイコンの幅 */
    height: 40px;
    /* アイコンの高さ */
    border-radius: 50%;
    /* 円形にする */
    object-fit: cover;
    /* 画像のトリミング */
}</style>