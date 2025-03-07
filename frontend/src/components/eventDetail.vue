<template>
    <navHeaderBar />
    <div class="max-w-2xl mx-auto p-4">
    <h2 class="text-2xl font-bold mb-4">イベント詳細</h2>

    <div v-if="event" class="shadow-lg rounded-lg p-6 bg-white">
        <!-- 編集可能な場合のみ入力欄を表示 -->
        <div v-if="canEdit">
            <div class="mb-4">
                <label class="block text-gray-700 font-bold">色:</label>
                <input v-model="event.color" type="color" class="w-full h-10 rounded border" />
                
                <label class="block text-gray-700 font-bold">タイトル:</label>
                <input v-model="event.name" class="border rounded p-2 w-full" />
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-bold">日付:</label>
                <input v-model="event.start" type="datetime-local" class="border rounded p-2 w-full" />
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-bold">メモ:</label>
                <input v-model="event.content" class="border rounded p-2 w-full" />
            </div>

            <div class="flex justify-end space-x-2">
                <button @click="deleteEvent" class="bg-red-500 text-white rounded p-2">削除</button>
                <button @click="updateEvent" class="bg-blue-500 text-white rounded p-2">更新</button>
            </div>
        </div>

        <!-- isEditable が false の場合は編集不可 -->
        <div v-else>
            <p><strong>色:</strong> <span class="inline-block w-6 h-6 rounded-full" :style="{ backgroundColor: event.color }"></span></p>
            
            <p class="mt-2"><strong>タイトル:</strong>
                <a v-if="event.url" :href="event.url" target="_blank" class="text-blue-500 underline">{{ event.name }}</a>
                <span v-else>{{ event.name }}</span>
            </p>

            <p class="mt-2"><strong>日付:</strong> {{ event.start }}</p>
            <p class="mt-2"><strong>詳細:</strong> {{ event.content }}</p>
            <p class="mt-2"><strong>費用:</strong> {{ event.cost ?? "-" }}</p>
            <p class="mt-2"><strong>託児:</strong> {{ event.childcare ?? "-" }}</p>
            <button @click="goBack" class="mt-4 bg-gray-500 text-white rounded p-2 w-full">戻る</button>           
            <contact v-if="event !== null" />
        </div>
    </div>

    <button @click="goBack" class="mt-4 bg-gray-500 text-white rounded p-2 w-full">戻る</button>
</div>


    <navFooterBar />
</template>

<script setup>
import navHeaderBar from '../components/navHeaderBar';
import contact from '../components/contact';
import navFooterBar from '../components/navFooterBar';

import { ref, onMounted, computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "axios";

// Vue Router のルート情報を取得
const route = useRoute();
const router = useRouter();

// イベントデータ
const event = ref(null);
// 関連する記事データ
const article = ref(null);
// 編集可能かどうかのフラグ
const isEditable = ref(false);

// 編集可能かどうか判定する computed プロパティ
const canEdit = computed(() => { 
    return event.value?.judge === false && event.value?.article_id === null;
});

// API からデータ取得
const fetchEventDetail = async () => {
    const eventId = route.params.id;
    isEditable.value = eventId.startsWith("evt_"); // "evt_" なら編集可

    const id = eventId.replace("evt_", "").replace("scr_", "");

    try {
        const response = await axios.get(`http://localhost:3000/api/${isEditable.value ? "events" : "scraping"}/${id}`);
        event.value = response.data;
        // 関連する記事情報を取得
        if (event.value.article_id) {
            const articleResponse = await axios.get(`http://localhost:3000/api/scraping/${event.value.article_id}`);
            article.value = articleResponse.data;
        }
    } catch (error) {
        console.error("詳細データ取得エラー:", error);
    }
};

// イベント削除
const deleteEvent = async () => {
    if (!isEditable.value) {
        return alert("スクレイピング情報は削除できません！");
    }

    const eventId = String(event.value.id).replace("evt_", "");

    try {
        await axios.delete(`http://localhost:3000/api/events/${eventId}`);
        alert("削除しました");
        router.push("/ChatRoom");
    } catch (error) {
        console.error("削除エラー:", error);
        alert("削除に失敗しました");
    }
};

// イベント更新
const updateEvent = async () => {
    if (!isEditable.value) {
        return alert("編集できません！");
    }

    try {
        const eventId = String(event.value.id).replace("evt_", "");

        await axios.put(`http://localhost:3000/api/events/${eventId}`, {
            title: event.value.name,
            start_date: event.value.start,
            end_date: event.value.start,
            color: event.value.color,
        });

        alert("更新されました");
        router.push("/ChatRoom");
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


