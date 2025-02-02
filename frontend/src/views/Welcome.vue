<template>
    <div class="container welcome">
        <p class="text-12xl font-bold underline">(仮)いべたん！</p>
        <p>(仮)住まい地域</p>

        <div v-if="shouldShowLoginForm">
            <LoginForm @redirectToChatRoom="redirectToChatRoom" />
            <p class="change-form">初めての方は<span @click="shouldShowLoginForm = false">こちら</span>をクリックして<br>ご登録ページへお進みください</p>
        </div>
        <div v-if="!shouldShowLoginForm">
            <SignupForm @redirectToChatRoom="redirectToChatRoom" />
            <p class="change-form">アカウントをお持ちの方は<span @click="shouldShowLoginForm = true">こちら</span>からログインしてください</p>
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
    padding: 20px 0;
}
.welcome form{
    width: 300px;
    margin: 20px auto;
}
.welcome label{
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
.welcome span{
    font-weight: bold;
    text-decoration: underline;
    cursor: pointer;
}
.welcome button {
    margin: 20px auto;
}
.change-form{
    font-size: 14px;
    margin: 10px;
}
</style>