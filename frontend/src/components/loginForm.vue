<template>
    <div v-if="shouldShowLoginForm">
        <h2>ログインユーザ情報入力</h2>
        <form @submit.prevent="handleLogin">
            <input v-model="email" 
                type="email" 
                placeholder="メールアドレス" 
                required 
            />
            <input v-model="password" 
                type="password" 
                placeholder="パスワード" 
                required 
            />
            <button type="submit" class="btn">ログイン</button>

            <p class="change-form">
                初めての方は
                <span @click="toggleForm">
                    こちら
                </span>をクリックして<br>ご登録ページへお進みください
            </p>
        </form>
        <p v-if="authStore.isAuthenticated">ログイン中: {{ authStore.user?.name }}</p>
    </div>

    <div v-else>
        <!-- 新規登録フォーム -->
        <h2>新規ユーザー情報登録</h2>
        <form @submit.prevent="handleSignUp">
            <input v-model="signUpName"
                type="text" 
                placeholder="名前" 
                required
            />
            <input v-model="signUpEmail" 
                type="email" 
                placeholder="メールアドレス" 
                required 
            />
            <input v-model="signUpPassword" 
                type="password" 
                placeholder="パスワード" 
                required
            />
            <input v-model="signUpPasswordConfirmation" 
                type="password" 
                placeholder="パスワード（確認用）" 
                required
            />
            <button type="submit" class="btn">新規登録</button>

            <p class="change-form">
                アカウント登録済の方は
                <span @click="toggleForm">
                    こちら
                </span>からログインしてください
            </p>
        </form>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter() // ルーターのインスタンスを取得

// ログイン用のデータ
const email = ref('')
const password = ref('')

// 新規登録用のデータ
const signUpName = ref('')
const signUpEmail = ref('')
const signUpPassword = ref('')
const signUpPasswordConfirmation = ref('')

const shouldShowLoginForm = ref(true)

// ログイン・新規登録フォーム切り替えトグルボタン
const toggleForm = () => {
    shouldShowLoginForm.value = !shouldShowLoginForm.value
}

// ログイン処理
const handleLogin = async () => {
    console.log("ログイン情報:", email.value, password.value) // ✅ ログ出力
    try {
        await authStore.login(email.value, password.value)
        alert('ログイン成功！')
        router.push('/chatRoom')
    } catch (error) {
        alert('ログイン失敗')
    }
}

// 新規登録処理
const handleSignUp = async () => {
    console.log("新規登録情報:", signUpName.value, signUpEmail.value, )
    if (signUpPassword.value !== signUpPasswordConfirmation.value) {
        alert('パスワードと確認用パスワードが一致しません')
        return
    }

    try {
        await authStore.signUp(signUpName.value, signUpEmail.value, signUpPassword.value, signUpPasswordConfirmation.value)
        alert('新規登録成功！')
        router.push('/chatRoom')
    } catch (error) {
        alert('新規登録失敗')
    }
}

</script>

<style scoped>
.btn {
    background-color: #007bff; /* デフォルトの青色 */
    color: white; /* 文字色を白に */
    border: none;
    padding: 10px 15px;
    cursor: pointer;
    font-size: 16px;
    border-radius: 5px;
    transition: background-color 0.3s;
}

.btn:hover {
    background-color: #0056b3; /* ホバー時に少し濃い青に */
}
</style>

