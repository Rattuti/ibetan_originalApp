<template>
    <div>
      <h2>Users</h2>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>
              <button @click="viewUser(user)">View</button>
              <button @click="editUser(user)">Edit</button>
              <button @click="deleteUser(user.id)">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        users: [], // ユーザー情報を格納する
      };
    },
    methods: {
      fetchUsers() {
        // サーバーからユーザー情報を取得する
        fetch('/api/users') // 仮のAPIエンドポイント
          .then((response) => response.json())
          .then((data) => {
            this.users = data;
          });
      },
      viewUser(user) {
        // ユーザーの詳細ページへ遷移
        this.$router.push({ name: 'UserDetail', params: { id: user.id } });
      },
      editUser(user) {
        // ユーザーの編集ページへ遷移
        this.$router.push({ name: 'EditUser', params: { id: user.id } });
      },
      deleteUser(userId) {
        // ユーザーを削除する
        if (confirm('Are you sure you want to delete this user?')) {
          fetch(`/api/users/${userId}`, { method: 'DELETE' })
            .then(() => {
              this.fetchUsers(); // 削除後にリストを更新
            });
        }
      },
    },
    mounted() {
      this.fetchUsers(); // コンポーネントのマウント時にユーザー情報を取得
    },
  };
  </script>
  
  <style scoped>
  table {
    width: 100%;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
  }
  th {
    background-color: #f4f4f4;
  }
  </style>
  