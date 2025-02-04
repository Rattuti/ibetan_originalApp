<template>
    <form @submit.prevent="handleSubmit">
        <textarea
            v-model="message"
            @keydown.enter.exact.prevent="handleSubmit"
            @keydown.shift.enter="insertNewLine"
            placeholder="メッセージを入れたらEnterで送信"
            aria-label="メッセージ入力欄"
        ></textarea>
    </form>
</template>

<script>
export default {
    emits: ['connectCable'],
    data() {
        return {
            message: ''
        };
    },
    methods: {
        async handleSubmit() {
            if (!this.message.trim()) {
                console.warn('空のメッセージは送信できません');
                return;
            }
            try {
                this.$emit('connectCable', { message: this.message.trim() }); // オブジェクトで送信
                this.message = ''; // 入力フォームをリセット
            } catch (error) {
                console.error('メッセージ送信に失敗しました：', error);
            }
        },
        insertNewLine() {
            this.message += '\n';
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
    flex-grow: 1; /* 横幅を最大限広げる */
    width: 150%;  /* 念のため明示 */
    margin-bottom: 6px;
    padding: 10px;
    box-sizing: auto;
    border: 2px solid #677bb4;
    border-radius: 5px;
    font-family: inherit;
    font-size: 16px;
    line-height: 1.4;
    resize: none;
    min-height: 50px;
    outline: none;
}
</style>
