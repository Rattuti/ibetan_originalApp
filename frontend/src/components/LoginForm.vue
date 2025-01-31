<template>
<div>
    <h2>ログイン</h2>
    <form @submit.prevent="login">
        <input type="email" required placeholder="メールアドレス" v-model="email">
        <input type="password" required placeholder="パスワード" v-model="password">
        <div class="error">{{ error }}</div>
        <button>ログインする</button>
    </form>
</div>
</template>

<script>
import axios from 'axios'
import setItem from '../auth/setItem'

export default {
    emits: ['redirectToChatRoom'],
    data () {
        return {
        email: '',
        password: '',
        error :null
        }
    },
    methods: {
        async login() {
        try {
            this.error = null
            const res = await axios.post('http://localhost:3000/auth/sign_in', {
                email: this.email,
                password: this.password,
            })
            if (!res) {
                throw new Error('メールアドレスかパスワードが違います')
            }
            if (!this.error) {
                setItem(res.headers, res.data.data.name)
                this.$emit('redirectToChatRoom')
            }
            return res
            }catch (error) {
            this.error = 'メールアドレスかパスワードが違います'
            }
        }
    }
}
</script>