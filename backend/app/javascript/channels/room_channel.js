import consumer from "../consumer"; // consumerはActionCableのエントリポイント

// RoomChannelを作成
const roomChannel = consumer.subscriptions.create(
  { channel: "RoomChannel", room_id: "123" }, // room_idはサーバー側と一致させる
  {
    connected() {
      console.log("Connected to RoomChannel");
    },
    disconnected() {
      console.log("Disconnected from RoomChannel");
    },
    received(data) {
      console.log("Received data:", data);
      // 必要に応じて、UIの更新処理などを追加
    },
    sendMessage(message, email) {
      this.perform("receive", { message: message, email: email });
    }
  }
);

// メッセージ送信の例
document.addEventListener("DOMContentLoaded", () => {
  const messageButton = document.getElementById("send-message-button");
  const messageInput = document.getElementById("message-input");

  if (messageButton && messageInput) {
    messageButton.addEventListener("click", () => {
      const message = messageInput.value;
      roomChannel.sendMessage(message, "test@gmail.com");
    });
  }
});
