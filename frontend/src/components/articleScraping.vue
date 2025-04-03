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
                        <div class="color-box" :style="{ backgroundColor: item.color }">
                        </div>
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
                            :class="{ active: item.click === 1, inactive: item.click === 0  }"
                            @click="toggleFavorite(item)"
                        />

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
import { useAuthStore } from "@/stores/auth";
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
        id: {
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
            console.log("元の articles:", this.articles);  // 取得した記事の一覧をログ出力
            const filtered = this.pageType === 'favorites'
                ? this.articles.filter(article => article.favorites > 0)
                : this.articles;
            console.log("フィルタ後の articles:", filtered);  // フィルタ後のデータを確認
            return filtered;
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
                { channel: "FavoriteChannel", article_id: this.id },
                {
                    received: (data) => {
                        console.log("ActionCable 受信:", data);

                        // Vueのプロパティは直接変更せず、新しい配列を作成する
                        const updatedArticles = this.articles.map(article => {
                            if (article.article_id === data.article_id) {
                                return { ...article, click: data.active ? 1 : 0 };
                            }
                            return article;
                        });

                        this.$emit("update-articles", updatedArticles); // 親に通知
                    }
                }
            );
        },
        async toggleFavorite(item) {
            console.log("クリックされた記事:", item); // 🔍 item に article_id があるか確認
            if (!item.article_id) {
                console.error("❌ 記事IDが不明です:", item);
                return;
            }

            try {
                const apiUrl = process.env.VUE_APP_API_URL || 'http://localhost:3000';
                const clickValue = item.click === 1 ? 0 : 1;

                console.log("APIリクエストURL:", `${apiUrl}/articles/${item.article_id}/favorites`);
                console.log("送信データ:", { favorite: { article_id: item.article_id, click: clickValue } });

                const authStore = useAuthStore(); // Pinia ストアを取得
                const headers = authStore.getAuthHeaders(); // getAuthHeaders を取得

                console.log("🔍 送信ヘッダー: ", headers);


                const response = await axios.post(`${apiUrl}/articles/${item.article_id}/favorites`, {
                    favorite: {
                        article_id: item.article_id,
                        click: clickValue
                    }
                }, { headers: headers })
                .then(response => console.log("APIレスポンス:", response.data))
                .catch(error => console.error("エラー:", error.response?.data || error));

                console.log("APIレスポンス:", response.data);

                if (response.data && response.data.favorite) {
                    item.click = response.data.favorite.click;
                } else {
                    throw new Error("お気に入りの更新に失敗しました。");
                }
            } catch (error) {
            this.errorMessage = "お気に入りの更新に失敗しました。";
            if (error.response) {
                console.error("サーバーエラーレスポンス:", error.response.data);
            } else {
                console.error("APIリクエストエラー:", error);
            }
            }
        }
    },

    beforeUnmount() {
        if (this.subscription) {
            this.subscription.unsubscribe();
        }
        if (this.cable) {
            this.cable.disconnect();
        }
    }

};
</script>


<style scoped>
.article-window {
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
    background-color: #39cccc;
    color: #fff;
}

.column-header {
    padding: 10px 10px;
    white-space: nowrap; /* 折り返しを防ぐ */
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

/* タグ列（アイコン） */
.favorite-cell {
    text-align: center; /* アイコンを中央に配置 */
    width: auto; /* 列幅を自動調整 */
    white-space: nowrap; /* 横文字固定 */
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

/* タグアイコンのスタイル */
.tag {
    font-size: 20px;
    color: #666;
    cursor: pointer;
    transition: color 0.3s, transform 0.2s, opacity 0.3s;
    opacity: 0.5; /* デフォルトは半透明 */
    display: inline-block; /* インラインブロックにする */
    vertical-align: middle; /* 中央寄せ */
}

.tag.active {
  color: #ff5722; /* アクティブ時の色 */
  opacity: 1; /* アクティブ時は不透明 */
}

.tag.inactive {
    color: #666; /* 非アクティブ時の色 */
    opacity: 0.5; /* 非アクティブ時は半透明 */
}

.tag:hover {
    transform: scale(1.2);
}
</style>
