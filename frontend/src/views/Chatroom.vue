<template>
    <div class="container">
        <NavHeaderBar />
        <ChatWindow @connectCable = "connectCable" :message="messages" />
        <NewChatForm @connectCable="connectCable" />
        <Calender />
        <NavFooterBar />
    </div>
</template>

<script>
import NavHeaderBar from '../components/NavHeaderBar'
import ChatWindow from '../components/ChatWindow'
import NewChatForm from '../components/NewChatForm'
import Calender from '../components/Calender'
import NavFooterBar from '../components/NavFooterBar'

import axios from 'axios'
import ActionCable from 'actioncable'

export default {
    components: {
        NavHeaderBar,
        ChatWindow,
        NewChatForm,
        Calender,
        NavFooterBar
    },
    data(){
        return{
            messages: [],
        }
    },
    methods: {
        async getMessages () {
            try {
                const res = await axios.get('http://localhost:3000/messages',{
                    headers: {
                        uid: window.localStorage.getItem('uid'),
                        "access-token": window.localStorage.getItem('access-token'),
                        client:window.localStorage.getItem('client')
                    }
                })
                if(!res){
                    new Error('メッセージ一覧を取得できませんでした')
                }
                this.message = res.data
            } catch(err){
                console.log(err)
            }
        },
        connectCable(message){
            this.messageChannel.perform('receive',{
                message: message,
                email: window.localStorage.getItem('uid')
            })
        }
    },
    mounted(){
        const cable = ActionCable.createConsumer('ws://localhost:3000/cable')
        this.messageChannel = cable.subscriptions.create('RoomChannel', {
            connected: () => {
                this.getMessages()
            },
            received: () => {
                this.getMessages()
            }
        })
    },
    beforeUnmount () { 
        this.messageChannel.unsubscribe()
    }
}

</script>

<style scoped>
    .chat-window{
        background: white;
        padding: 30px 20px;
        border-bottom: 1px solid #eee;
    }
</style>