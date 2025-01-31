<template>
    <div class="contact-page">
      <form @submit.prevent="handleSubmit">
        <div class="form-group">
          <label for="message">お問い合わせ内容</label>
          <textarea id="message" v-model="form.message" placeholder="お問い合わせ内容を入力してください" rows="5" required></textarea>
        </div>
  
        <button type="submit">送信</button>
      </form>
    </div>
  </template>
  
  <script>
  export default {
    name: "ContactPage",
    data() {
      return {
        form: {
          name: localStorage.getItem("userName") || "", // ローカルストレージから取得
          email: localStorage.getItem("userEmail") || "", // ローカルストレージから取得 
          message: "",
        },
      };
    },
    methods: {
      handleSubmit() {
        // フォーム送信処理
        if (this.form.name && this.form.email && this.form.message) {
          alert("お問い合わせありがとうございます！");
          this.resetForm();
        } else {
          alert("全てのフィールドを入力してください。");
        }
      },
      resetForm() {
        this.form.name = "";
        this.form.email = "";
        this.form.message = "";
      },
    },
  };
  </script>
  
  <style scoped>
.contact-page {
  margin: 0; /* 余白をリセット */
  padding: 20px;
  background-color: white;
  border: 1px solid #ccc;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  font-family: Arial, sans-serif;
}

h1 {
  font-size: 2em;
  margin-bottom: 1em;
  text-align: center;
}

.form-group {
  margin-bottom: 1.5em;
}

label {
  display: block;
  font-weight: bold;
  margin-bottom: 0.5em;
}

input,
textarea {
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
