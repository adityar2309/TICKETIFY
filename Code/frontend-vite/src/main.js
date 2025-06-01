import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './axios'
import store from './store/store'
import 'bootstrap/dist/css/bootstrap.css'

createApp(App).use(router).use(store).mount('#app')
