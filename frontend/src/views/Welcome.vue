<template>
    <div class="container welcome">
        <topHeaderBar />
        <div class="image-section">
            <img>
            <div class="content-background">
                <div class="content-wrapper">
                    <!-- ロゴとテキスト -->
                    <div class="logo-section">
                        <div class="logo-title">
                            <img src="/images/logo_Top_ibetan.png" alt="Logo" class="logo-image"/>
                            <p class="subtext-title">ibetan</p>
                        </div>
                        <p class="subtext">〜 地域イベント検索アプリ 〜</p>

                    </div>

                    <!-- ログインフォーム -->
                    <div class="form-section">
                        <loginForm @redirectToChatRoom="redirectToChatRoom" />
                    </div>
                </div>
            </div>
        </div>
    
        <!-- 機能リスト -->
        <div class="features-section">
            <h2 class="features-title">このアプリで出来る3つのこと</h2>
            <div class="features-list">

                <div class="feature-item">
                    <h3 class="feature-title">タグ機能</h3>
                    <img src="@/assets/TagCheck.jpg" alt="タグ機能の画像" class="feature-image">
                    <p class="feature-description">
                        タグマークをチェックするとマイページでも確認できるよ。</p>
                </div>

                <div class="feature-item">
                    <h3 class="feature-title">チャット機能</h3>
                    <img src="@/assets/LiveChat.jpg" alt="タグ機能の画像" class="feature-image">
                    <p class="feature-description">
                        リアルタイムにチャットを送って、いいねも付けてね。</p>
                    <br>
                </div>

                <div class="feature-item">
                    <h3 class="feature-title">カレンダー機能</h3>
                    <img src="@/assets/CalendarEvent.jpg" alt="タグ機能の画像" class="feature-image">
                    <p class="feature-description">
                        イベントの開催日は自動で表示されるよ。予定は個別に追加できるので使ってみて。</p>
                </div>
            </div>
        </div>
    <topFooterBar />
    </div>
</template>

<script>
import topHeaderBar from '../components/topHeaderBar.vue';
import loginForm from '../components/loginForm.vue';
import topFooterBar from '../components/topFooterBar.vue';

export default {
    components: {
    topHeaderBar,
    loginForm,
    topFooterBar,
    },
    methods: {
    redirectToChatRoom() {
        this.$router.push({ name: 'ChatRoom' });
    }
    }
};
</script>

<style scoped>
/* 画像とコンテンツの配置 */
.image-section {
    position: relative;
    max-width: 100%;
    height: 45vh;
    display: flex;
    align-items: center;
    justify-content: flex-start; /* 左側に寄せる */
    background-image: url('@/assets/background.jpg');
    background-size: cover;
    background-position: center;
}

.image-section img {
    height: auto;
    object-fit: contain;
}

.content-background{
    position: absolute;
    top: 42%; /* 画像の上半分に重ねる */
    left: 38%;
    transform: translate(-100%, -42%);
    display: flex;
    background-color: rgba(255, 255, 255, 0.927); /* 薄鼠色（#C0C0C0）+ 半透明 */
    border-radius: 10px; /* 角を丸める */
    box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2); /* 立体感 */
}
/* コンテンツのレイアウト */
.content-wrapper {
    flex-direction: column; /* 横並びに変更 */
    justify-content: space-between;
    align-items: center;
    width: 100%;
    max-width: 300px;
    margin: 5 auto;
}

/* ロゴセクション */
.logo-section {
    width: 35%;
    text-align: left;
    padding: 10px 0px 0px 15px;
}

.logo-image {
    max-width: 35%;
    min-width: 45px;
    height: auto;
}

.logo-title{
    display: flex;  /* 横並びにする */

}

.subtext-title{
    font-size: 30px;
    font-weight: bold;
    color:#39cccc;
    padding:0px 10px 0px 10px;
}

.subtext {
    margin-top: 5px;
    font-size: 16px;
    color:#39cccc;
    min-width: 250px;
    width:auto;
    text-align: center; 
}

/* ログインフォーム */
.form-section {
    width: 30%;
    margin: 20px 10px 10px 10px;
    min-width: 250px;
    width:auto;
}

.welcome form {
    width: 100%;
    max-width: 250px; /* 最大幅を設定 */
    margin: 10px auto;
}

.welcome input {
    width: 200%;
    padding: 8px 10px;
    width:auto;
    min-width: 250px;
    margin: 6px auto;
    border-radius: 4px;
    border: 1px solid #eee;
    outline: none;
    box-sizing: border-box;
}

.welcome span {
    font-weight: bold;
    text-decoration: underline;
    cursor: pointer;
}

.welcome button {
    margin: 5px auto;
}

/* 機能リストセクション */
.features-section {
    height: absolute; /* 画面の半分を確保 */
    min-height: 46vh; /* 必要に応じて最低限の高さを確保 */
    background-color: #f8f8f8;
    padding: 0px 0px;
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.features-title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 10px;
    color: #39cccc;
}

.features-list {
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
    max-width: 950px;
    margin: 3px auto;
}

.feature-item {
    padding:10px 0 0 0;
    width: 30%;
    border-radius: 12px;
    background: rgba(241, 240, 240, 0.867);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    align-items: center; /* 中央揃え */
    text-align: left;
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
    display: flex; /* 横並びにする */
    flex-direction: column; /* 縦並び */
    align-items: center; /* 中央揃え */
}

.feature-item:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

.feature-title {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 10px;
    color: #39cccc;
    text-align: center;
}

.feature-image {
    max-width: 80%;
    height: auto;
    border-radius: 4px;
    display: block;
    margin: 0;
}

.feature-description {
    font-size: 14px;
    color: #39cccc;
    padding: 11px 0px 0px 10px;
}

</style>
