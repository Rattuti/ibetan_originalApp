import consumer from "./consumer";

consumer.subscriptions.create("ScrapingChannel", {
  connected() {
    console.log("Connected to ScrapingChannel");
  },

  disconnected() {
    console.log("Disconnected from ScrapingChannel");
  },

  received(data) {
    console.log("Received data:", data);
    // 必要に応じてUIの更新処理を追加
  },
});
