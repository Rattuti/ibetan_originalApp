<template>
    <div>
        これはコンポーネントから表示されています。
        <p>{{ message }}</p>
        <button @click="onClick">親メソッドを実行するボタン</button>
    </div>
</template>

<script>
export default{
    props: ['message'],
    methods: {
        onClick(){
            this.$emit('toggle')
        }
    }
}
</script>