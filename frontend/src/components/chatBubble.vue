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

                        <!-- ユーザーが1回クリックした場合にマークを選べるようにする -->
                        <select
                            v-if="message.likes && Array.isArray(message.likes) && message.likes.some(like => like.uid === uid && like.click === 1)"
                            v-model="selectedMark[message.id]" 
                            @change="updateMarkType(message)">
                            <option value="heart">❤️</option>
                            <option value="star">⭐</option>
                            <option value="thumbs-up">👍</option>
                        </select>

                        <!-- ここでマークを表示 -->
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
import { ref, computed, watch, onMounted,toRaw} from "vue";
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
        const selectedMark = ref({}); // selectedMark を ref に変更

        // メッセージごとのマークを初期化
        const initSelectedMark = () => {
            if (!props.messages || props.messages.length === 0) {
                console.warn("No messages available");
                return;
            }

            console.log("🔍 マークの初期化");
            props.messages.forEach(message => {
    if (!message) {
        console.error("❌ message が undefined です:", message);
        return;
    }

    console.log(`📌 メッセージID: ${message.id}, いいね情報:`, toRaw(message.likes));

    const likes = message.likes || [];  // likes が undefined なら空の配列に
    const like = likes.find(like => like.uid === uid.value);

    if (like && (like.click === 1 || like.click === 2)) {
        console.log(`🎯 メッセージ ${message.id} に対する like:`, like);
        selectedMark.value[message.id] = like.mark_type || null;
    } else {
        selectedMark.value[message.id] = null;
    }
});

            console.log("🔍 修正後の selectedMark:", JSON.stringify(selectedMark.value));


            console.log("🔍 修正後の selectedMark:", JSON.stringify(selectedMark.value));
        };

        // いいねを切り替え
        const handleLike = async (message) => {
            console.log("✅ いいねのリクエスト送信: ", message.id);
            if (!authStore) {
                console.error("authStore が未定義です。Pinia のストアが正しくセットアップされているか確認してください。");
                return;
            }
            console.log("✅ authStore:", authStore); // デバッグ用
            const currentUser = authStore;

            if (!currentUser) {
                console.error("❌ currentUser が未定義です。認証情報が正しく取得できているか確認してください。");
                return;
            }

            // 現在のクリック状態を確認
            const currentLike =  (message.likes || []).find(like => like.uid === uid.value);

            // クリック数のトグル（切り替え）
            const newClickValue = currentLike == null
                ? 1 
                : (currentLike.click === 2 ? 0 : currentLike.click + 1);// 最初のクリックなら 1 を設定
            
                console.log(`🔍 現在のクリック値: ${currentLike ? currentLike.click : 'なし'}`);
                console.log(`📌 変更後のクリック値: ${newClickValue}`);


            console.log("📤 送信データ:", JSON.stringify({
                uid: uid.value,
                mark_type: selectedMark.value[message.id] || "heart",
                click: newClickValue // 新しいclick値
            }));


            const response = await fetch(`http://localhost:3000/messages/${message.id}/like/toggle`, {
                method: "POST",
                headers: {
                    ...authStore.getAuthHeaders(),
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    uid: uid.value,
                    mark_type: selectedMark.value[message.id] || "heart",
                    click: newClickValue
                })
            });

            if (!response.ok) {
                console.error("いいねの切り替えに失敗:", await response.json());
                return;
            }

            const data = await response.json();
            console.log("🧐 サーバーのレスポンス: ", data);

            // 期待通りのレスポンスかどうかチェック
            if (!data || typeof data.click !== "number") {
                console.error("❌ 無効なレスポンス:", data);
                return;
            }

            // **selectedMark を更新**
            const updatedLike = message.likes && Array.isArray(message.likes)
                ? message.likes.find(like => like.uid === uid.value)
                : null;
            console.log("🔍 更新対象の like:", updatedLike);
            
            if (updatedLike) {
                console.log("✅ 更新対象の like が見つかった:", updatedLike);
                updatedLike.mark_type = data.mark_type;
                updatedLike.click = newClickValue; // ✅ API のレスポンス通りに更新
                selectedMark.value[message.id] = newClickValue === 1 ? data.mark_type : null;           
            } else {
                // 初めての like なら新しく追加
                console.warn("⚠️ 更新対象の like が見つからない。新規に追加します");

                    if (!message.likes) {
                        message.likes = [];
                    }
                // 新しい like を作成
                const newLike = {
                    uid: uid.value,
                    mark_type: selectedMark.value[message.id] || "heart",
                    click: newClickValue
                };
                message.likes.push(newLike); // likes 配列に追加
                //selectedMark.value[message.id] = data.click === 1 ? data.mark_type : null;
            }
            console.log("🔍 更新後の selectedMark:", JSON.stringify(selectedMark.value));
            console.log("🔍 更新後の message.likes:", JSON.stringify(message.likes));
        };

        // マークタイプを更新
        const updateMarkType = async (message) => {
            console.log("🚀 マークタイプを更新:", selectedMark.value[message.id]);

            const like = message.likes?.find(like => like.uid === uid.value);
            if (!like) return;

            const response = await fetch(`http://localhost:3000/messages/${message.id}/like/toggle`, {
                method: "POST",
                headers: {
                    ...authStore.getAuthHeaders(),
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    uid: uid.value,
                    mark_type: selectedMark.value[message.id],
                    click: 2  // ✅ ここで確定させる
                })
            });

            if (!response.ok) {
                console.error("マークの変更に失敗:", await response.json());
                return;
            }

            const data = await response.json();
            like.mark_type = data.mark_type;
            like.click = 2;

            selectedMark.value[message.id] = data.mark_type;

            console.log("🔍 更新後の selectedMark:", JSON.stringify(selectedMark.value));
            console.log("🔍 更新後の message.likes:", JSON.stringify(message.likes));
        };

        // WebSocket 設定
        onMounted(() => {
            if (!cable.value) {
                console.error("WebSocket接続が正しく初期化されていません");
                return;
            }
            cable.value = createConsumer().subscriptions.create("LikesChannel", {
                received: (data) => {
                    console.log("📩 WebSocket からデータ受信:", data);
                    const message = props.messages.find(m => m.id === data.message_id);
                    if (message) {
                        message.likes = data.likes || [];
                        initSelectedMark(); // WebSocket更新後にマークを再設定
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