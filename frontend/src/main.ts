import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { directive } from 'v-click-outside-x'

import App from './App.vue'
import router from './router'
import './assets/main.css'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.directive('click-outside', directive)

app.mount('#app')
