<template>
    <navHeaderBar />
    <div class="p-4 bg-white shadow-md rounded-lg">
        <h2 class="text-lg font-bold text-gray-700">新規イベント作成</h2>
        
        <form @submit.prevent="createEvent" class="space-y-4">
            <div>
                <label for="color" class="block text-sm font-medium text-gray-600">色</label>
                <input type="color" v-model="newEvent.color" required class="w-full" />
                <label for="title" class="block text-sm font-medium text-gray-600">タイトル</label>
                <input type="text" v-model="newEvent.title" required class="w-full border px-2 py-1 rounded" />
            </div>

            <div>
                <label for="start_date" class="block text-sm font-medium text-gray-600">日付</label>
                <input type="date" v-model="newEvent.start_date" required class="w-full border px-2 py-1 rounded" />
            </div>

            <div>
                <label for="content" class="block text-sm font-medium text-gray-600">メモ</label>
                <textarea v-model="newEvent.content" class="w-full border px-2 py-1 rounded" rows="3"></textarea>
            </div>

            <div class="flex space-x-2">
                <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">作成</button>
                <button type="button" @click="cancelCreateEvent" class="px-4 py-2 bg-gray-300 text-gray-700 rounded hover:bg-gray-400">キャンセル</button>
            </div>
        </form>
    </div>

    <navFooterBar />
</template>

<script setup>
import navHeaderBar from '../components/navHeaderBar';
import navFooterBar from '../components/navFooterBar';

import { ref } from "vue";
import { useAuthStore } from "@/stores/auth";
import { useRouter } from "vue-router";
import axios from "axios";

// router インスタンスを取得
const router = useRouter();

// イベント情報のデータ
const newEvent = ref({
    user_id: null,  // ユーザーIDを適切に設定
    title: "",
    start_date: "",
    color: "#ffffff",
    content: "",
});

// イベント作成の関数
const createEvent = async () => {
    const authStore = useAuthStore(); // Pinia ストアを取得
    const headers = authStore.getAuthHeaders(); // getAuthHeaders を取得
    try {
        await axios.post(
            'http://localhost:3000/api/events', 
            {
                user_id: newEvent.value.user_id,
                title: newEvent.value.title,
                start_date: newEvent.value.start_date,
                end_date: newEvent.value.start_date,
                color: newEvent.value.color,
                content: newEvent.value.content,
                judge: true,           
            },
            { headers }
        );

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
