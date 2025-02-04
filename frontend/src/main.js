import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import VueTailwindDatepicker from 'vue-tailwind-datepicker'

import './assets/style.css'
import { library } from '@fortawesome/fontawesome-svg-core';
import { faTag, faHeart } from '@fortawesome/free-solid-svg-icons';
import '@fortawesome/fontawesome-free/css/all.min.css';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

library.add(faTag, faHeart);

const app = createApp(App)
app.use(router)
app.use(VueTailwindDatepicker)
// グローバルコンポーネントとして登録
app.component('font-awesome-icon', FontAwesomeIcon);
app.mount('#app')
