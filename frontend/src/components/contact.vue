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
import { ref } from "vue";
import axios from "axios";
import { useAuthStore } from "@/stores/auth";

export default {
  name: "ContactPage",
  setup() {
    const authStore = useAuthStore();
    const form = ref({
      name: localStorage.getItem("name") || "",
      email: localStorage.getItem("email") || "",
      message: "",
    });

    const handleSubmit = async () => {
      if (!form.value.message) {
        alert("メッセージを入力してください。");
        return;
      }

      try {
        const response = await axios.post(
          "http://localhost:3000/api/contacts",
          {
            contact: { ...form.value } // APIの仕様に合わせて送信
          },
          { headers: authStore.getAuthHeaders() }
        );
        console.log("送信データ:", form.value);
        console.log("送信成功:", response.data);
        alert("お問い合わせありがとうございます！");
        resetForm();
      } catch (error) {
        console.error("送信エラー:", error.response?.data || error);
        alert("お問い合わせの送信に失敗しました。");
      }
    };

    const resetForm = () => {
      form.value.message = "";
    };

    return { form, handleSubmit };
  }
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
