<template>
  <div class="content">
    <div class="button-area">
      <button @click="prevMonth">前の月</button>
      <button @click="goToToday">今日</button>
      <button @click="nextMonth">次の月</button>
      <span class="calendar-name">カレンダー{{ displayMonth }}</span>
    </div>
    <div class="calendar">
      <div class="calendar-weekly">
        <div
          class="calendar-youbi"
          v-for="n in 7"
          :key="n"
          :class="{
            sunday: n === 1,
            saturday: n === 7
          }"
        >
          {{ youbi(n - 1) }}
        </div>
      </div>
      <div
        class="calendar-weekly"
        v-for="(week, weekIndex) in calendars"
        :key="weekIndex"
      >
        <div
          class="calendar-daily"
          :class="{ 
            outside: currentDate.format('YYYY-MM') !== day.month,
            sunday: day.date.day() === 0,
            saturday: day.date.day() === 6
          }"
          v-for="day in week"
          :key="day.date"
          @click="openEventModal(day.date)"
        >
          <div class="calendar-day">
            {{ day.day }}
          </div>
          <div class="calendar-events">
            <div
              v-for="event in day.dayEvents"
              :key="event.id"
              class="calendar-event"
              :class="{ multiDay: isMultiDayEvent(event) }"
              :style="getEventStyle(event, day.date)"
              @click="goToEventDetail(event.id)"
            >
              {{ event.name }}
            </div>
            <div
              v-for="article in articles"
              :key="article.article_id"
              class="calendar-event"
              :class="{ multiDay: isMultiDayEvent(article) }"
              :style="getEventStyle(article, day.date)"
              @click="goToEventDetail(article.id)"
            >
              {{ article.name }}
            </div>
            <div v-if="showModal" class="modal">
              <div class="modal-content">
                <h3>{{ eventForm.id ? "イベント編集" : "新規イベント" }}</h3>
                <input v-model="eventForm.name" placeholder="イベント名">
                <input type="date" v-model="eventForm.start">
                <input type="date" v-model="eventForm.end">
                <input type="color" v-model="eventForm.color">
                <button @click="saveEvent">保存</button>
                <button @click="showModal = false">キャンセル</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import axios from "axios";

