<template>
    <div class="chat-bubble">
        <div v-show="messages" class="messages" ref="messages">
            <ul>
                <li v-for="message in messages" :key="message.id" :class="{
                    received: message.email !== uid, // 受信者のメッセージ
                    sent: message.email === uid     // 送信者のメッセージ
                }">
                    <span class="name">{{ message.nickname ? message.nickname : message.name }}</span>
                    <div class="message" @dblclick="handleLike(message)" :aria-label="`メッセージ内容：${message.content}`">
                        {{ message.content }}

                        <!-- いいねが1回クリックされた場合にマークを選択できる -->
                        <select
                            v-if="Array.isArray(message.likes) && message.likes.some(like => like.uid === uid && like.click === 1)"
                            :value="selectedMark[message.id]" 
                            @change="updateMarkType(message)">
                            <option value="heart">❤️</option>
                            <option value="star">⭐</option>
                            <option value="thumbs-up">👍</option>
                        </select>

                        <!-- いいねが確定された場合にマークを表示 -->
                        <span
                            v-if="selectedMark[message.id] && message.likes.find(like => like.uid === uid)?.click === 2">
                            <span v-if="selectedMark[message.id] === 'heart'">❤️</span>
                            <span v-if="selectedMark[message.id] === 'star'">⭐</span>
                            <span v-if="selectedMark[message.id] === 'thumbs-up'">👍</span>
                        </span>

                    </div>
                    <span class="created-at">{{ message.created_at }}前</span>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import { ref, computed, watch, onMounted} from "vue";
import { useAuthStore } from "@/stores/auth";
import { createConsumer } from "@rails/actioncable";

