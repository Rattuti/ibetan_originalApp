<template>
  <navHeaderBar />
  <div v-if="authStore.user?.role === 'admin'">
    <h2>Users</h2>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Email</th>
          <th>Role</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>{{ user.id }}</td>
          <td>
            <input v-if="user.isEditing" v-model="user.name" />
            <span v-else>{{ user.name }}</span>
          </td>
          <td>{{ user.email }}</td>
          <td>
            <select v-if="user.isEditing" v-model="user.role">
              <option value="admin">Admin</option>
              <option value="user">User</option>
            </select>
            <span v-else>{{ user.role }}</span>
          </td>
          <td>
            <button v-if="!user.isEditing" @click="user.isEditing = true">Edit</button>
            <button v-if="user.isEditing" @click="updateUser(user)">Save</button>
            <button v-if="user.isEditing" @click="cancelEdit(user)">Cancel</button>
            <button @click="deleteUser(user.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <h2>お問い合わせ一覧</h2>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Name (Email)</th>
          <th>Contact</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="contact in contacts" :key="contact.id">
          <td>{{ contact.user_id }}</td>
          <td v-if="getUserById(contact.user_id)">
            <strong>{{ getUserById(contact.user_id).name }}</strong>
            ({{ getUserById(contact.user_id).email }})
          </td>
          <td>{{ contact.message }}</td>
        </tr>
      </tbody>
    </table>
  </div>
  <div v-else>
    <p>権限がありません</p>
  </div>
  <navFooterBar />
</template>

<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";
import { useAuthStore } from "@/stores/auth";

import navHeaderBar from "../components/navHeaderBar";
import navFooterBar from "../components/navFooterBar";

const authStore = useAuthStore();
console.log(authStore.getAuthHeaders());
const users = ref([]);
const contacts = ref([]);

// ✅ データ取得
const fetchData = async () => {
  console.log("✅ データ取得開始");
  console.log("🔍 現在のユーザー情報:", authStore.user);

  if (authStore.user?.role !== "admin"){
    console.warn("⚠️ 管理者権限がありません");
    return;
  } 

  try {
    const authHeaders = authStore.getAuthHeaders();
    console.log("📝 送信する認証ヘッダー:", authHeaders);

    const [userRes, contactRes] = await Promise.all([
      axios.get("http://localhost:3000/admin/users", { headers: authHeaders}),
      axios.get("http://localhost:3000/api/contacts", { headers: authHeaders}),
    ]);
    users.value = userRes.data.map(user => ({ ...user, isEditing: false }));
    contacts.value = contactRes.data;

    console.log("👥 ユーザーデータ:", users.value);
    console.log("📩 コンタクトデータ:", contacts.value);
    console.log("✅ データ取得完了");
  } catch (error) {
    console.error("データ取得エラー", error);
    if (error.response) {
      console.error("📡 サーバーからのレスポンス:", error.response);
    }
  }
};

// ✅ ユーザー更新
const updateUser = async (user) => {
  try {
    await axios.put(
      `http://localhost:3000/admin/users/${user.id}`,
      { name: user.name, role: user.role },
      { headers: authStore.getAuthHeaders()  }
    );
    user.isEditing = false;
  } catch (error) {
    console.error("更新エラー", error);
  }
};

// ✅ 編集キャンセル
const cancelEdit = (user) => {
  user.isEditing = false;
  fetchData(); // キャンセル時に最新データ取得（元の値に戻す）
};

// ✅ ユーザー削除
const deleteUser = async (id) => {
  try {
    await axios.delete(`http://localhost:3000/admin/users/${id}`, { headers: authStore.getAuthHeaders() });
    users.value = users.value.filter(user => user.id !== id);
  } catch (error) {
    console.error("削除エラー", error);
  }
};

// ✅ ユーザー情報を取得する関数
const getUserById = (userId) => {
  return users.value.find(user => user.id === userId);
};

// ✅ 初回ロード
onMounted(fetchData);
</script>

<style scoped>

navHeaderBar, navFooterBar {
    margin: 0;
    padding: 0;
}

table {
  width: 100%;
  border-collapse: collapse; /* 枠線を重ねて見やすく */
}

th, td {
  border: 1px solid #ddd; /* 枠線をグレーに */
  padding: 8px;
  text-align: left;
}

th {
  background-color: #f4f4f4; /* ヘッダーを目立たせる */
}
</style>
