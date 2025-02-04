<template>
    <form>
        <textarea
            v-model="message"
            @keydown.enter.prevent="handleSubmit"
            placeholder="メッセージを入れたらEnterで送信"
            aria-label="メッセージ入力欄"
        ></textarea>
    </form>
</template>

<script>
export default {
    emits: ['connectCable'],
    data () {
        return {
            message: ''//ユーザが入力したメッセージ
        };
    },
    methods: {
        async handleSubmit () {
            if(!this.message.trim()){
                console.warn('空のメッセージは送信できません');
                return;
            }
            try{
                this.$emit('connectCable',
                this.message.trim());//親に送信
                this.message = ''; // 入力フォームをリセット
            }catch(error){
                console.error('メッセージ送信に失敗しました：',error);
            }
        }
    }
};

</script>

<style scoped>
form {
    width: 100%;
    display: flex;
}

textarea {
    flex-grow: 1; /* 幅いっぱいに広げる */
    width: 100%;
    max-width: 100%;
    margin-bottom: 6px;
    padding: 5px;
    box-sizing: border-box;
    border: 0;
    border-radius: 5px;
    font-family: inherit;
    font-size: 16px;
    line-height: 1.4;
    resize: none;
    min-height: 50px;
    outline: none;
    border: 2px solid #677bb4; /* フォーカス時の視認性向上 */
}
</style>
