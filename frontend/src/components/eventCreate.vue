<template>
    <div>
        <h1>イベント作成</h1>
        <form @submit.prevent="createEvent">
            <label>日付:</label>
            <input type="date" v-model="event.startDate" required />

            <label>イベント名:</label>
            <input type="text" v-model="event.name" required />

            <button type="submit">登録</button>

            <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
            
            <button v-if="isDeletable" @click="deleteEvent">削除</button>
        </form>
    </div>
</template>

<script>
import axios from "axios";
import moment from "moment";

export default {
    data() {
        return {
            event: {
                id: null,
                startDate: moment().format("YYYY-MM-DD"),
                name: "",
                color: "limegreen",
            },
            errorMessage: ""
        };
    },
    created() {
        // URL パラメータの id が存在する場合のみ詳細を取得
        const eventId = this.$route.params.id;
        if (eventId) {
            this.fetchEventDetail(eventId);
        }
    },
    methods: {
        async fetchEventDetail(eventId) {
            try {
                const response = await axios.get(`http://localhost:3000/api/events/${eventId}`);
                this.event = response.data;
            } catch (error) {
                console.error("イベント詳細の取得に失敗しました:", error);
                this.errorMessage = "イベント詳細の取得に失敗しました。";
            }
        },
        async createEvent() {
            try {
                const newEvent = {
                    article_id: null,
                    title: this.event.name,
                    start_date: this.event.startDate,
                    end_date: this.event.startDate,
                    color: this.event.color
                };

                // 新規作成の場合には POST リクエストを送信
                const response = await axios.post("http://localhost:3000/api/events", { event: newEvent });
                this.event.id = response.data.id;

                // カレンダー画面へリダイレクト
                this.$router.push("/ChatRoom");
            } catch (error) {
                console.error("イベントの保存に失敗しました:", error);
                this.errorMessage = "イベントの保存に失敗しました。";
            }
        }
    },
    computed: {
    isDeletable() {
        return this.event.id !== null;
    }
}
};
</script>

<style scoped>
.error {
    color: red;
    margin-top: 10px;
}
</style>
