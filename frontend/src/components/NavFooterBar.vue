<template>
    <nav>
        <div>
            <p>footer_testです</p>
            <div class="error">{{ error }}</div>
        </div>
        <button @click="logout">イベント検索</button>
        <button @click="logout">★お気に入り</button>
        <button @click="logout">■しおり</button>
        <button @click="logout">マイページ</button>
    </nav>
</template>

<script>
    /*import axios from 'axios'*/

</script>

<style scoped>
nav {
    padding: 20px;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
nav p {
    margin: 2px auto;
    font-size: 16px;
    color: #444;
}
</style>