import { defineStore } from 'pinia';
import { ref } from 'vue';
import axios from 'axios';

const API_URL = 'http://localhost:3000/auth';
const USERS_API_URL = 'http://localhost:3000/api/users'; // 例

export const useAuthStore = defineStore('auth', () => {
    const user = ref(null);// 現在ログインしているユーザー
    const users = ref([]);
    const isAuthenticated = ref(false);// 認証状態

    // 認証ヘッダー取得
    const getAuthHeaders = () => {
        const authHeaders = JSON.parse(localStorage.getItem("authHeaders"));
        console.log("取得した認証ヘッダー:", authHeaders);
    
        if (!authHeaders || !authHeaders["access-token"]) {
            console.error("認証トークンがありません。ログインが必要です。");
            return {};
        }
    
        return {
            "access-token": authHeaders["access-token"],
            "client": authHeaders["client"],
            "uid": authHeaders["uid"],
            "expiry": authHeaders["expiry"],
            "token-type": authHeaders["token-type"],
            "Content-Type": "application/json"
        };
    };

    // 認証ヘッダー保存
    const saveAuthHeaders = (headers) => {
        if (!headers || !headers['access-token']) {
            console.warn("⚠️ 認証ヘッダーの保存をスキップ: ヘッダー情報が無効です");
            return;
        }
    
        const authHeaders = {
            'access-token': headers['access-token'],
            'client': headers['client'],
            'uid': headers['uid'],
            'expiry': headers['expiry'],
            'token-type': headers['token-type']
        };
    
        console.log("🔍 保存する認証ヘッダー:", authHeaders);
        localStorage.setItem('authHeaders', JSON.stringify(authHeaders));
    };
    

    // エラーハンドリング
    const handleError = (error) => {
        console.error("エラー:", error.response?.data || error.message);
        throw error;
    };

    // ゲストログイン関数を追加
    const guestLogin = async () => {
        try {
            const res = await axios.post('http://localhost:3000/auth/guest_login');
            
            console.log("レスポンスヘッダー:", res.headers); // ここを確認
            
            saveAuthHeaders(res.headers); // ここでヘッダーを保存
            console.log("保存後のヘッダー:", getAuthHeaders()); // 保存された値を確認
    
            isAuthenticated.value = true;
            await fetchUser();
        } catch (error) {
            console.error("ゲストログインエラー:", error);
        }
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
            const headers = getAuthHeaders();
            console.log("取得した認証ヘッダー:", headers);

            if (!headers['access-token']) {
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


    // すべてのユーザーを取得
    const fetchUsers = async () => {
        try {
            const headers = getAuthHeaders();
            console.log("fetchUsers:🔑 取得した認証ヘッダー:", headers);
        
            if (!headers['access-token']) {
                console.warn("アクセストークンなし: ユーザーリスト取得をスキップ");
                return undefined;  // アクセストークンがない場合、明示的に undefined を返す
            }
        
            const res = await axios.get(USERS_API_URL, { headers });
            console.log("APIレスポンス:", res);  // レスポンスを確認
            
            if (res && res.data && Array.isArray(res.data.users)) {
                console.log("レスポンスデータ:", res.data.users);
                users.value = res.data.users; // 🔹 `authStore.users` を正しく更新
                return res.data.users; // 🔹 `users` 配列のみ返す
            } else {
                console.error("APIレスポンスが不正:", res.data);
                return undefined;
            }
        } catch (error) {
            console.error("ユーザー一覧取得エラー:", error);
            return undefined;
        }
    };
    


    return { user, users, isAuthenticated, guestLogin, login, signUp, logout, fetchUser, fetchUsers, getAuthHeaders };
});
