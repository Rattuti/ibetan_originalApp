<template>
  <div class="container">
      <navHeaderBar />
      <ArticleWindow />
      <chatBubble :users="users" @connectCable="connectCable" :messages="formattedMessages" ref="chatBubble" />
      <chatForm @connectCable="connectCable" />
      <CalendarWindow />
      <navFooterBar />
  </div>
</template>


<script>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue'; // nextTick をインポート
import { useAuthStore } from '@/stores/auth'; // Piniaストア
import navHeaderBar from '../components/navHeaderBar';
import ArticleWindow from './ArticleWindow';
import chatBubble from '../components/chatBubble';
import chatForm from '../components/chatForm';
import CalendarWindow from './CalendarWindow';
import navFooterBar from '../components/navFooterBar';
import axios from 'axios';
import ActionCable from 'actioncable';
import { formatDistanceToNow } from 'date-fns';
import { ja } from 'date-fns/locale';

export default {
  components: {
    navHeaderBar,
    ArticleWindow,
    chatBubble,
    chatForm,
    CalendarWindow,
    navFooterBar,
  },
  setup() {
    const authStore = useAuthStore(); // Piniaストアの取得
    const users = ref([]);
    const messages = ref([]);
    const messageChannel = ref(null);
    const errorMessage = ref('');
    const chatBubbleRef = ref(null); // ref を使って参照を取得

    // authStore.fetchUsers() の戻り値を確認
    const fetchUsers = async () => {
      try {
        const res = await authStore.fetchUsers();
        console.log("fetchUsers のレスポンス:", res);  // ここでログを確認

        // res の構造をチェック
        if (res?.users && Array.isArray(res.users)) {
          users.value = res.users;
        } else if (res?.data?.users && Array.isArray(res.data.users)) {
          users.value = res.data.users; // 念のため `res.data.users` もチェック
        } else {
          console.error("❌ 想定外のレスポンス:", res);
          users.value = [];
        }
      } catch (err) {
        console.error("ユーザー情報取得エラー:", err);
        users.value = [];
      }
    };

    // メッセージの整形
    const formattedMessages = computed(() => {
      return messages.value.map(message => ({
        ...message,
        created_at: message.created_at
          ? formatDistanceToNow(new Date(message.created_at), { locale: ja })
          : '不明な時間'
      }));
    });

    // メッセージ取得
    const getMessages = async () => {
      try {
        const headers = authStore.getAuthHeaders(); // Piniaのメソッドを使用
        const res = await axios.get('http://localhost:3000/messages', { 
          headers:{
            'access-token': headers['access-token'],
            'client': headers['client'],
            'uid': headers['uid'],
          } });

        if (!res.data) throw new Error('メッセージ一覧を取得できませんでした');
        messages.value = res.data;
      } catch (err) {
        errorMessage.value = 'メッセージ一覧を取得できませんでした';
      }
    };

    // WebSocketのセットアップ
  const setupWebSocket = () => {
    console.log("📡 WebSocket をセットアップ中...");

    // Pinia ストアから認証ヘッダーを取得
    const headers = authStore.getAuthHeaders();
    
    console.log("取得したヘッダー情報:", headers);
    
    const accessToken = headers["access-token"];
    const client = headers["client"];
    const uid = headers["uid"];

    if (!accessToken || !uid || !client) {
      console.error("❌ WebSocket 接続に失敗: 認証情報が不足しています");
      return;
    }

    // 認証情報を URL に付与
    const wsUrl = `ws://localhost:3000/cable?access-token=${encodeURIComponent(accessToken)}&client=${encodeURIComponent(client)}&uid=${encodeURIComponent(uid)}`;
    console.log("🌐 接続先 WebSocket URL:", wsUrl);

    // WebSocket 接続
    const cable = ActionCable.createConsumer(wsUrl);

    messageChannel.value = cable.subscriptions.create(
      { channel: "RoomChannel" }, 
      {
        connected: () => {
          console.log("✅ WebSocket に接続しました");
          getMessages();
        },
        disconnected: () => {
          console.log("⚠️ WebSocket から切断されました");
        },
        received: (data) => {
          console.log("📩 Railsからメッセージを受信:", data);
          if (data && data.content) {
            messages.value.push(data);
            // .push()メソッドで配列の末尾に新しい要素を追加
            nextTick(() => chatBubbleRef.value?.scrollToBottom());
          }
        }
      }
    );
  };
    // メッセージ送信
    const connectCable = (message) => {
      if (!messageChannel.value) {
        console.error("❌ WebSocket チャンネルが未接続です。再接続を試みます...");
        setupWebSocket();
        if (!messageChannel.value) {
          console.error("⚠️ WebSocket 再接続に失敗しました");
          return;
        }
      }    
      console.log("📨 vueからメッセージ送信中:", message);
      messageChannel.value.perform("receive", { message });
    };

    // 初回マウント時にWebSocket接続
    onMounted(() => {
      setupWebSocket();
      fetchUsers(); 
    });

    // コンポーネント破棄時にWebSocketを解除
    onBeforeUnmount(() => {
      if (messageChannel.value) {
        messageChannel.value.unsubscribe();
        console.log("✅ WebSocket チャンネルを解除しました");
      }
    });

    return {
      users,
      formattedMessages,
      connectCable,
      chatBubbleRef,
    };
  }
};
</script>
<style>

.container {
  background-color: white;
}
</style>
