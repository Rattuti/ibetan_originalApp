<template>
    <div class="chat-bubble">
        <div v-show="messages" class="messages" ref="messages">
            <ul>
                <li 
                    v-for="message in messages" 
                    :key="message.id"
                    :class="{
                            received: message.email !== uid, 
                            sent: message.email === uid
                    }"
                >
                    <span class="name">{{ message.nickname || message.name }}</span>
                    <div
                        class="message"
                        @click="openMarkSelector(message)"
                        :aria-label="`メッセージ内容：${message.content}`"
                    >
                        {{ message.content }}
                        <div class="heart-container">
                            <font-awesome-icon
                                :icon="message.markType? ['fas', message.markType] : ''"
                                :class="['heart', message.isLiked ? 'liked' : '']"
                                aria-label="いいねアイコン"
                                role="button"
                                tabindex="0"
                            />
                        </div>
                    </div>
                    <span class="created-at">{{ message.created_at }}前</span>
                </li>
            </ul>
        </div>

        <!-- マーク選択ダイアログ -->
        <div v-if="selectedMessage" class="mark-selector">
            <p>マークを選んでください</p>
            <button v-for="(mark, index) in marks" :key="index" @click="toggleLike(selectedMessage, mark)">
                <font-awesome-icon v-if="mark" :icon="['fas', mark]" />
            </button>

            <button @click="selectedMessage = null">キャンセル</button>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import { useAuthStore } from "@/stores/auth";

export default {
    props: {
        messages: {
            type: Array,
            default: () => []
        }
    },
    data() {
        return {
            authStore: useAuthStore(),
            selectedMessage: null,
            marks: ["", "heart", "thumbs-up", "smile", "star"]

        };
    },
    computed: {
        uid() {
            return this.authStore.uid;
        },
        authHeaders() {
            return {
                uid: this.uid || '',
                'access-token': localStorage.getItem('access-token') ?? '',
                client: localStorage.getItem('client') ?? '',
            };
        }
    },
    methods: {
        openMarkSelector(message) {
            this.selectedMessage = message;
        },
        async toggleLike(message, markType) {
            try {
                // 既に「いいね」が付いている場合、更新。それ以外は新規作成。
                const existingLike = message.isLiked ? message.id : null;

                let res;
                if (existingLike) {
                    // 既存の「いいね」を更新
                    res = await axios.patch(
                        `http://localhost:3000/likes/${existingLike}`,
                        { click: 1, mark_type: markType },
                        { headers: this.authHeaders }
                    );
                } else {
                    // 新しい「いいね」を作成
                    res = await axios.post(
                        `http://localhost:3000/messages/${message.id}/likes`,
                        { click: 1, mark_type: markType },
                        { headers: this.authHeaders }
                    );
                }

                if (res.data) {
                    // 成功した場合に「いいね」の状態を更新
                    message.isLiked = res.data.click === 1;
                    message.markType = res.data.mark_type;
                } else {
                    console.error("無効なレスポンス:", res);
                }
            } catch (error) {
                console.error("いいね切り替えエラー", error);
            }
        }
    },
};
</script>

<style scoped>
.heart {
    cursor: pointer;
    transition: color 0.3s;
}

.liked {
    color: red;
}

.heart-container {
    display: flex;
    align-items: center;
    font-size: 14px;
}

.mark-selector {
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    background: white;
    padding: 10px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.mark-selector button {
    margin: 5px;
    font-size: 20px;
    background: none;
    border: none;
    cursor: pointer;
}
</style>
