<template>
    <div class="container">
        <navHeaderBar />
        <ArticleWindow />
        <chatBubble @connectCable="connectCable" :messages="formattedMessages" ref="chatBubble" />
        <chatForm @connectCable="connectCable" />
        <CalendarWindow />
        <navFooterBar />
    </div>
</template>

<script>
//export default外はJavascriptの領地
//JavaScriptで定義した関数などはvueでも使えてしまう
import navHeaderBar from '../components/navHeaderBar';
import ArticleWindow from './ArticleWindow';
import chatBubble from '../components/chatBubble';
import chatForm from '../components/chatForm';
import CalendarWindow from './CalendarWindow';
import navFooterBar from '../components/navFooterBar';


// 外部ライブラリのインポート
import axios from 'axios';
import ActionCable from 'actioncable';
import { formatDistanceToNow } from 'date-fns';
import { ja } from 'date-fns/locale';
//import { nextTick } from 'vue'; 

export default {
//export default内はVueの領地
    components: { 
        navHeaderBar,
        ArticleWindow,
        chatBubble,
        chatForm,
        CalendarWindow,
        navFooterBar,
    },
    data () {
        return {
            messages: [],
            errorMessage:'',//エラーメッセージ保持
        };
    },
    computed: {
    //算出プロパティ
    //値が変わると自動で計算し、結果を1つだけ持つ
    //呼び出すたびに計算せず、計算済の結果を返す
        formattedMessages(){
            if(!this.messages.length){ return [] }
            //this.は、vueの領域だけで決めた変数や処理を、vueの領域で呼び出すために使う
            //this.をつけてmessagesを指定しvue内で呼び出している
            //※JavaScriptとの区別のため
            return this.messages.map(message => {
                let time = formatDistanceToNow(new Date(message.created_at),{ locale: ja } )
                return { ...message, created_at: time }
            });
        },
    },
    methods: {
    async getMessages () {
      try {
        const res = await axios.get('http://localhost:3000/messages', {
          headers: {
            uid: window.localStorage.getItem('uid'),
            "access-token": window.localStorage.getItem('access-token'),
            client:window.localStorage.getItem('client')
          }
        })
        if (!res) {
          new Error('メッセージ一覧を取得できませんでした')
        }
        this.messages = res.data
      } catch (err) {
        this.error = 'メッセージ一覧を取得できませんでした'
      }
    },
    connectCable (message) {
      this.messageChannel.perform('receive', {
        message: message,
        email: window.localStorage.getItem('uid')
      })
    }
  },
  mounted () {
    const cable = ActionCable.createConsumer('ws://localhost:3000/cable')
    this.messageChannel = cable.subscriptions.create('RoomChannel', {
      connected: () => {
        this.getMessages().then(() => {
          this.$refs.chatBubble.scrollToBottom()
        })
      },
      received: () => {
        this.getMessages().then(() => {
          this.$refs.chatBubble.scrollToBottom()
        })
      }
    })
  },
    beforeUnmount () {
        this.messageChannel.unsubscribe()
    }
};
</script>

<style scoped>
</style>