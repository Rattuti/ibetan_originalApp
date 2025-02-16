<template>
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
            <button v-if="!user.isEditing" @click="editUser(user)">Edit</button>
            <button v-if="user.isEditing" @click="updateUser(user)">Save</button>
            <button v-if="user.isEditing" @click="cancelEdit(user)">Cancel</button>
            <button @click="deleteUser(user.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <h2>お問い合わせ一覧</h2>
    <ul>
      <li v-for="contact in contacts" :key="contact.id">
        {{ contact.name }}: {{ contact.message }}
      </li>
    </ul>
  </div>
  <div v-else>
    <p>権限がありません</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";
import { useAuthStore } from "@/stores/auth";

const authStore = useAuthStore();
const users = ref([]);
const contacts = ref([]);

// 👤 ユーザー一覧を取得
const fetchUsers = async () => {
  try {
    const response = await axios.get("http://localhost:3000/api/users");
    users.value = response.data.map(user => ({ ...user, isEditing: false }));
  } catch (error) {
    console.error("ユーザー取得エラー", error);
  }
};

// 📩 お問い合わせ一覧を取得
const fetchContacts = async () => {
  try {
    const response = await axios.get("http://localhost:3000/api/contacts");
    contacts.value = response.data;
  } catch (error) {
    console.error("データ取得エラー", error);
  }
};

// 📝 ユーザー編集モード
const editUser = (user) => {
  user.isEditing = true;
};

// ✅ ユーザー情報を更新
const updateUser = async (user) => {
  try {
    await axios.put(`http://localhost:3000/api/users/${user.id}`, {
      name: user.name,
      role: user.role,
    });
    user.isEditing = false;
  } catch (error) {
    console.error("更新エラー", error);
  }
};

// ❌ 編集キャンセル
const cancelEdit = (user) => {
  user.isEditing = false;
};

// 🗑 ユーザー削除
const deleteUser = async (id) => {
  try {
    await axios.delete(`http://localhost:3000/api/users/${id}`);
    users.value = users.value.filter(user => user.id !== id);
  } catch (error) {
    console.error("削除エラー", error);
  }
};

// 初回ロード時にデータを取得
onMounted(() => {
  if (authStore.user?.role === "admin") {
    fetchUsers();
    fetchContacts();
  }
});
</script>
