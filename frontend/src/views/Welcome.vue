<template>
    <div class="container welcome">
        <div class="content-wrapper">
            <!-- ロゴとテキスト -->
            <div class="logo-section">
                <img src="/images/logo_Ibetan.png" alt="Logo" class="logo-image" />
            </div>

            <!-- ログインフォームまたはサインアップフォーム -->
            <div class="form-section">
            <p class="subtext">お家でもっと地域のコミュニティに参加できるよ</p>

                <div v-if="shouldShowLoginForm">
                    <LoginForm @redirectToChatRoom="redirectToChatRoom" />
                    <p class="change-form">
                        初めての方は
                        <span @click="shouldShowLoginForm = false">
                            こちら
                        </span>をクリックして<br>ご登録ページへお進みください
                    </p>
                </div>
                <div v-if="!shouldShowLoginForm">
                    <SignupForm @redirectToChatRoom="redirectToChatRoom" />
                    <p class="change-form">
                        アカウント登録済の方は
                        <span @click="shouldShowLoginForm = true">
                            こちら
                        </span>からログインしてください
                    </p>
                </div>
            </div>
        </div>

        <!-- 機能リスト -->
        <div class="features-section">
            <h2 class="features-title">このアプリで主にできること</h2>
            <div class="features-list">
                <div class="feature-item">
                    <h3 class="feature-title">イベントのタグチェック</h3>
                    <p class="feature-description">イベントにタグチェックするとマイページでも確認できるよ</p>
                </div>

                <div class="feature-item">
                    <h3 class="feature-title">ライブチャット機能</h3>
                    <p class="feature-description">ホーム画面上でリアルタイムにチャットを送れるよ</p>
                </div>

                <div class="feature-item">
                    <h3 class="feature-title">マンスリーカレンダー表示</h3>
                    <p class="feature-description">開催イベントやカレンダーにイベントを追加でき、人目でわかるよ</p>
                </div>
            </div>
        </div>

    </div>
</template>

<script>
import loginForm from '../components/loginForm.vue';
import signupForm from '../components/signupForm.vue';
export default {
    components: { loginForm, signupForm },
    data(){
        return{
        shouldShowLoginForm: false
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
    padding: 40px 0;
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
.features-section {
    padding: 20px;
    text-align: center;
}

.features-title {
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
    margin-bottom: 10px;
}

.feature-description {
    font-size: 14px;
    color: #555;
}
</style>