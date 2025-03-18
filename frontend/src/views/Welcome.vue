<template>
    <div class="container welcome">
        <div class="content-wrapper">
            <!-- ロゴとテキスト -->
            <div class="logo-section">
                <img src="/images/logo_Ibetan.png" alt="Logo" class="logo-image" />

                <p class="subtext">お家でもっと地域のコミュニティに参加できるよ</p>

            </div>

            <!-- ログインフォーム -->
            <div class="form-section">
                <loginForm @redirectToChatRoom="redirectToChatRoom" />
            </div>
        </div>

        <!-- 機能リスト -->
        <div class="features-section">
            <h2 class="features-title">このアプリで出来る3つのこと</h2>
            <div class="features-list">
                <div class="feature-item">
                    <h3 class="feature-title">タグ機能</h3>
                    <p class="feature-description">
                        タグマークをチェックするとマイページでも確認できるよ。</p>
                </div>

                <div class="feature-item">
                    <h3 class="feature-title">チャット機能</h3>
                    <p class="feature-description">
                        リアルタイムにチャットを送って、いいねも付けてね。</p>
                </div>

                <div class="feature-item">
                    <h3 class="feature-title">カレンダー機能</h3>
                    <p class="feature-description">
                        イベントの開催日は自動で表示されるよ。予定は個別に追加できるので使ってみてね。</p>
                </div>
            </div>
        </div>

    </div>
</template>

<script>
import loginForm from '../components/loginForm.vue';
export default {
    components: { loginForm },
    data(){
        return{
        shouldShowLoginForm: true
        }
    },
    methods: {
        redirectToChatRoom () {
            this.$router.push({ name: 'ChatRoom' })
        }
    }  
}
</script>

<style>
.welcome {
    text-align: center;
    padding: 20px 0;
}

.content-wrapper {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
}

.logo-section {
    width: 45%; /* ロゴを画面の半分に設定 */
    text-align: center;
    margin-left:20px;
}

.logo-image {
    max-width: 100%;
    height: auto;
}

.subtext {
    margin-top: 15px;
    font-size: 16px;
    color: #555;
}

.form-section {
    width: 45%; /* フォームを画面の半分に設定 */
    margin-right: 20px;;
}

.change-form {
    font-size: 14px;
    margin-top: 20px;
}

.welcome form {
    width: 100%;
    margin: 20px auto;
}

.welcome label {
    display: block;
    margin: 20px 0 10px;
}

.welcome input {
    width: 100%;
    padding: 12px 20px;
    margin: 8px auto;
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
    margin: 20px auto;
}
.welcome {
    text-align: center;
    padding: 20px 0;
    background-image: url('@/assets/background.jpg');/* 背景画像のパス */
    background-size: cover; /* 画像を画面いっぱいに表示 */
    background-position: center; /* 画像を中央配置 */
    background-repeat: no-repeat; /* 画像の繰り返しを防ぐ */
    min-height: 100vh; /* 画面全体をカバー */
}

.features-section {
    padding: 20px;
    text-align: center;
}

.features-title {
    color:white;
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
}

.features-list {
    display: flex;
    justify-content: space-between;
    gap: 20px;
    flex-wrap: wrap; /* 小さな画面で折り返し表示 */
}

.feature-item {
    width: 30%;
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background-color: #f9f9f9;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    text-align: left;
}

.feature-title {
    font-size: 18px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 10px;
}

.feature-description {
    font-size: 14px;
    color: #555;
}
.subtext {
    color: white;
}
</style>