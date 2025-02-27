import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import VueTailwindDatepicker from 'vue-tailwind-datepicker'

import './assets/style.css'
import { library } from '@fortawesome/fontawesome-svg-core';
import { faTag, faHeart, faSmile, faStar, faThumbsUp } from '@fortawesome/free-solid-svg-icons';
import '@fortawesome/fontawesome-free/css/all.min.css';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

library.add(faTag, faHeart, faSmile, faStar, faThumbsUp);

const app = createApp(App)
app.use(createPinia())// piniaを使う設定
app.use(router)
app.use(VueTailwindDatepicker)
// グローバルコンポーネントとして登録
app.component('font-awesome-icon', FontAwesomeIcon);
app.mount('#app')
