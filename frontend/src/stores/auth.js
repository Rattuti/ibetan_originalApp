import { defineStore } from 'pinia'
import {ref} from 'vue'
import axios from 'axios'

const API_URL = 'http://localhost:3000/auth'

export const useAuthStore = defineStore('auth', () => {
// 状態
const user = ref(null)
const isAuthenticated = ref(false)

// ログイン処理
async function login(email, password) {
    try {
    const response = await axios.post(`${API_URL}/sign_in`, { email, password })

    user.value = response.data.data
    isAuthenticated.value = true

    const authHeaders = {
        'access-token': response.headers['access-token'],
        'client': response.headers['client'],
        'uid': response.headers['uid'],
        'expiry': response.headers['expiry'],
        'token-type': response.headers['token-type'],
        'authorization': response.headers['authorization']
    }
    localStorage.setItem('authHeaders', JSON.stringify(authHeaders))
    } catch (error) {
    console.error('ログイン失敗:', error.response?.data || error)
    throw error
    }
}

// 新規登録処理
async function signUp(name, email, password) {
    try {
    const response = await axios.post(API_URL, {
        name,
        email,
        password,
        password_confirmation: password
    })
    console.log('新規登録成功:', response.data)
    user.value = response.data.data
    isAuthenticated.value = true

    const authHeaders = {
        'access-token': response.headers['access-token'],
        'client': response.headers['client'],
        'uid': response.headers['uid'],
        'expiry': response.headers['expiry'],
        'token-type': response.headers['token-type'],
        'authorization': response.headers['authorization']
    }
    localStorage.setItem('authHeaders', JSON.stringify(authHeaders))
    } catch (error) {
    console.error('新規登録失敗:', error.response?.data || error)
    throw error
    }
}

// ログアウト処理
function logout() {
    user.value = null
    isAuthenticated.value = false
    localStorage.removeItem('authHeaders')
}

// ユーザー情報取得
async function fetchUser() {
    const headers = JSON.parse(localStorage.getItem('authHeaders'))
    if (!headers) return

    try {
    const response = await axios.get(API_URL, { headers })
    user.value = response.data.data
    isAuthenticated.value = true
    } catch (error) {
    console.error('ユーザー情報取得失敗:', error.response?.data || error)
    logout()
    }
}

// ストアで定義した状態のメソッドを返して、コンポーネントから使用できるようにしている
return {
    user,
    isAuthenticated,
    login,
    signUp,
    logout,
    fetchUser
}
})
