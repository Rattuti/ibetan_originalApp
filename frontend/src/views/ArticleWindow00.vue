<template>
    <div>
    <h1>スクレイピング結果</h1>
    <!-- ローディング表示 -->
    <p v-if="isLoading">データを読み込み中...</p>

    <!-- エラーメッセージ -->
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>

    <!-- データの表示 -->
    <ul v-if="scrapedData.length > 0">
        <li v-for="(item, index) in scrapedData" :key="index">
        {{ item.title }}
        </li>
    </ul>

    <!-- データがない場合のメッセージ -->
    <p v-else>データがありません。</p>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    data() {
    return {
        scrapedData: [],
        isLoading: false,
        errorMessage: null,
    };
    },
    methods: {
    async fetchScrapedData() {
        this.isLoading = true;
        this.errorMessage = null;
        try {
        const response = await axios.get('http://localhost:3000/api/scraping');
        if (response.data && response.data.articles) {
            this.scrapedData = response.data.articles;
        } else {
            this.errorMessage = 'データが見つかりませんでした。';
        }
        } catch (error) {
        this.errorMessage = 'データの取得に失敗しました。';
        console.error('Error fetching scraped data:', error);
        } finally {
        this.isLoading = false;
        }
    },
    },
    mounted() {
    this.fetchScrapedData();
    },
};
</script>

<style scoped>
.error {
    color: red;
    font-weight: bold;
}
</style>
