<template>
    <div>
    <h2>イベント詳細</h2>
    <div v-if="event">
        <p><strong>タイトル:</strong>{{ event.name }}<input v-model="event.name" /></p>
        <p><strong>日付:</strong> {{ event.start }}<input v-model="event.start" type="datetime-local" /></p>
        <p><strong>URL:</strong> <a :href="event.url" target="_blank">{{ event.url }}</a></p>
        <p><strong>色:</strong>{{ event.color }}<input v-model="event.color" type="color" /></p>

        <button @click="deleteEvent" v-if="event.isEditable">削除</button>
        <button @click="updateEvent" v-if="event.isEditable">更新</button>
    </div>

    <button @click="goBack">戻る</button>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "axios";

const route = useRoute();
const router = useRouter();
const event = ref(null);

// API からデータ取得
const fetchEventDetail = async () => {
    const eventId = route.params.id;
    const isEditable = eventId.startsWith("evt_");
    const id = eventId.replace("evt_", "").replace("scr_", "");

    try {
        const response = await axios.get(`http://localhost:3000/api/${isEditable ? "events" : "scraping"}/${id}`);
        event.value = { ...response.data, isEditable };
    } catch (error) {
        console.error("詳細データ取得エラー:", error);
    }
};

// 削除
const deleteEvent = async () => {
    // 編集可能かどうかを確認
    if (!event.value?.isEditable) {
        return alert("スクレイピング情報は削除できません！");
    }

    // event.value.id を文字列に変換
    const eventId = String(event.value.id);  // 文字列に変換

    // IDの形式を確認
    if (eventId.startsWith("evt_")) {
        const idWithoutPrefix = eventId.replace("evt_", "");
        try {
            await axios.delete(`http://localhost:3000/api/events/${idWithoutPrefix}`);
            alert("削除しました");
            router.push("/ChatRoom");
        } catch (error) {
            console.error("削除エラー:", error);
            alert("削除に失敗しました");
        }
    } else if (eventId.startsWith("event_")) {
        const idWithoutPrefix = eventId.replace("event_", "");
        try {
            await axios.delete(`http://localhost:3000/api/events/${idWithoutPrefix}`);
            alert("削除しました");
            router.push("/ChatRoom");
        } catch (error) {
            console.error("削除エラー:", error);
            alert("削除に失敗しました");
        }
    } else if (/^\d+$/.test(eventId)) {  // 数字だけの場合
        try {
            await axios.delete(`http://localhost:3000/api/events/${eventId}`);
            alert("削除しました");
            router.push("/ChatRoom");
        } catch (error) {
            console.error("削除エラー:", error);
            alert("削除に失敗しました");
        }
    } else {
        console.error("IDが正しい形式ではありません");
        alert("IDの形式が正しくありません");
    }
};

// 編集
const updateEvent = async() => {
    try {
        // event.value.idが"evt_15"のような形式であれば、"evt_"を削除
        const eventId = String(event.value.id).replace("evt_", "");

        await axios.put(`http://localhost:3000/api/events/${eventId}`, {
            title: event.value.name,
            start_date: event.value.start,
            end_date: event.value.start,
            color: event.value.color,
        });

        alert("更新されました");
        router.push("/ChatRoom"); // 更新後にカレンダーページへ遷移
    } catch (error) {
        console.error("更新エラー:", error);
        alert("更新に失敗しました");
    }
};

// 戻るボタン
const goBack = () => {
    router.push("/ChatRoom");
};

onMounted(fetchEventDetail);
</script>
