<template>
    <div class="article-window">
        <table v-if="filteredArticles && filteredArticles.length > 0" class="articles">
            <thead>
                <tr>
                    <th v-for="(column, index) in header" :key="index" class="column-header">
                        {{ column }}
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="item in filteredArticles" :key="item.article_id">
                    <td class="color-cell">
                        <!-- 色の四角を表示 -->
                        <div class="color-box" :style="{ backgroundColor: item.color }"></div>
                    </td>
                    <td>
                        <a :href="item.url">
                            {{ item.title }}
                        </a>
                    </td>
                    <td class="favorite-cell">
                        <font-awesome-icon
                            icon="tag"
                            class="tag"
                            :class="{ active: item.active }"
                            @click="toggleFavorite(item)"
                        />
                        <span class="favorite-count">
                            {{ item.favorites || 0 }}
                        </span>
                    </td>
                </tr>
            </tbody>
        </table>
        <div v-else>記事がありません。</div>
        <div v-if="errorMessage" class="error-message">
            {{ errorMessage }}
        </div>
    </div>
</template>

<script>
import { createConsumer } from "@rails/actioncable";
import axios from "axios";

export default {
    props: {
        articles: {
            type: Array,
            required: true,
            default: () => [] // 空配列をデフォルト値として設定
        },
        pageType: {
            type: String,
            required: true, // 親コンポーネントから必ず渡される
        },
        article_id: {
            type: Number,
            required: true
        }
    },
    data() {
        return {
            cable: null,
            subscription: null, // サブスクリプションを格納
            favorites: 0,
            active: false,
            header: ["", "タイトル", "タグ"],
            errorMessage: null,
        };
    },
    computed: {
        // pageTypeによって表示する記事を切り替える
        filteredArticles() {
            if (this.pageType === 'favorites') {
                return this.articles.filter(article => article.favorites > 0);
            }
            return this.articles;
        },
    },
    created() {
        const socketUrl = process.env.VUE_APP_SOCKET_URL || 'ws://localhost:3000/cable';
        this.setupCable(socketUrl);
    },
    methods: {
        setupCable(socketUrl) {
            this.cable = createConsumer(socketUrl);
            this.subscription = this.cable.subscriptions.create(
                { channel: "FavoriteChannel", article_id: this.article_id },
                {
                    received: (data) => {
                        this.favorites = data.favorites;
                        this.active = data.active;
                    }
                }
            );
        },
        async toggleFavorite(item) {
            try {
                const apiUrl = process.env.VUE_APP_API_URL || 'http://localhost:3000';
                await axios.post(`${apiUrl}/favorites`, { article_id: item.article_id });
                item.favorites = item.favorites === 1 ? 0 : 1;
                this.subscription.send({ favorites: item.favorites });
            } catch (error) {
                this.errorMessage = "お気に入りの更新に失敗しました。";
                console.error("お気に入りの更新に失敗しました。", error);
            }
        }
    },
    beforeUnmount() {
        if (this.cable) {
            this.cable.disconnect();
        }
    }
};
</script>

<style scoped>
.article-window {
    padding: 2px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    font-family: Arial, sans-serif;
}

/* テーブル全体のデザイン */
.articles {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
    font-size: 16px;
    text-align: left;
}

/* テーブルヘッダーのデザイン */
.articles thead tr {
    background-color: #007BFF;
    color: #fff;
}

.column-header {
    padding: 10px 10px;
    width: auto; /* 幅を調整 */
}

/* テーブル行のデザイン */
.articles tbody tr {
    border-bottom: 1px solid #ddd;
    transition: background-color 0.3s;
}

.articles tbody tr:nth-child(even) {
    background-color: #f2f2f2;
}

/* ホバー効果 */
.articles tbody tr:hover {
    background-color: #e6f7ff;
}

/* セルのスタイル */
.articles td {
    padding: 5px 5px;
}

/* 色付き四角のスタイル */
.color-cell {
    padding: 0; /* 余分なパディングを取り除く */
    text-align: center; /* 横方向で中央揃え */
}

.color-box {
    width: 15px;  /* 四角の横幅を最小に設定 */
    height: 20px; /* 高さも調整 */
    margin-right: 8px; /* タイトルとの間隔 */
    border-radius: 3px;  /* 丸みをつける */
}

/* タイトル列 */
.title-cell {
    width: 250px; /* タイトルの幅を小さく設定 */
    white-space: nowrap; /* 文字を1行に収める */
    overflow: hidden;
    text-overflow: ellipsis;
}

/* お気に入り列 */
.favorites-cell {
    width: auto; /* お気に入り列は文字幅に自動調整 */
    white-space: nowrap; /* テキストが折り返さないようにする */
    position: relative;
}

/* アイコンのスタイル */
.icon {
    float: left; /* アイコンを左寄せ */
    margin-right: 5px;
}

/* お気に入り数 */
.favorite-count {
    display: inline-block;
    text-align: right; /* お気に入り数を右寄せ */
    width: 100%; /* アイコンと同じ行に表示させる */
}

/* リンクスタイル */
.articles a {
    color: #007BFF;
    text-decoration: none;
    transition: color 0.3s;
}

.articles a:hover {
    color: #0056b3;
}

/* タグアイコンの色変更 */
.tag {
    font-size: 20px;
    color: #666;
    cursor: pointer;
    transition: color 0.3s, transform 0.2s, opacity 0.3s;
    opacity: 0.5; /* デフォルトは半透明 */
}

.tag.active {
  color: #ff5722; /* アクティブ時の色 */
  opacity: 1; /* アクティブ時は不透明 */
}

.tag:hover {
    transform: scale(1.2);
}
</style>
