<template>
  <div class="container">
    <articleScraping
      :articles="articles"
      :pageType="'UserMyPage'"
    />
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    <p v-if="isLoading" class="loading">データを読み込み中...</p>
  </div>
</template>

<script>
import articleScraping from "../components/articleScraping";
import axios from "axios";

export default {
  components: { articleScraping },
  data() {
    return {
      articles: [], // 初期値は空配列
      errorMessage: null,
      isLoading: false,
    };
  },
  methods: {
    async fetchArticles() {
      try {
        const response = await axios.get("http://localhost:3000/api/scraping");
        console.log("取得したデータ:", response.data);

        if (response.data && Array.isArray(response.data.articles)) {
        this.articles = response.data.articles.map(article => ({
            ...article,
            article_id: article.id // `id` を `article_id` として扱う
        }));
        console.log("セット後の articles:", this.articles); // 🔍 確認用ログ
    } else {
        this.errorMessage = "記事データが正しく取得できませんでした。";
    }
      } catch (error) {
          this.errorMessage = error.response
              ? `サーバーエラー: ${error.response.status}`
              : "ネットワークエラーが発生しました。";
          console.error("API取得エラー:", error);
      }
    }
  },
  mounted() {
    this.fetchArticles();
  },
};
</script>

<style scoped>
.container {
  width: 100%;
  margin: 0 auto;
  font-family: Arial, sans-serif;
}
.error {
  color: red;
  font-weight: bold;
  margin: 20px 0;
  text-align: center;
}
.loading {
  color: #555;
  margin: 20px 0;
  text-align: center;
  font-style: italic;
}
</style>
