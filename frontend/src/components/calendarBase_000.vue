<template>
  <div class="content">
    <div class="button-area">
      <button class="calendar-btn" @click="prevMonth">前の月</button>
      <button class="calendar-btn" @click="goToToday">今日</button>
      <button class="calendar-btn" @click="nextMonth">次の月</button>
      <span class="calendar-name">カレンダー{{ displayMonth }}</span>
    </div>
    <div class="calendar">
      <div class="calendar-weekly">
        <div class="calendar-youbi" v-for="n in 7" :key="n" :class="{
          sunday: n === 1,
          saturday: n === 7
        }">
          {{ youbi(n - 1) }}
        </div>
      </div>
      <div class="calendar-weekly" v-for="(week, weekIndex) in calendars" :key="weekIndex">
        <div class="calendar-daily" :class="{
          outside: currentDate.format('YYYY-MM') !== day.month,
          sunday: day.date.day() === 0,
          saturday: day.date.day() === 6
        }" v-for="day in week" :key="day.date" @click="openEventModal(day.date)">
          <div class="calendar-day">
            {{ day.day }}
          </div>
          <div class="calendar-events">
            <div v-for="event in day.dayEvents" :key="event.id" class="calendar-event"
              :class="{ multiDay: isMultiDayEvent(event) }" 
              :style="getEventStyle(event, day.date)"
              @click="() => { 
                console.log('クリックされたイベント:', event);
                console.log('イベントID:', event.id);
                if (!event.id) {
                  console.warn('event.id が undefined です！', event);
                }
                goToEventDetail(event.id); 
              }">
              {{ event.name }}
            </div>

            <div v-for="article in articles" :key="article.article_id" class="calendar-event"
              :class="{ multiDay: isMultiDayEvent(article) }" 
              :style="getEventStyle(article, day.date)"
              @click="goToEventDetail(article.article_id)">
              {{ article.name }}
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
      // 現在の日付と時刻を moment オブジェクトとして格納
      articles: [],
      events: [
        { id: 2, name: "イベント", start: "2025-02-02", end: "2025-02-03", color: "limegreen" },
        { id: 3, name: "会議", start: "2025-02-06", end: "2025-02-06", color: "deepskyblue" },
        { id: 4, name: "有給", start: "2025-02-08", end: "2025-02-08", color: "dimgray" },
        { id: 5, name: "海外旅行", start: "2025-02-08", end: "2025-02-11", color: "navy" },
        { id: 6, name: "誕生日", start: "2025-02-16", end: "2025-02-16", color: "orange" },
        { id: 7, name: "イベント", start: "2025-02-12", end: "2025-02-15", color: "limegreen" },
        { id: 8, name: "出張", start: "2025-02-12", end: "2025-02-13", color: "teal" },
        { id: 9, name: "客先訪問", start: "2025-02-14", end: "2025-02-14", color: "red" },
        { id: 10, name: "パーティ", start: "2025-02-15", end: "2025-02-15", color: "royalblue" },
        { id: 12, name: "ミーティング", start: "2025-02-18", end: "2025-02-19", color: "blue" },
        { id: 13, name: "イベント", start: "2025-02-21", end: "2025-02-21", color: "limegreen" },
        { id: 14, name: "有給", start: "2025-02-20", end: "2025-02-20", color: "dimgray" },
        { id: 15, name: "イベント", start: "2025-02-25", end: "2025-02-28", color: "limegreen" },
        { id: 16, name: "会議", start: "2025-02-21", end: "2025-02-21", color: "deepskyblue" },
        { id: 17, name: "旅行", start: "2025-02-23", end: "2025-02-24", color: "navy" },
        { id: 18, name: "ミーティング", start: "2025-02-28", end: "2025-02-28", color: "blue" },
        { id: 19, name: "会議", start: "2025-02-12", end: "2025-02-12", color: "deepskyblue" },
        { id: 20, name: "誕生日", start: "2025-02-30", end: "2025-02-30", color: "orange" }
      ],
    };
  },
  created() {
    this.fetchArticles();// eventsを取得
  },
  methods: {
    async fetchArticles() {
      try {
        const response = await axios.get(`http://localhost:3000/api/events`);
        this.articles = response.data; // APIから取得したデータをそのままセット
      } catch (error) {
        console.error("イベントの取得に失敗しました：", error);
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

        // `this.calendars` の各週（week）をループ
        this.calendars.forEach(week => {
          // 週の各日（day）をループ
          week.forEach(day => {
            // `day.date` と `eventMoment` が同じ日なら処理を実行
            if (day.date.isSame(eventMoment, "day")) {
              // `day.dayEvents` に同じ ID のイベントがないかチェック
              if (!day.dayEvents.some(event => event.id === article.article_id)) {
                // 記事データ (`article`) と `eventMoment` を基に新しいイベントを作成
                const newEvent = this.createEventObject(article, eventMoment);

                // 作成されたイベントをログに出力
                console.log("Created event object:", newEvent);

                // イベントに `id` が正しく設定されているかチェック
                if (!newEvent.id) {
                  console.warn('新規作成されたイベントに ID がありません！', newEvent);
                }

                // `day.dayEvents` に新しく作成した `newEvent` を追加
                day.dayEvents.push(newEvent);

                // イベントが `dayEvents` に追加されたことをログで確認
                console.log("Event added to dayEvents:", day.dayEvents);
                console.log("Event added:", newEvent);
              }
            }
          });
        }
      )},
    
    )},

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
      console.log("クリックされたイベントID:", eventId);
      if (!eventId) {
        console.error("エラー: eventId が undefined です", eventId);
        return;
      }
      this.$router.push({ name: "eventDetail", params: { id: eventId } });
    },

    openEventModal(dayId) {
      console.log("新規イベントの作成日:", dayId.format("YYYY-MM-DD"));
      this.$router.push({
        name: "eventCreate", // 必ずルート名を使用
        query: { dayId: dayId.format("YYYY-MM-DD") } // 正しい日付を渡す
      });
    },

  // 月移動
  prevMonth() {
    // 現在の日付を1ヶ月前に変更
    this.currentDate
      = moment(this.currentDate).subtract(1, "month");
  },
  nextMonth() {
    // 現在の日付を1ヶ月後に変更
    this.currentDate
      = moment(this.currentDate).add(1, "month");
  },
  goToToday() {
    // 現在の日付を今日に設定
    this.currentDate
      = moment();
  },

  // 曜日名を取得
  youbi(dayIndex) {
    // 曜日のインデックスに対応する日本語の曜日名を返す
    return ["日", "月", "火", "水", "木", "金", "土"][dayIndex];
  },

  // カレンダーの範囲を計算
  getCalendarBounds() {
    // カレンダーの開始日: 当月の最初の日から、その週の開始日にリセット
    const startDate
      = moment(this.currentDate).startOf("month").startOf("week");
    // カレンダーの終了日: 当月の最後の日から、その週の終了日にリセット
    const endDate
      = moment(this.currentDate).endOf("month").endOf("week");
      
    return { startDate, endDate };
  },

  // カレンダーを生成
  getCalendar() {
    const { startDate, endDate } = this.getCalendarBounds();
    const days = [];
    const current = startDate.clone();
    // ループ内で startDate を変更せずに current だけを操作できるよう、
    // clone() で新しい moment インスタンスを作成

    // カレンダーの日付を1日ずつ追加
    while (current.isBefore(endDate)) {
      days.push({
        day: current.date(), // 日付 (1〜31)
        date: current.clone(), // Momentオブジェクトとしての日付
        month: current.format("YYYY-MM"), // "YYYY-MM"形式での月
        dayEvents: this.getDayEvents(current) // 当日のイベントを取得
      });
      current.add(1, "day"); // 次の日に進める
    }

    // 7日ごとに配列を分割し、週ごとのカレンダー配列を作成
    return Array.from({ length: Math.ceil(days.length / 7) }, (_, i) =>
      days.slice(i * 7, i * 7 + 7)
    );
  },

  // 1日のイベントを取得
  getDayEvents(date) {
    return this.events.filter(event => {
      // イベントの開始・終了日をMomentオブジェクトに変換
      const eventStart = moment(event.start, "YYYY-MM-DD");
      const eventEnd = moment(event.end, "YYYY-MM-DD");

      // 指定された日付がイベントの期間内にあるか判定
      return date.isBetween(eventStart, eventEnd, "day", "[]");
    });
  },

  // イベントのスタイルを計算
  getEventStyle(event, date) {
    const eventStart = moment(event.start, "YYYY-MM-DD");
    const eventEnd = moment(event.end, "YYYY-MM-DD");

    return {
      backgroundColor: event.color, // イベントの背景色を設定
      height: "30px", // イベント表示の高さ
      // 指定された日付がイベントの期間内なら表示、それ以外は非表示
      display: date.isBetween(eventStart, eventEnd, "day", "[]") ? "block" : "none"
    };
  },

  // マルチデイイベント判定
  isMultiDayEvent(event) {
    // イベントの開始日が終了日より前なら複数日にわたるイベント
    return moment(event.start).isBefore(moment(event.end));
  }
  },
  computed: {
    // カレンダーのデータを算出
    calendars() {
      return this.getCalendar();
    },
    // 表示用の年月をフォーマット
    displayMonth() {
      return this.currentDate.format("YYYY[年]M[月]");
    }
  }
};
</script>

<style>
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

.content {
  margin: 1em auto;
  width: auto;
  display: flex;
  /* ボタンとカレンダーを横並びに */
  flex-direction: column;
  /* ボタンをカレンダーの上に配置 */
}

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

.button-area .calendar-name {
  text-align: center;
  /* 名前を中央揃え */
  font-weight: bold;
  /* 見た目を少し目立たせる */
  flex-grow: 1;
  /* 名前部分を伸ばして中央に配置 */
}

.prev-month {
  margin-left: 0.5em;
}

.calendar {
  margin-top: 5px;
  /* カレンダーの上部余白を削減 */
  max-width: 900px;
  border-top: 1px solid #e0e0e0;
  font-size: 0.8em;
  margin-bottom: 0;
  /* 表下の隙間をなくす */
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
  padding: 1px 3px;
  /* 余白を調整 */
  border-radius: 3px;
  color: white;
  font-size: 0.7em;
  /* 文字サイズを小さめに */
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  height: 15px;
  /* 高さを15pxに */
  line-height: 15px;
  /* テキストを高さの中央に配置 */
  min-width: 40px;
  /* 幅を狭める */
  max-width: 80px;
  /* 最大幅を調整 */
}</style>