export default {
  data() {
    return {
      currentDate: moment(),
      showMododal: false,
      eventForm: {
        id: null,
        name: "",
        start: "",
        end: "",
        color: "#ffcc00",
      },
      articles: [],
      events: [
        { id: 2, name: "イベント", start: "2025-01-02", end: "2025-01-03", color: "limegreen" },
        { id: 3, name: "会議", start: "2025-01-06", end: "2025-01-06", color: "deepskyblue" },
        { id: 4, name: "有給", start: "2025-01-08", end: "2025-01-08", color: "dimgray" },
        { id: 5, name: "海外旅行", start: "2025-01-08", end: "2025-01-11", color: "navy" },
        { id: 6, name: "誕生日", start: "2025-01-16", end: "2025-01-16", color: "orange" },
        { id: 7, name: "イベント", start: "2025-01-12", end: "2025-01-15", color: "limegreen" },
        { id: 8, name: "出張", start: "2025-01-12", end: "2025-01-13", color: "teal" },
        { id: 9, name: "客先訪問", start: "2025-01-14", end: "2025-01-14", color: "red" },
        { id: 10, name: "パーティ", start: "2025-01-15", end: "2025-01-15", color: "royalblue" },
        { id: 12, name: "ミーティング", start: "2025-01-18", end: "2025-01-19", color: "blue" },
        { id: 13, name: "イベント", start: "2025-01-21", end: "2025-01-21", color: "limegreen" },
        { id: 14, name: "有給", start: "2025-01-20", end: "2025-01-20", color: "dimgray" },
        { id: 15, name: "イベント", start: "2025-01-25", end: "2025-01-28", color: "limegreen" },
        { id: 16, name: "会議", start: "2025-01-21", end: "2025-01-21", color: "deepskyblue" },
        { id: 17, name: "旅行", start: "2025-01-23", end: "2025-01-24", color: "navy" },
        { id: 18, name: "ミーティング", start: "2025-01-28", end: "2025-01-28", color: "blue" },
        { id: 19, name: "会議", start: "2025-01-12", end: "2025-01-12", color: "deepskyblue" },
        { id: 20, name: "誕生日", start: "2025-01-30", end: "2025-01-30", color: "orange" }
      ],
    };
  },
  created() {
    this.fetchArticles();// eventsを取得
  },
  methods: {
    openEventModal(date, event = null) {
    this.showModal = true;
    
    if (event) {
      // 既存イベントの編集
      this.eventForm = { ...event };
    } else {
      // 新規イベントの追加
      this.eventForm = {
        id: null,
        name: "",
        start: date.format("YYYY-MM-DD"),
        end: date.format("YYYY-MM-DD"),
        color: "#ffcc00"
      };
    }
  },
  
  saveEvent() {
    if (this.eventForm.id) {
      // 既存イベントの更新
      const index = this.events.findIndex(e => e.id === this.eventForm.id);
      if (index !== -1) {
        this.events[index] = { ...this.eventForm };
      }
    } else {
      // 新規イベントの追加
      const newId = this.events.length ? Math.max(...this.events.map(e => e.id)) + 1 : 1;
      this.events.push({ ...this.eventForm, id: newId });
    }
      this.showModal = false;
    },
  // APIからイベントを取得
    async fetchArticles() {
      try {
        const response = await axios.get(`http://localhost:3000/api/events`); 
        this.articles = response.data; // APIから取得したデータをそのままセット
      } catch (error) {
        console.error("イベントの取得に失敗しました：", error);
        this.$notify({ type: "error", message: "イベントの取得に失敗しました。" });
      }
    },

    // 記事をカレンダーに追加
    updateCalendarWithArticles() {
      this.articles.forEach(this.addArticleToCalendar);
    },

    // カレンダーの1日分に記事を追加
    addArticleToCalendar(article) {
      console.log("Processing article:", article);

      if (!article.event_dates || article.event_dates.trim() === "") {
        console.warn(`Event dates are empty for article: ${article.article_id}`);
        return; // 処理をスキップ
      }

      article.event_dates.split(",").forEach(date => {
        const eventMoment = moment(date.trim(), "YYYY-MM-DD");
        if (!eventMoment.isValid()) {
          console.warn("Invalid date format:", date);
          return;
        }

        console.log("Adding event for date:", eventMoment.format("YYYY-MM-DD"));

        this.calendars.forEach(week => {
          week.forEach(day => {
            if (day.date.isSame(eventMoment, "day")) {
              if (!day.dayEvents.some(event => event.id === article.article_id)) {
                const newEvent = this.createEventObject(article, eventMoment);
                day.dayEvents.push(newEvent);
                console.log("Event added:", newEvent);
              }
            }
          });
        });
      });
    },

    // イベントオブジェクトを作成
    createEventObject(article, eventMoment) {
      return {
        id: article.article_id,
        name: article.title || `記事ID: ${article.article_id}`,
        start: eventMoment.format("YYYY-MM-DD"),
        end: eventMoment.format("YYYY-MM-DD"),
        color: article.color || "#000000", // デフォルト色を設定
      };
    },

    goToEventDetail(eventId) {
    console.log("クリックされたイベント:", eventId); // 確認
    if (!eventId) {
      console.error("イベントデータが無効です:", eventId);
      return;
    }
    this.$router.push({ name: "eventDetail", params: { id: eventId.toString()  } });
    },

    // 月移動
    prevMonth() {
      this.currentDate = moment(this.currentDate).subtract(1, "month");
    },
    nextMonth() {
      this.currentDate = moment(this.currentDate).add(1, "month");
    },
    goToToday() {
      this.currentDate = moment();
    },

    // 曜日名を取得
    youbi(dayIndex) {
      return ["日", "月", "火", "水", "木", "金", "土"][dayIndex];
    },

    // カレンダーの範囲を計算
    getCalendarBounds() {
      const startDate = moment(this.currentDate).startOf("month").startOf("week");
      const endDate = moment(this.currentDate).endOf("month").endOf("week");
      return { startDate, endDate };
    },

    // カレンダーを生成
    getCalendar() {
      const { startDate, endDate } = this.getCalendarBounds();
      const days = [];
      const current = startDate.clone();

      while (current.isBefore(endDate)) {
        days.push({
          day: current.date(),
          date: current.clone(),
          month: current.format("YYYY-MM"),
          dayEvents: this.getDayEvents(current)
        });
        current.add(1, "day");
      }

      return Array.from({ length: Math.ceil(days.length / 7) }, (_, i) =>
        days.slice(i * 7, i * 7 + 7)
      );
    },

    // 1日のイベントを取得
    getDayEvents(date) {
      return this.events.filter(event => {
        const eventStart = moment(event.start, "YYYY-MM-DD");
        const eventEnd = moment(event.end, "YYYY-MM-DD");
        return date.isBetween(eventStart, eventEnd, "day", "[]");
      });
    },

    // イベントのスタイルを計算
    getEventStyle(event, date) {
      const eventStart = moment(event.start, "YYYY-MM-DD");
      const eventEnd = moment(event.end, "YYYY-MM-DD");

      return {
        backgroundColor: event.color,
        height: "30px",
        display: date.isBetween(eventStart, eventEnd, "day", "[]") ? "block" : "none"
      };
    },

    // マルチデイイベント判定
    isMultiDayEvent(event) {
      return moment(event.start).isBefore(moment(event.end));
    }
  },
  computed: {
    calendars() {
      return this.getCalendar();
    },
    displayMonth() {
      return this.currentDate.format("YYYY[年]M[月]");
    }
  }
};
</script>

