<template>
    <div class="button-area">
        <button class="calendar-btn" @click="prevMonth">前の月</button>
        <button class="calendar-btn" @click="goToToday">今月</button>
        <button class="calendar-btn" @click="nextMonth">次の月</button>
        <span class="calendar-name">{{ currentDate.format("YYYY年MM月") }}のカレンダー</span>
    </div>

    <div class="content">
        <div class="calendar">
            <div class="calendar-weekly">
                <div class="calendar-youbi" v-for="n in 7" 
                :key="n" 
                :class="{
                    sunday: n === 1,
                    saturday: n === 7
                }">
                {{ youbi(n - 1) }}
                </div>
            </div>
            <div class="calendar-weekly" 
                v-for="(week, weekIndex) in calendars" 
                :key="weekIndex"
            >
                <div class="calendar-daily" :class="{
                    outside: !isCurrentMonth(day.date),
                    weekend: isWeekend(day.date), 
                    sunday: day.date.day() === 0,
                    saturday: day.date.day() === 6,
                    today: isToday(day.date)
                    }"
                    v-for="day in week" 
                    :key="day.date" 
                    @click="createNewEvent(day.date)"
                >
                    <div class="calendar-day">
                        {{ day.day }}
                    </div>

                    <div class="calendar-events">
                        <div v-for="event in day.dayEvents" 
                            :key="event.id" 
                            @click.stop="goToDetail(event)"
                        >
                        <div :style="{ backgroundColor: event.color }">
                            {{ event.name }}
                        </div>
                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useAuthStore } from "@/stores/auth";
import { useRouter } from "vue-router";
import axios from "axios";
import moment from "moment";

const router = useRouter();
const events = ref([]);
const currentDate = ref(moment());

const isToday = (date) => {
    return date.isSame(moment(), "day");
};



const authStore = useAuthStore();
const headers = authStore.getAuthHeaders();

// API からデータ取得
const fetchEvents = async () => {
    try {
        const [scrapingData, eventData] = await Promise.all([
            axios.get("http://localhost:3000/api/scraping",{headers}),
            axios.get("http://localhost:3000/api/events",{headers})
        ]);

        events.value = [
            ...formatEvents(scrapingData.data.articles, false),
            ...formatEvents(eventData.data.events ?? eventData.data, true)
        ];
    } catch (error) {
        console.error("データ取得エラー:", error);
    }
};

// データ整形
const formatEvents = (data, isEditable) =>
    (data ?? []).map(item => ({
        id: `${isEditable ? "evt" : "scr"}_${item.id}`,
        name: item.name ?? item.title,
        url: item.url ?? "",
        start: item.start_time ?? item.start,
        end: item.end_time ?? item.end,
        color: item.color ?? "#ccc",
        isEditable
    }));

// カレンダーの範囲取得
const getCalendarBounds = () => {
    const startDate = moment(currentDate.value).startOf("month").startOf("week");
    //const endDate = moment(currentDate.value).endOf("month").endOf("week");
    return { startDate};
};

// カレンダー作成
const getCalendar = () => {
    const { startDate} = getCalendarBounds();
    const days = [];
    const current = startDate.clone();

    while (days.length < 35) { // 35日分確保
        days.push({
            day: current.date(),
            date: current.clone(),
            dayEvents: getDayEvents(current)
        });
        current.add(1, "day");
    }

    return Array.from({ length: 5 }, (_, i) => days.slice(i * 7, i * 7 + 7)); // 5週間固定
};


// 今月かどうかを判定
const isCurrentMonth = (date) => {
    return date.month() === currentDate.value.month();
};

// 日付に紐づくイベント取得
const getDayEvents = (date) => {
    return events.value.filter(event => {
        const eventStart = moment(event.start, "YYYY-MM-DD");
        const eventEnd = moment(event.end, "YYYY-MM-DD");
        return date.isBetween(eventStart, eventEnd, "day", "[]");
    });
};

// 空白部分クリックで新規イベント作成ページに遷移
const createNewEvent = (date) => {
    router.push({ name: "eventCreate", query: { date: date.format("YYYY-MM-DD") } });
};

