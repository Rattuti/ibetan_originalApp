<template>
  <div v-if="currentUser && currentUser.role === 'admin'">
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
  </div>
  <div v-else>
    <p>権限がありません</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      users: [], // ユーザー一覧
      currentUser: null, // ログインユーザー情報
    };
  },
  methods: {
    async fetchCurrentUser() {
      try {
        const response = await fetch('/api/current_user'); // APIで現在のユーザー情報を取得
        this.currentUser = await response.json();
        if (this.currentUser.role !== 'admin') {
          alert('管理者権限が必要です');
          this.$router.push('/'); // 権限がない場合はリダイレクト
        }
      } catch (error) {
        console.error('Error fetching current user:', error);
      }
    },
    async fetchUsers() {
      try {
        const response = await fetch('/api/users');
        this.users = await response.json();
      } catch (error) {
        console.error('Error fetching users:', error);
      }
    },
    editUser(user) {
      this.$set(user, 'isEditing', true);
    },
    cancelEdit(user) {
      user.isEditing = false;
      this.fetchUsers();
    },
    async updateUser(user) {
      try {
        await fetch(`/api/users/${user.id}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name: user.name, role: user.role }),
        });
        user.isEditing = false;
        alert('User updated successfully');
      } catch (error) {
        console.error('Error updating user:', error);
        alert('Failed to update user');
      }
    },
    async deleteUser(userId) {
      if (confirm('Are you sure you want to delete this user?')) {
        try {
          await fetch(`/api/users/${userId}`, { method: 'DELETE' });
          this.fetchUsers();
        } catch (error) {
          console.error('Error deleting user:', error);
          alert('Failed to delete user');
        }
      }
    },
  },
  async mounted() {
    await this.fetchCurrentUser(); // ログインユーザー情報を取得
    if (this.currentUser?.role === 'admin') {
      this.fetchUsers(); // 管理者ならユーザー一覧を取得
    }
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
button {
  margin-right: 5px;
}
</style>
