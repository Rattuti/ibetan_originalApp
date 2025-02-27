import { defineStore } from 'pinia'
import { ref } from 'vue'
import axios from 'axios'

axios.defaults.withCredentials = true;

const API_URL = 'http://localhost:3000/auth'

export const useAuthStore = defineStore('auth', () => {
    const user = ref(null);
    const isAuthenticated = ref(false);

    const getAuthHeaders = () => {
        const authHeaders = JSON.parse(localStorage.getItem("authHeaders"));
        
        // authHeaders が存在し、必要なプロパティが全て揃っているかチェック
        if (!authHeaders || !authHeaders["access-token"] || !authHeaders["client"] || !authHeaders["uid"]) {
            console.warn("認証ヘッダーが無効:", authHeaders);
            return null;
        }
        
        // ヘッダーを返す
        return {
            "access-token": authHeaders["access-token"],
            "client": authHeaders["client"],
            "uid": authHeaders["uid"],
            "expiry": authHeaders["expiry"],
            "token-type": authHeaders["token-type"],
            "Content-Type": "application/json"
        };
    };


    // ログイン処理
    const login = async (email, password) => {
        try {
            const response = await axios.post(`${API_URL}/sign_in`, {
                email,
                password
            }, {
                withCredentials: true  // Cookie 付きリクエスト
            });

            console.log("レスポンスヘッダー:", response.headers); 
            
            // 認証情報の保存
            user.value = response.data.data;
            isAuthenticated.value = true;

            // ログインしたユーザーの uid を取得
            const authHeaders = {
                'access-token': response.headers['access-token'],
                'client': response.headers['client'],
                'uid': response.headers['uid'],
                'expiry': response.headers['expiry'],
                'token-type': response.headers['token-type']
            };


            // user.value に uid を格納
            user.value.uid = authHeaders.uid;

            localStorage.setItem('authHeaders', JSON.stringify(authHeaders));
            // **ユーザー情報取得**
            await fetchUser();

            return response.data;
        } catch (error) {
            console.error("ログインエラー:", error.response?.data);
            throw error;
        }
    };

    // 新規登録処理
    const signUp = async (name, email, password) => {
        try {
            const requestData = {
                registration: { 
                    name,
                    email,
                    password,
                    password_confirmation: password
                },
            };

            console.log('送信データ:', JSON.stringify(requestData, null, 2));

            const response = await axios.post(API_URL, requestData);

            console.log('新規登録成功:', response.data);
            user.value = response.data.data;
            isAuthenticated.value = true;

            const authHeaders = {
                'access-token': response.headers['access-token'],
                'client': response.headers['client'],
                'uid': response.headers['uid'],
                'expiry': response.headers['expiry'],
                'token-type': response.headers['token-type'],
            };
            localStorage.setItem('authHeaders', JSON.stringify(authHeaders));

        } catch (error) {
            console.error('新規登録失敗:', error.response?.data || error.message);
            throw error;
        }
    };

    // ログアウト処理
    const logout = async () => {
        const headers = getAuthHeaders();
        if (!headers) {
            console.warn("無効な認証ヘッダーでログアウト処理をスキップ");
            return;
        }
    
        try {
            await axios.delete(`${API_URL}/sign_out`, { headers });
    
            // ローカルストレージと状態をクリア
            localStorage.removeItem("authHeaders");
            user.value = null;
            isAuthenticated.value = false;
    
            console.log("ログアウト成功");
        } catch (error) {
            console.error("ログアウト失敗:", error.response?.data || error);
        }
    };

    // ユーザー情報取得
    const fetchUser = async () => {
        const headers = getAuthHeaders();
        if (!headers) {
            console.warn('認証情報がありません');
            isAuthenticated.value = false;
            return;
        }

        try {
            const response = await axios.get(`${API_URL}/validate_token`, { headers });
            user.value = response.data.data;
            isAuthenticated.value = true;

            // ユーザー情報に uid を格納
            user.value.uid = response.data.data.uid;
        } catch (error) {
            console.error('ユーザー情報取得失敗:', error.response?.data || error.message);
            await useAuthStore().logout();
        }
    };

    return {
        user,
        isAuthenticated,
        login,
        signUp,
        logout,
        fetchUser,
        getAuthHeaders
    };
});
