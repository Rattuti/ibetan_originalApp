<template>
    <div>
        <table>
        <thead>
            <tr>
                <th v-for="(column, index) in header" :key="index">{{ column }}</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="article in articles" :key="article.id">
            <td>
                <a :href="article.url">{{ article.title }}</a>
            </td>
            <td>

            </td>
            </tr>
        </tbody>
        </table>
        <div v-if="!articles.length">記事がありません。</div>
        <div v-if="errorMessage" class="error-message">{{ errorMessage }}</div>
    </div>
</template>

<script>
//import ActionCable from 'actioncable';
import axios from "axios";

export default {
    data() {
        return {
            articles: [], // 記事データを格納
        };
    },
    methods: {
        async fetchArticles() {
            try {
                const response = await axios.get("http://localhost:3000/api/scraping"); // Rails APIから記事データを取得
                this.articles = response.data; // 取得したデータを格納
            } catch (error) {
                console.error("データ取得に失敗しました:", error);
            }
        },
    },
    mounted() {
        this.fetchArticles(); // コンポーネントがマウントされたときにデータを取得
    },
};
</script>

<style scoped>
.article-window {
    padding: 20px;
}
.error-message {
    color: red;
    background-color: #ffe6e6;
    border: 1px solid red;
    padding: 10px;
    margin-top: 10px;
}
</style>