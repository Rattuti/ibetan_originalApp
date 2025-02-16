<template>
    <div>
        <h2>ログイン</h2>
        <form @submit.prevent="handleLogin">
            <input v-model="email" type="email" placeholder="メールアドレス" required />
            <input v-model="password" type="password" placeholder="パスワード" required />
            <button type="submit">ログイン</button>
        </form>
        <p v-if="authStore.isAuthenticated">ログイン中: {{ authStore.user?.name }}</p>
    </div>

    <div>
        <!-- 新規登録フォーム -->
        <h2>新規登録</h2>
        <form @submit.prevent="handleSignUp">
            <input v-model="signUpName" type="text" placeholder="名前" required />
            <input v-model="signUpEmail" type="email" placeholder="メールアドレス" required />
            <input v-model="signUpPassword" type="password" placeholder="パスワード" required />
            <input v-model="signUpPasswordConfirmation" type="password" placeholder="パスワード（確認用）" required />
            <button type="submit">新規登録</button>
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
    if (signUpPassword.value !== signUpPasswordConfirmation.value) {
        alert('パスワードと確認用パスワードが一致しません')
        return
    }

    try {
        await authStore.signUp(signUpName.value, signUpEmail.value, signUpPassword.value)
        alert('新規登録成功！')
        router.push('/chatRoom')
    } catch (error) {
        alert('新規登録失敗')
    }
}

</script>
