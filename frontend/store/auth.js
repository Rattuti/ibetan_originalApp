import axios from 'axios';

export default {
namespaced: true,
state: {
    user: JSON.parse(localStorage.getItem('user')) || null,
    token: localStorage.getItem('access-token') || null,
    client: localStorage.getItem('client') || null,
    uid: localStorage.getItem('uid') || null,
},
mutations: {
    setUser(state, user) {
    state.user = user;
    localStorage.setItem('user', JSON.stringify(user));
    },
    setToken(state, headers) {
    state.token = headers['access-token'];
    state.client = headers.client;
    state.uid = headers.uid;

    localStorage.setItem('access-token', headers['access-token']);
    localStorage.setItem('client', headers.client);
    localStorage.setItem('uid', headers.uid);
    },
    logout(state) {
    state.user = null;
    state.token = null;
    state.client = null;
    state.uid = null;

    localStorage.removeItem('user');
    localStorage.removeItem('access-token');
    localStorage.removeItem('client');
    localStorage.removeItem('uid');
    }
},
actions: {
    async login({ commit }, credentials) {
    try {
        const response = await axios.post('/api/auth/sign_in', credentials);

        commit('setToken', response.headers);
        await this.dispatch('auth/fetchUser'); // ユーザーデータを Rails API から取得
    } catch (error) {
        console.error('ログイン失敗:', error);
        throw error;
    }
    },
    async fetchUser({ commit, state }) {
    if (!state.token) return;

    try {
        const response = await axios.get('/api/users/me', {
        headers: {
            'access-token': state.token,
            client: state.client,
            uid: state.uid,
        }
        });

        commit('setUser', response.data);
    } catch (error) {
        console.error('ユーザー情報の取得に失敗:', error);
    }
    },
    logout({ commit }) {
    commit('logout');
    }
},
getters: {
    isAuthenticated: (state) => !!state.token,
    userName: (state) => state.user ? state.user.name : '',
    userRole: (state) => state.user ? state.user.role : '',
}
};
