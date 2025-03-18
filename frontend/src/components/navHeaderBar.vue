<template>
    <nav>
        <div v-if="user && user.avatar" class="avatar-container">
            <img 
                :src="user.avatar" 
                alt="プロフィール画像" 
                class="avatar-icon"
            />
        </div>
        <div v-else class="avatar-placeholder">
            アイコン未設定
        </div>
        <div>
            <p>こんにちは、<span class="name">{{ displayName }}</span>さん</p>
            <div class="error">{{ error }}</div>
        </div>

        <div class="button-container">
            <div>
                <button v-if="user && user.role === 'admin'" @click="goToAdmin">管理者画面</button>
            </div>
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
        const error = ref(null);// エラーメッセージの管理

        // ユーザー情報をcomputedでリアクティブに取得
        const user = computed(() => authStore.user);

        // ユーザーの表示名を決定（ニックネーム優先、なければ名前、どちらもなければ「ゲスト」）
        const displayName = computed(() => user.value?.nickname || user.value?.name || "ゲスト");

        // コンポーネントがマウントされたらユーザー情報を取得
        onMounted(async () => {
            console.log(user.value.avatar); // user.avatar の中身をコンソールに出力
            if (!user.value) {
                try {
                    await authStore.fetchUser();// ユーザー情報を取得
                } catch (err) {
                    console.error("ユーザー情報の取得に失敗しました:", err);
                    error.value = "ユーザー情報の取得に失敗しました。";
                }
            }
        });

        // 管理者画面へ遷移
        const goToAdmin = () => {
            router.push("/Admin");
        };


        // ホーム画面へ遷移
        const goToHome = () => {
            router.push("/ChatRoom");
        };

        // マイページへ遷移
        const goToMyPage = () => {
            router.push("/UserMyPage");
        };

        // ログアウト処理
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
            goToAdmin,
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
    background-color: white;
}

nav p {
    margin: 2px auto;
    font-size: 16px;
    color: #444;
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
    margin-left: 20px;
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