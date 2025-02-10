<template>
    <navHeaderBar />
    <div v-if="event && event.id">
        <h1>選択日: {{ event.start }}</h1>
        <h1>イベント詳細</h1>
        <p>イベント名: {{ event.name }}</p>
        <p>URL: <a :href="event.url" target="_blank">{{ event.url }}</a></p>
        <p>費用: {{ event.cost ?? "未設定" }}</p>
        <p>託児: {{ event.childcare ?? "未設定" }}</p>
    </div>
    <contact />
    <navFooterBar />
</template>

<script>
import navHeaderBar from '../components/navHeaderBar';
import contact from '../components/contact';
import navFooterBar from '../components/navFooterBar';
import axios from "axios";


export default {
    components: {
        navHeaderBar,
        contact,
        navFooterBar,
    },
    props: ["id"],
    data() {
        return {
            event: null
        };
    },
    created() {
        console.log("イベント ID:", this.$route.params.id); 
        this.fetchEventDetail(this.$route.params.id);// eventsを取得
    },
    methods: {
        async fetchEventDetail(id) {
            try {
                const response = await axios.get(`http://localhost:3000/api/events/${id}`);
                console.log(response.data);  // レスポンスをログ出力して確認
                this.event = response.data;
            } catch (error) {
                console.error("イベント詳細の取得に失敗しました：", error);
            }
        }
    },
    mounted() {
        console.log("現在のイベントID:", this.$route.params.id);
    },
};
</script>


