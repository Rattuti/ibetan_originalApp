import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        isAuthenticated: false
    }),
    actions: {
        async login(email, password) {
            try {
                if (!password || password.length < 6) {
                    throw new Error('パスワードは6文字以上必要です')
                }
                // 仮の認証処理
                this.user = { name: 'テストユーザー', email }
                this.isAuthenticated = true
            } catch (error) {
                throw new Error('ログインに失敗しました')
            }
        },
        async signUp(name, email, password) {
            try {
                if (!password || password.length < 6) {
                    throw new Error('パスワードは6文字以上必要です')
                }
                // 仮の登録処理
                this.user = { name, email }
                this.isAuthenticated = true
            } catch (error) {
                throw new Error('新規登録に失敗しました')
            }
        },
        logout() {
            this.user = null
            this.isAuthenticated = false
        }
    }
})
