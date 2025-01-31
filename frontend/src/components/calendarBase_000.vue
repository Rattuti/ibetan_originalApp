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
            >
              {{ event.name }}
            </div>
            <div
              v-for="event in day.dayEvents"
              :key="event.id"
              class="calendar-event"
              :class="{ multiDay: isMultiDayEvent(event) }"
              :style="getEventStyle(event, day.date)"
            >
              {{ event.name }}
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
      articles: [
      {
          "article_id": 4,
          "name": "【締め切り延長】「シングルマザーの幸せ家計術」を開催します【1月17日締切】",
          "url": "https://www.city.suita.osaka.jp/kurashi/1018573/1018587/1018588/mama202401.html",
          "color": "#FF5733",
          start: "2025-02-01",
          end: "2025-02-01",
          "cost": "無料",
          "childcare": "あり（1歳から就学前の幼児10人・多数の場合抽選）\n1歳未満の子供は一緒に連れて参加可"
        },
      ],
      events: [
        { id: 1,
          name: "ミーティング", 
          start: "2025-01-01", 
          end: "2025-01-01", 
          color: "blue" 
        },
        { id: 2, name: "イベント", start: "2025-01-02", end: "2025-01-03", color: "limegreen" }
      ],
    };
  },
  created() {
    this.fetchArticles();
  },
  methods: {
    async fetchArticles() {
      try {
        const response = await axios.get("http://localhost:3000/api/scraping");
        this.articles = response.data.articles.map(article => ({
          ...article,
          event_dates: article.event_dates || "", // 空のevent_datesを考慮
        }));
        this.updateCalendarWithArticles();
      } catch (error) {
        console.error("記事の取得に失敗しました：", error);
      }
    },
    updateCalendarWithArticles() {
      this.articles.forEach(article => {
        article.event_dates.split(",").forEach(date => {
          const eventDate = moment(date.trim(), "YYYY-MM-DD");
          if (eventDate.isValid()) {
            this.calendars.forEach(week => {
              week.forEach(day => {
                if (day.date.isSame(eventDate, "day")) {
                  day.dayEvents.push({
                    id: article.article_id,
                    name: article.title,
                    start: eventDate.format("YYYY-MM-DD"),
                    end: eventDate.format("YYYY-MM-DD"),
                    color: "orange" // 任意の色
                  });
                }
              });
            });
          }
        });
      });
    },
    prevMonth() {
      this.currentDate = moment(this.currentDate).subtract(1, "month");
    },
    nextMonth() {
      this.currentDate = moment(this.currentDate).add(1, "month");
    },
    goToToday() {
      this.currentDate = moment();
    },
    youbi(dayIndex) {
      return ["日", "月", "火", "水", "木", "金", "土"][dayIndex];
    },
    getCalendarBounds() {
      const startDate = moment(this.currentDate).startOf("month").startOf("week");
      const endDate = moment(this.currentDate).endOf("month").endOf("week");
      return { startDate, endDate };
    },
    getCalendar() {
      const { startDate, endDate } = this.getCalendarBounds();
      const days = [];
      const current = startDate.clone();
      while (current.isBefore(endDate)) {
        days.push({
          day: current.date(),
          date: current.clone(),
          month: current.format("YYYY-MM"),
          dayEvents: this.getDayEvents(current),
        });
        current.add(1, "day");
      }
      return Array.from({ length: Math.ceil(days.length / 7) }, (_, i) =>
        days.slice(i * 7, i * 7 + 7)
      );
    },
    getDayEvents(date) {
      return this.events.filter(event => {
        const start = moment(event.start, "YYYY-MM-DD");
        const end = moment(event.end, "YYYY-MM-DD");
        return date.isBetween(start, end, "day", "[]");
      });
    },
    getEventStyle(event, date) {
      return {
        backgroundColor: event.color,
        height: "30px",
        display: "block"
      };
    },
    isMultiDayEvent(event) {
      return moment(event.start).isBefore(moment(event.end));
    },
  },
  computed: {
    calendars() {
      return this.getCalendar();
    },
    displayMonth() {
      return this.currentDate.format("YYYY[年]M[月]");
    },
  },
};
</script>


<style>
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
