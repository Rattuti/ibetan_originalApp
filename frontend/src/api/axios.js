import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3000', // Rails APIのURL
  withCredentials: true, // Cookie に認証情報を保存する場合は true
    headers: {
    'Content-Type': 'application/json'
    }
});

export default api;
