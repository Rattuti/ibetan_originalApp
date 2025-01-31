import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import VueTailwindDatepicker from 'vue-tailwind-datepicker'

import './assets/style.css'

const app = createApp(App)
app.use(router)
app.use(VueTailwindDatepicker)
app.mount('#app')
