<template>
  <div class="profile-page">
    <h1>プロフィール編集</h1>
    <form @submit.prevent="updateProfile">
      <div class="form-group">
        <label for="name">お名前</label>
        <input type="text"
          id="name"
          v-model="form.name"
          required
        />
      </div>
      <div class="form-group">
        <label for="email">メールアドレス</label>
        <input type="email"
          id="email"
          v-model="form.email"
          required
        />
      </div>
        <button type="submit">保存</button>
    </form>
  </div>
</template>

<script>
export default {
  name: "ProfilePage",
  data() {
    return {
      form: {
        name: "",
        email: "",
      },
    };
  },
  mounted(){
    //ローカルストレージからデータを取得
    this.form.name = localStorage.getItem("name") || "ゲスト";
    this.form.email = localStorage.getItem("email") || "未設定";
    },
    methods:{
      updateProfile() {
      // ローカルストレージにデータを保存
      localStorage.setItem("name", this.form.name);
      localStorage.setItem("email", this.form.email);

      alert(`プロフィールを更新しました:\n名前: ${this.form.name}\nメール: ${this.form.email}`);
      this.$router.push("/UserMyPage"); // マイページにリダイレクト
    }
  },
};
</script>

<style scoped>
.profile-page {
  max-width: 600px;
  margin: 20px auto;
  padding: 20px;
  background-color: white;
  border: 1px solid #ccc;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  font-family: Arial, sans-serif;
}

.form-group {
  margin-bottom: 1.5em;
}

label {
  display: block;
  font-weight: bold;
  margin-bottom: 0.5em;
}

input {
  width: 100%;
  padding: 0.5em;
  font-size: 1em;
  border: 1px solid #ccc;
  border-radius: 4px;
}

button {
  display: block;
  width: 100%;
  padding: 0.75em;
  font-size: 1em;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}
</style>