<style>
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-content {
  background: white;
  padding: 20px;
  border-radius: 5px;
}

.content {
  margin: 1em auto;
  width: auto;
  display: flex; /* ボタンとカレンダーを横並びに */
  flex-direction: column; /* ボタンをカレンダーの上に配置 */
}
.button-area {
  margin-bottom: 0.5em; /* ボタン下の余白を最小化 */
  display: flex; /* 横並びに配置 */
  align-items: center; /* ボタンと名前を縦方向に中央揃え */
  justify-content: space-between; /* 両端のボタンと中央の名前を適切に配置 */
}
.button-area button {
  margin: 0 10px; /* ボタン間の間隔を調整 */
  font-size: 0.9em; /* ボタン文字サイズを調整 */
}
.button-area .calendar-name {
  text-align: center; /* 名前を中央揃え */
  font-weight: bold; /* 見た目を少し目立たせる */
  flex-grow: 1; /* 名前部分を伸ばして中央に配置 */
}
.prev-month{
  margin-left: 0.5em;
}
.calendar {
  margin-top: 5px; /* カレンダーの上部余白を削減 */
  max-width: 900px;
  border-top: 1px solid #e0e0e0;
  font-size: 0.8em;
  margin-bottom: 0; /* 表下の隙間をなくす */
}
.calendar-weekly {
  display: flex;
  border-left: 1px solid #e0e0e0;
  position: relative;
}
.calendar-daily {
  flex: 1;
  min-height: 125px;
  border-right: 1px solid gainsboro;
  border-bottom: 1px solid gainsboro;
  position: relative;
  overflow: hidden;
  height: 100px;
}
.calendar-youbi {
  flex: 1;
  text-align: center;
  padding: 5px 0;
  background-color: #f9f9f9;
  border-right: 1px solid gainsboro;
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
  padding: 5px;
}
.calendar-event {
  padding: 2px 5px;
  border-radius: 3px;
  color: white;
  font-size: 0.75em;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
