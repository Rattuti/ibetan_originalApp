<template>
    <div class="chat-bubble">
        <div v-show="messages" class="messages" ref="messages">
            <ul>
                <li v-for="message in messages" :key="message.id" :class="{
                    received: message.email !== uid, // 受信者のメッセージ
                    sent: message.email === uid     // 送信者のメッセージ
                }" >
                    <span class="name">{{ message.nickname ? message.nickname : message.name }}</span>
                    <div class="message" @click="handleLike(message)" :aria-label="`メッセージ内容：${message.content}`">
                        {{ message.content }}
                        <div v-if="message.likes && message.likes.length" class="heart-container">
                            <font-awesome-icon icon="heart" class="heart" aria-label="いいねアイコン" role="button" tabindex="0"
                                @click.stop="handleLike(message)" />
                            <span class="heart-count">{{ message.likes.length }}</span>
                        </div>
                    </div>
                    <span class="created-at">{{ message.created_at }}前</span>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import { useAuthStore } from "@/stores/auth";
import { nextTick } from 'vue';

export default {
    emits: ['connectCable'],
    props: {
        messages: {
            type: Array,
            default: () => [] //空配列をデフォルトに
        }
    },
    data() {
        return {
            authStore: useAuthStore(),  // Piniaストアのインスタンスを取得
        };
    },
    computed: {
        uid() {
            console.log("this.authStore.uid:", this.authStore.user.uid);
            return this.authStore.user.uid;
        },
        authHeaders() {
            const headers = {
                uid: localStorage.getItem("uid") ?? "",
                "access-token": localStorage.getItem("access-token") ?? "",
                client: localStorage.getItem("client") ?? "",
            };
            console.log("送信するヘッダー:", headers);
            return headers;
        }
    },
    methods: {
        async handleLike(message) {
            if (!message.likes) return;

            const like = message.likes.find(like => like.user_id === this.uid);

            if (like) {
                await this.deleteLike(message.id, like.id);
            } else {
                await this.createLike(message.id);
            }
        },

        async createLike(messageId) {
            await this.sendLikeRequest(
                `http://localhost:3000/messages/${messageId}/likes`,
                'post'
            );
        },
        async deleteLike(messageId, likeId) {
            await this.sendLikeRequest(
                `http://localhost:3000/messages/${messageId}/likes/${likeId}`,
                'delete'
            );
        },
        async sendLikeRequest(url, method, data = {}) {
            try {
                const headers = {
                    ...this.authHeaders(),
                    "Content-Type": "application/json"
                };

                console.log("送信するURL:", url);
                console.log("送信するデータ:", data);
                console.log("送信するヘッダー:", headers);

                const res = await axios({
                    url,
                    method,
                    headers,
                    data
                });
                if (res.status === 200 || res.status === 201) {
                    this.$emit('connectCable');
                } else {
                    throw new Error('リクエストに失敗しました');
                }
            } catch (error) {
                console.error(error.message);
            }
        },
        logMessageInfo(message) {
            console.log(`message.email: ${message.email}, uid: ${this.uid}`);
        },

        scrollToBottom() {
            const element = this.$refs.messages;
            if (element) {
                element.scrollTop = element.scrollHeight;
            } else {
                console.warn('scrollToBottom: messages ref is not available');
            }
        },
    },
    mounted() {
        nextTick(() => {
            // UIDがセットされた後でスクロールをする
            this.scrollToBottom();
        });
    },
    watch: {
        'authStore.uid': {
            handler(newUid) {
                if (newUid) {
                    this.$nextTick(() => {
                        this.scrollToBottom();
                    });
                }
            },
            immediate: true
        }
    }
};
</script>

<style scoped>
.chat-bubble {
    background: white;
    padding: 30px 20px;
    border-bottom: 1px solid #eee;
}

ul {
    list-style: none;
    margin: 0;
    padding: 0;
}

ul li {
    display: inline-block;
    clear: both;
}

.received .message {
    background: #eee;
    /* 受信者のメッセージの色 */
    padding: 10px;
    display: inline-block;
    border-radius: 30px;
    margin-bottom: 2px;
    max-width: 400px;
}

.received {
    float: left;
}

.sent {
    float: right;
}

.sent .message {
    background: #677bb4;
    /* 送信者のメッセージの色 */
    color: white;
    padding: 10px;
    display: inline-block;
    border-radius: 30px;
    margin-bottom: 2px;
    max-width: 400px;
}

.messages {
    max-height: 400px;
    overflow: auto;
}

.name {
    font-size: 13px;
    font-weight: bold;
}

.created-at {
    color: #999;
    font-size: 12px;
    margin-top: 3px;
}

.messages {
    max-height: 400px;
    overflow: auto;
}

.heart-container {
    position: absolute;
    bottom: -7px;
    right: 0;
    display: flex;
    align-items: center;
    background: white;
    border: 1px solid #f5f5f5;
    border-radius: 30px;
    padding: 2px;
    font-size: 9px;
}

.heart {
    cursor: pointer;
}
</style>