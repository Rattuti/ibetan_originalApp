<template>
    <div>
        <h2>新規イベント作成</h2>
        <form @submit.prevent="createEvent">
            <div>
                <label for="title">タイトル</label>
                <input type="text" v-model="newEvent.title" required />
            </div>
            <div>
                <label for="start_date">日付</label>
                <input type="date" v-model="newEvent.start_date" required />
            </div>
            <div>
                <label for="color">色</label>
                <input type="color" v-model="newEvent.color" required />
            </div>
            <button type="submit">作成</button>
            <button type="button" @click="cancelCreateEvent">キャンセル</button>
        </form>
    </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";

// router インスタンスを取得
const router = useRouter();

// イベント情報のデータ
const newEvent = ref({
    title: "",
    start_date: "",
    color: "#ffffff",
});

// イベント作成の関数
const createEvent = async () => {
    try {
        await axios.post('http://localhost:3000/api/events', {
            title: newEvent.value.title,
            start_date: newEvent.value.start_date,
            end_date: newEvent.value.start_date,
            color: newEvent.value.color,
        });

        alert('イベントが作成されました');
        router.push("/chatRoom");  // 作成後、ChatRoomページに遷移
    } catch (error) {
        console.error("イベント作成エラー:", error);
        alert("イベント作成に失敗しました");
    }
};

// フォームキャンセル
const cancelCreateEvent = () => {
    router.push("/chatRoom");
};
</script>
