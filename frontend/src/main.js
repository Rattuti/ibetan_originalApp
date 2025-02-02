import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import VueTailwindDatepicker from 'vue-tailwind-datepicker'

import './assets/style.css'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

const app = createApp(App)
app.use(router)
app.use(VueTailwindDatepicker)
// グローバルコンポーネントとして登録
app.component('font-awesome-icon', FontAwesomeIcon);
app.mount('#app')