export default {
    props: {
        messages: {
            type: Array,
            default: () => []
        }
    },
    setup(props) {
        const authStore = useAuthStore();
        const uid = computed(() => authStore.user?.uid);
        const cable = ref(null);
        const selectedMark = ref({}); // 選択されたマークの状態を管理

        // メッセージごとのマークを初期化する関数
        const initSelectedMark = () => {
            // if (!props.messages || props.messages.length === 0) {
            //     console.warn("No messages available");
            //     return;
            // }

            // console.log("🔍 マークの初期化");
            // const updatedMarks = {};
            // props.messages.forEach(message => {
            //     const likes = message.likes || [];  // likes が undefined なら空の配列に
            //     const like = likes.find(like => like.uid === uid.value);

            //     if (like) {
            //         console.log(`👤 ${like.uid} === ${uid.value} `);
            //     } else {
            //         console.log(`⚠️ Likeが見つかりませんでした (uid: ${uid.value})`);
            //     }


            //     if (like) {
            //         if (like && like.click === 2) {  
            //             updatedMarks[message.id] = like.mark_type || "heart"; 
            //         } else if (like && like.click === 1) {
            //             updatedMarks[message.id] = like.mark_type || null;
            //         } else {
            //             updatedMarks[message.id] = null;
            //         }
            //     } else {
            //         updatedMarks[message.id] = null;
            //     }

            // });

            if (!props.messages || props.messages.length === 0) return;

const updatedMarks = {};
props.messages.forEach(message => {
    const like = message.likes?.find(like => like.uid === uid.value);
    if (like && like.click === 2) {
        updatedMarks[message.id] = like.mark_type || "heart";
    } else {
        updatedMarks[message.id] = null;
    }
});
            selectedMark.value = { ...updatedMarks }; // ✅ ここで一括更新
            console.log("🔍 修正後の selectedMark:", JSON.stringify(selectedMark.value));
        // コンソールで likes の確認を強化
        };


        // いいねを切り替え
        // handleLikeメソッド内で空のレスポンスを処理
        const localMessages = ref([...props.messages]);

        const handleLike = async (message) => {
            console.log(`✅ いいねのリクエスト送信: ${message.id}`);

            const currentLike = (message.likes || []).find((like) => like.uid === uid.value);
            const newClickValue = currentLike && currentLike.click === 1 ? 0 : 1;
            
            try {
                const response = await fetch(`http://localhost:3000/messages/${message.id}/like/toggle`, {
                method: "POST",
                headers: {
                    ...authStore.getAuthHeaders(),
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    uid: uid.value,
                    mark_type: selectedMark.value[message.id] || "heart", // デフォルト値を設定
                    click: newClickValue
                })
                });

                if (!response.ok) {
                console.error("❌ サーバーエラー: ", response.statusText);
                return;
                }

                const data = await response.json();
                console.log("🔍 APIレスポンス:", data);

                // メッセージのいいね情報を更新
                const messageIndex = localMessages.value.findIndex((m) => m.id === message.id);
                if (messageIndex !== -1) {
                localMessages.value[messageIndex].likes = data.likes || [];
                }

                // `selectedMark` の更新を適切に処理
                if (data.mark_type) {
                selectedMark.value = {
                    ...selectedMark.value,
                    [message.id]: data.mark_type
                };
                console.log("✅ 更新後の selectedMark:", JSON.stringify(selectedMark.value));
                } else {
                console.warn("⚠️ API から mark_type が返されませんでした");
                }
            } catch (error) {
                console.error("❌ APIリクエストエラー:", error);
            }
        };


        // マークタイプを更新
        const updateMarkType = async (message, newMarkType) => {
            console.log(`🚀 マークタイプ変更 (message ID: ${message.id}, 新マーク: ${newMarkType})`);

            const likeIndex = message.likes?.findIndex(like => like.uid === uid.value || like.user_id === uid.value);
            if (likeIndex === -1) return; // 該当する like がない場合は処理を終了

            // Vue のリアクティブシステムで更新を検知させる
            selectedMark.value = { ...selectedMark.value, [message.id]: newMarkType };
            console.log("🛠 更新直後の selectedMark:", JSON.stringify(selectedMark.value));

            try {
                // API にリクエストを送信
                const response = await fetch(`http://localhost:3000/messages/${message.id}/like/toggle`, {
                    method: "POST",
                    headers: {
                        ...authStore.getAuthHeaders(),
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        uid: uid.value,
                        mark_type: newMarkType,
                        click: 2// newClickValue が未定義だったため、固定値 2 を使用
                    })
                });

                if (!response.ok) {
                    console.error(`❌ サーバーエラー: ${response.status} ${response.statusText}`);
                    return;
                }

                const data = await response.json();
                    console.log("📥 APIレスポンス:", data);

                    // `message.likes` を更新
                    message.likes = message.likes.map((like) =>
                    like.uid === uid.value ? { ...like, mark_type: data.mark_type || newMarkType, click: 2 } : like
                    );

                    // `selectedMark` も更新
                    selectedMark.value = { ...selectedMark.value, [message.id]: data.mark_type || newMarkType };

                    console.log("✅ 更新後の selectedMark:", JSON.stringify(selectedMark.value));
                } catch (error) {
                    console.error("❌ APIリクエストエラー:", error);
                }
            };


        // WebSocket 設定
onMounted(async () => {
    console.log("🚀 初期データの取得開始");

    try {
        const response = await fetch(`http://localhost:3000/messages`, {
            method: "GET",
            headers: authStore.getAuthHeaders()
        });
        const data = await response.json();
        console.log("📥 初期データ取得:", data);

        if (Array.isArray(data.messages)) {
            localMessages.value = data.messages;  // ローカルの state に格納
            initSelectedMark();
        }
    } catch (error) {
        console.error("❌ 初期データ取得失敗:", error);
    }

    // WebSocket 設定
    cable.value = createConsumer().subscriptions.create("LikesChannel", {
        received: (data) => {
            console.log("📩 WebSocket からデータ受信:", data);
            const message = localMessages.value.find(m => m.id === data.message_id);
            if (message) {
                message.likes = data.likes || [];
                initSelectedMark();
            }
        }
    });
});

        watch(() => props.messages.map(m => m.likes), () => {
            console.log("🔄 likes が更新されたので、マークを再設定します。");
            initSelectedMark();
        }, { deep: true });

        return {
            uid,
            selectedMark,
            handleLike,
            updateMarkType
        };
    }
};

</script>

<style scoped>
/* チャットメッセージのデザイン */
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

select {
    margin-left: 5px;
    padding: 2px;
    border-radius: 5px;
    font-size: 12px;
}
</style>