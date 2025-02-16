<template>
    <h2>アカウントを登録</h2>
    <form @submit.prevent="signUp">
        <input type="text" required placeholder="名前" v-model="name" />
        <input type="email" required placeholder="メールアドレス" v-model="email" />
        <input type="password" required placeholder="パスワード" v-model="password" />
        <input type="password" required placeholder="パスワード（確認用）" v-model="passwordConfirmation" />
        <div class="error">{{ error }}</div>
        <button>登録する</button>
    </form>
</template>

<script>
import axios from 'axios'
import setItem from '../auth/setItem'// ユーザー情報を保存する関数

export default {
    emits: ['redirectToChatRoom'],
    data () {
        return {
        name: '',
        email: '',
        password: '',
        passwordConfirmation: '',
        error: null
        }
    },
    methods: {
        async signUp () {
            this.error = null

            try {
                const res = await axios.post('http://localhost:3000/auth', {
                name: this.name,
                email: this.email,
                password: this.password,
                password_confirmation: this.passwordConfirmation
                });

                //レスポンスが成功の場合
                if(res.status === 200){
                    setItem(res.headers, res.data.data.name)//トークンやユーザー情報を保存
                    this.$emit('redirectToChatRoom')
                }
                return res
            } catch (error) {
                if (error.response && error.response.data.errors) {
                    //バックエンドから詳細なエラー情報が返らされる場合
                    this.error = error.response.data.errors.join(', ')// 詳細エラー表示
                } else {
                    //その他のエラー（ネットワークエラーなど）
                    this.error = 'アカウントを登録できませんでした'
                }
                console.error(error);
            }
        },
    },
};
</script>