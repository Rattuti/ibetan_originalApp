<template>
<div>
    <h2>ログイン</h2>
    <form @submit.prevent="login">
        <input 
            type="email"
            required placeholder="メールアドレス"
            v-model="email"
        >
        <input
            type="password"
            required placeholder="パスワード"
            v-model="password"
        >
        <div class="error">{{ error }}</div>
        <button
            :disabled="isLoading"
            :class="{ loading: isLoading }">
            {{ isLoading ? 'ログイン中...' : 'ログインする'}}
        </button>
    </form>
</div>
</template>

<script>
import axios from 'axios'
import setItem from '@/auth/setItem'

export default {
    emits: ['redirectToChatRoom'],
    data () {
        return {
        email: '',
        password: '',
        error :null,
        isLoading: false, //ローディング状態
        }
    },
    methods: {
        async login() {
            this.error = null
            this.isLoading = true
            try {
                // ログインリクエスト送信
                const loginData = { email: this.email, password: this.password }
                const res = await axios.post('http://localhost:3000/auth/sign_in', loginData)

                // ヘッダー情報を保存
                setItem(res.headers, res.data.data.name)

                // チャットルームへのリダイレクトを通知
                this.$emit('redirectToChatRoom')
            }catch (err) {
                if(err.response && err.response.status === 401){
                    this.error = 'メールアドレスかパスワードが違います'
                }else{
                    this.error = 'サーバーエラーが発生しました。後でもう一度お試しください。'
                }
            }finally{
                this.isLoading = false
            }
        }
    }
}
</script>

<style>
form {
    display: flex;
    flex-direction: column; /* フォーム内の要素を縦並びに配置 */
    align-items: center; /* 要素を中央揃え */
    gap: 10px; /* 要素間のスペースを設定 */
    width: 100%; /* フォームの幅を調整 */
    max-width: 300px; /* フォームの最大幅を設定 */
    margin: 0 auto; /* フォームを中央に配置 */
}
input {
    width: 100%; /* 入力フィールドをフォーム幅に合わせる */
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
}
button {
    width: 100%; /* ボタンをフォーム幅に合わせる */
    padding: 10px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
button.loading {
    cursor: not-allowed;
    opacity: 0.7;
}
button:hover {
    background-color: #0056b3; /* ホバー時の色変更 */
}
.error {
    color: red;
    margin-top: 10px;
}
</style>