// 詳細ページへ移動
const goToDetail = (event) => {
    router.push({ name: "eventDetail", params: { id: event.id } });
};

// カレンダー制御
const prevMonth = () => (currentDate.value = moment(currentDate.value).subtract(1, "month"));
const nextMonth = () => (currentDate.value = moment(currentDate.value).add(1, "month"));
const goToToday = () => (currentDate.value = moment());

// 曜日名のリスト
function youbi(dayIndex) {
    return ["日", "月", "火", "水", "木", "金", "土"][dayIndex];
}

const calendars = computed(() => getCalendar());

// 土日かどうかを判定
const isWeekend = (date) => {
    const dayOfWeek = date.day(); // 日曜日は0、土曜日は6
    return dayOfWeek === 0 || dayOfWeek === 6;
};


onMounted(fetchEvents);
</script>

<style scoped>
.button-area {
  margin-bottom: 0.5em;
  /* ボタン下の余白を最小化 */
  display: flex;
  /* 横並びに配置 */
  align-items: center;
  /* ボタンと名前を縦方向に中央揃え */
  justify-content: space-between;
  /* 両端のボタンと中央の名前を適切に配置 */
}
.button-area button {
  margin: 0 10px;
  /* ボタン間の間隔を調整 */
  font-size: 0.9em;
  /* ボタン文字サイズを調整 */
}
.calendar-btn {
  padding: 4px 8px;
  /* 小さめのパディング */
  font-size: 12px;
  /* 文字サイズを小さく */
  width: auto;
  min-width: unset;
  /* 最小幅を指定 */
  height: 30px;
  /* 高さを小さく */
}
.button-area .calendar-name {
  text-align: center;
  /* 名前を中央揃え */
  font-weight: bold;
  /* 見た目を少し目立たせる */
  flex-grow: 1;
  /* 名前部分を伸ばして中央に配置 */
}

/* カレンダー全体 */
.calendar {
    margin-top: 5px;
  /* カレンダーの上部余白を削減 */
    max-width: 900px;
    border-top: 1px solid #e0e0e0;
    font-size: 0.8em;
    margin-bottom: 0;
  /* 表下の隙間をなくす */
}
.content {
  margin: 1em auto;
  width: auto;
  display: flex;
  /* ボタンとカレンダーを横並びに */
  flex-direction: column;
  /* ボタンをカレンダーの上に配置 */
}

/* 各曜日を表示する部分 */
.calendar-weekly {
    display: flex;
    border-left: 1px solid #e0e0e0;
    position: relative;
}

/* 曜日名 */
.calendar-youbi {
    flex: 1;
    text-align: center;
    padding: 5px 0;
    background-color: #f9f9f9;
    border-right: 1px solid gainsboro;
}

/* 日付ごとの表示 */
.calendar-daily {
    flex: 1;
  min-height: 125px;
  border-right: 1px solid gainsboro;
  border-bottom: 1px solid gainsboro;
  position: relative;
  overflow: hidden;
  height: 100px;
}
.calendar-youbi.sunday {
  color: red;
}

.calendar-youbi.saturday {
  color: blue;
}

.calendar-daily.sunday {
  background-color: #ffe5e5;
}

.calendar-daily.saturday {
  background-color: #e5f3ff;
}

.calendar-day {
  font-weight: bold;
  text-align: center;
  margin-bottom: 5px;
}

.calendar-events {
padding: 1px 3px;
  /* 余白を調整 */
  border-radius: 3px;
  color: white;
  font-size: 0.9em;
  font-weight: bold;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  height: auto;
  /* 高さを15pxに */
  line-height: 15px;
}
.calendar-events > div {
  border: 1px solid white; /* 黒色の枠線 */
  padding: 1px; /* 内側の余白を少し追加 */
  border-radius: 3px; /* 角を少し丸める（オプション） */
}

.calendar-daily.outside {
    background-color: #e0e0e0; /* 灰色 */
    color: #a0a0a0; /* 文字色を薄く */
}

.calendar-daily.today {
  background-color: #ffeb99 !important; /* 明るい黄色 */
  border: 2px solid #ff9900; /* オレンジの枠線で強調 */
}
</style>