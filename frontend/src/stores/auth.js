import { defineStore } from 'pinia';
import { ref } from 'vue';
import axios from 'axios';

const API_URL = 'http://localhost:3000/auth';

export const useAuthStore = defineStore('auth', () => {
    const user = ref(null);
    const isAuthenticated = ref(false);

    // 認証ヘッダー取得
    const getAuthHeaders = () => {
        const authHeaders = JSON.parse(localStorage.getItem("authHeaders"));
        console.log("取得した認証ヘッダー:", authHeaders);

        return authHeaders && authHeaders["access-token"] ? {
            "access-token": authHeaders["access-token"],
            "client": authHeaders["client"],
            "uid": authHeaders["uid"],
            "expiry": authHeaders["expiry"],
            "token-type": authHeaders["token-type"],
            "Content-Type": "application/json"
        } :{};
    };

    // 認証ヘッダー保存
    const saveAuthHeaders = (headers) => {
        if (!headers || !headers['access-token']) {
            console.warn("⚠️ 認証ヘッダーの保存をスキップ: ヘッダー情報が無効です");
            return;
        }

        const authHeaders = {
            'access-token': headers.get('access-token'),
            'client': headers.get('client'),
            'uid': headers.get('uid'),
            'expiry': headers.get('expiry'),
            'token-type': headers.get('token-type')
        };
    
        console.log("🔍 保存する認証ヘッダー:", authHeaders);
        localStorage.setItem('authHeaders', JSON.stringify(authHeaders));
    };

    // エラーハンドリング
    const handleError = (error) => {
        console.error("エラー:", error.response?.data || error.message);
        throw error;
    };

    // ログイン処理
    const login = async (email, password) => {
        try {
            const res = await axios.post(`${API_URL}/sign_in`, {
                email,
                password
            });
            console.log("🔍 ログインAPIレスポンスヘッダー:", res.headers); // ヘッダー内容をログ出力
            user.value = res.data.data;
            isAuthenticated.value = true;
            saveAuthHeaders(res.headers);// ヘッダーを保存
            await fetchUser();

        } catch (error) {
            handleError(error);
        }
    };

    // 新規登録
    const signUp = async (name, email, password) => {
        try {
            const res = await axios.post(API_URL, {
                registration: { 
                    name, 
                    email, 
                    password, 
                    password_confirmation: password 
                } });
            user.value = res.data.data;
            isAuthenticated.value = true;
            saveAuthHeaders(res.headers);

        } catch (error) {
            handleError(error);
        }
    };

    // ログアウト
    const logout = async () => {
        try {
            const headers = getAuthHeaders();
            if (!headers) return console.warn("ログアウト処理スキップ: 認証情報なし");
            await axios.delete(`${API_URL}/sign_out`, { headers });
            localStorage.removeItem("authHeaders");
            user.value = null;
            isAuthenticated.value = false;
        } catch (error) {
            handleError(error);
        }
    };

    // ユーザー情報取得
    const fetchUser = async () => {
        try {
            const headers = getAuthHeaders()|| {};
            console.log("取得した認証ヘッダー:", headers);

            if (!headers || !headers['access-token']) {
                console.warn("アクセストークンが存在しないため、ログアウト処理を実行します");
                await logout();
                return;
            }
    
            const res = await axios.get(`${API_URL}/validate_token`, { headers });
            user.value = res.data.data;
            isAuthenticated.value = true;
        } catch (error) {
            console.warn("ユーザー情報取得失敗");
            await logout();
        }
    };

    return { user, isAuthenticated, login, signUp, logout, fetchUser, getAuthHeaders };
});
