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
            <span class="name">{{ message.name }}</span>
            <div
                class="message"
                @dblclick="handleLike(message)"
                :aria-label="`メッセージ内容：${message.content}`"
            >
                {{ message.content }}
                <div v-if="message.likes.length" class="heart-container">
                <font-awesome-icon
                    icon="heart"
                    class="heart"
                    aria-label="いいねアイコン"
                    role="button"
                    tabindex="0"
                    @click="handleLike(message)"
                />
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
import { nextTick } from 'vue';

export default {
    emits: ['connectCable'],
    props: ['messages'],
    data() {
        return {
        uid: localStorage.getItem('uid'),
        };
    },
    methods: {
        async handleLike(message) {
        const like = message.likes.find(like => like.email === this.uid);
        like ? await this.deleteLike(like.id) : await this.createLike(message.id);
        },
        async createLike(messageId) {
        await this.sendLikeRequest(
            `http://localhost:3000/messages/${messageId}/likes`,
            'post'
        );},
        async deleteLike(likeId) {
        await this.sendLikeRequest(
            `http://localhost:3000/likes/${likeId}`,
            'delete'
        );},
        async sendLikeRequest(url, method) {
        try {
            const res = await axios({
            url,
            method,
            headers: this.authHeaders,
            });
            if (res.status === 200) {
            this.$emit('connectCable');
            } else {
            throw new Error('リクエストに失敗しました');
            }
        } catch (error) {
            console.error(error.message);
        }
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
    computed: {
        authHeaders() {
        return {
            uid: this.uid,
            'access-token': localStorage.getItem('access-token'),
            client: localStorage.getItem('client'),
        };
        },
    },
    mounted() {
        nextTick(() => {
        this.scrollToBottom();
        });
    },
    watch: {
        messages: {
        handler() {
            nextTick(() => this.scrollToBottom());
        },
        deep: false,
        },
    },
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

.received {
    float: left;
}

.sent {
    float: right;
}

.message {
    padding: 10px;
    border-radius: 30px;
    margin-bottom: 2px;
    max-width: 400px;
    display: inline-block;
}

.received .message {
    background: #eee;
}

.sent .message {
    background: #677bb4;
    color: white;
}

.name {
    font-size: 13px;
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