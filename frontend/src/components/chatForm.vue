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
    emits: ['connectCable'], // 親コンポーネントにメッセージ送信イベントを通知
    data() {
        return {
            message: ''// 入力メッセージのデータバインディング
        };
    },
    methods: {
        // 入力した値をconnectCable介して送信、Rails側の対応のチャンネル先で保存する
        async handleSubmit() {
            if (!this.message.trim()) {// 空メッセージの送信を防止
                console.warn('空のメッセージは送信できません');
                return;
            }
            try {
                // message の text のみ送信
                this.$emit('connectCable',this.message.trim());  // 親コンポーネントへ送信イベントを発火
                this.message = ''; // 入力フォームをリセット
            } catch (error) {
                console.error('メッセージ送信に失敗しました：', error);
            }
        },
        // Shift + Enter で改行を挿入するメソッド
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
    width: 100%;  /* width: 150% を修正 */
    max-width: 1200px; /* 最大幅を制限 */
    margin-bottom: 6px;
    padding: 10px;
    box-sizing: border-box; /* box-sizing を修正 */
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
