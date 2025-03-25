<template>
    <ul>
        <li v-for="message in messages" :key="message.id" :class="{
            received: message.email !== uid,
            sent: message.email === uid
        }">
            <div class="message-container">
                <img
                    :src="avatarUrls[message.user_id] || 'http://localhost:3000/uploads/avatars/default_avatar.jpg'"
                    alt="Avatar"
                    class="avatar"
                    @error="handleImageError"
                />
                <div class="message-content">
                    <span class="name">{{ userNames[message.user_id] || "不明" }}</span>
                    <div class="message" 
                        @dblclick="handleLike(message)" 
                        :aria-label="`メッセージ内容：${message.content}`"
                    >
                        {{ message.content }}
                        
                        <select
                            v-if="message.likes && Array.isArray(message.likes) && message.likes.some(like => like.uid === uid && like.click === 1)"
                            v-model="selectedMark[message.id]" 
                            @change="updateMarkType(message)">
                            <option value="heart">❤️</option>
                            <option value="star">⭐</option>
                            <option value="thumbs-up">👍</option>
                        </select>

                        <span
                            v-if="selectedMark[message.id] && message.likes.find(like => like.uid === uid)?.click === 2">
                            <span v-if="selectedMark[message.id] === 'heart'">❤️</span>
                            <span v-if="selectedMark[message.id] === 'star'">⭐</span>
                            <span v-if="selectedMark[message.id] === 'thumbs-up'">👍</span>
                        </span>
                    </div>
                    <span class="created-at">{{ message.created_at }}前</span>
                </div>
            </div>
        </li>
    </ul>
</template>

<script>
import { ref, computed, watch, onMounted,toRaw} from "vue";
import { useAuthStore } from "@/stores/auth";
import { createConsumer } from "@rails/actioncable";

export default {
    props: {
        users: Array,
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

        const usersLoaded = ref(false);
        const error = ref(null);// エラーメッセージの管理

        // ユーザー情報をcomputedでリアクティブに取得
        const user = computed(() => authStore.user);

        console.log("authStore.users:", JSON.stringify(authStore.users, null, 2));

        const users = computed(() => props.users); 
        console.log("渡されたユーザー情報:", users.value);


        // **ユーザー情報をオブジェクト化**
        const userInfoMap = computed(() => {
            if (!authStore.users) return {};
            return authStore.users.reduce((acc, user) => {
                acc[user.id] = {
                nickname: user.nickname || user.name,
                avatar: user.avatar || "http://localhost:3000/uploads/avatars/default_avatar.jpg",
                };
                return acc;
            }, {});
        });

        const avatarUrls = computed(() => {
            if (!userInfoMap.value) return {}; // userInfoMapがundefinedの場合のガード

            return props.messages.reduce((acc, message) => {
                // userInfoMapのユーザー情報がない場合のデフォルト値
                const avatarPath = userInfoMap.value[message.user_id]?.avatar || "/uploads/avatars/default_avatar.jpg";

                // フルURLを組み立てる
                const avatar = `http://localhost:3000${avatarPath}`;

                acc[message.user_id] = avatar;
                return acc;
            }, {});
        });


        const userNames = computed(() => {
            return props.messages.reduce((acc, message) => {
                acc[message.user_id] = userInfoMap.value[message.user_id]?.nickname || "不明";
                console.log("userInfoMap:", userInfoMap.value);
                return acc;
            }, {});
        });

        // 送信者の情報を非同期で取得する関数
        const getUserById = async (userId) => {
            console.log("authStore.users:", JSON.stringify(authStore.users, null, 2));  // ここでユーザー情報が正しくセットされているか確認
            
            // ユーザー情報がまだ取得されていない場合、fetchUsersを呼び出して情報を取得
            if (!authStore.users || authStore.users.length === 0) {
                console.warn("authStore.users が空です。ユーザー情報を取得します...");
                await authStore.fetchUsers(); // ユーザー情報を非同期で取得
            }

            // ユーザー情報を取得
            const user = authStore.users.find(user => user.id === userId);
            if (!user) {
                console.warn(`ユーザーID ${userId} に該当するユーザーが見つかりません`);
            } else {
                console.log(`ユーザー取得成功:`, user);
            }
            return user || null; // 見つからなければ null を返す
        };

        // アバター画像の読み込みエラー処理
        const handleImageError = (event) => {
            console.error('Avatar image failed to load:', event.target.src);
            event.target.src = "http://localhost:3000/uploads/avatars/default_avatar.jpg"; // デフォルトのアバター画像を設定
        };

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
        onMounted(async () => {
            try {
                // ユーザー情報の取得
                console.log("✅ ユーザー情報の取得開始");

                // 非同期でメッセージごとのユーザー情報を取得
                const userPromises = props.messages.map(message => getUserById(message.user_id));
                await Promise.all(userPromises);

                // ユーザー情報の取得
                await authStore.fetchUsers(); // ここでユーザー情報を取得
                console.log("📌 ユーザー情報取得完了:", authStore.users);

                if (!authStore.users || authStore.users.length === 0) {
                    console.error("⚠️ ユーザーが認証されていません");
                    return;
                }

                // `user.value` のデータを更新
                // ユーザー情報取得後に currentUserId を設定する
                const loggedInUser = authStore.users.find(u => u.uid === authStore.currentUserId);
                if (loggedInUser) {
                    user.value = loggedInUser;
                    console.log("🖼️ ユーザーのアバター:", user.value.avatar);
                } else {
                    console.warn("⚠️ ログインユーザーが見つかりません");
                    // 必要であれば currentUserId を設定する処理を追加
                    authStore.currentUserId = loggedInUser.id;
                }

                // **WebSocket接続をここで明示的に初期化**
                if (!cable.value) {
                    cable.value = createConsumer().subscriptions.create("LikesChannel", {
                        received: (data) => {
                            console.log("📩 WebSocket からデータ受信:", data);
                            const message = props.messages.find(m => m.id === data.message_id);
                            
                            if (message) {
                                message.likes = data.likes || [];
                                initSelectedMark(); // 受信後に再設定
                            }
                        }
                    });
                }
            } catch (error) {
                console.error("エラーが発生しました:", error);
            }
        });

        watch(selectedMark, (newVal, oldVal) => {
            console.log("selectedMarkが更新された:", oldVal, "→", newVal);
        });


        return {
            uid,
            user,
            error,
            getUserById,
            userNames,
            avatarUrls,
            selectedMark,
            handleLike,
            updateMarkType,
            usersLoaded,
            handleImageError
        };
    }
};

</script>

<style scoped>
/* チャットメッセージのデザイン */
.chat-bubble {
    background-color: white;
    padding: 30px 20px;
    border-bottom: 1px solid #eee;
}

ul {
    max-height: 350px; /* 必要に応じて調整 */
    overflow-y: auto;
    list-style: none;
    flex-direction: column-reverse; /* 最新の投稿を下に */
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
    margin-left: 10px; /* 左側に少しずらす */
}

.sent {
    float: right;
    margin-right: 10px; /* 右側に少しずらす */
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

.name {
    font-size: 13px;
    font-weight: bold;
}

.created-at {
    color: #999;
    font-size: 12px;
    margin-top: 3px;
}

select {
    margin-left: 5px;
    padding: 2px;
    border-radius: 5px;
    font-size: 12px;
}
.message-container {
    display: flex;
    align-items: center;
}

.avatar {
    width: 40px; /* アバター画像のサイズ */
    height: 40px;
    border-radius: 50%; /* 丸いアイコン */
    margin-right: 10px; /* メッセージとの間隔 */
}

.message-content {
    display: flex;
    flex-direction: column;
}

</style>