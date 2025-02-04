import { createRouter, createWebHistory } from 'vue-router'
import Welcome from '@/views/Welcome'
import ChatRoom from '@/views/ChatRoom'
import UserMyPage from '@/views/UserMyPage';
import eventCreate from '@/components/eventCreate';
import eventDetail from '@/components/eventDetail';
import Profile from '@/views/Profile';
import Policy from '@/views/Policy';
//import useValidate from '../auth/validate'

//const { error, validate } = useValidate()

// const requireAuth = async (to, from, next) => {
//   const { error, validate } = useValidate();  // ここで呼び出し
//   const uid = window.localStorage.getItem('uid')
//   const client = window.localStorage.getItem('client')
//   const accessToken = window.localStorage.getItem('access-token')

//   if (!uid || !client || !accessToken) {
//     console.log("ログインしていません")
//     next({ name: 'Welcome' })
//     return
//   }

//   await validate()

//   if (error.value) {
//     console.log("認証に失敗しました")
//     next({ name: 'Welcome' })
//   } else {
//     next()
//   }
// }

// const noRequireAuth = async (to, from, next) => {
//   const uid = window.localStorage.getItem('uid')
//   const client = window.localStorage.getItem('client')
//   const accessToken = window.localStorage.getItem('access-token')

//   if (!uid && !client && !accessToken) {
//     next()
//     return
//   }

//   await validate()

//   if (!error.value) {
//     next({ name: 'Chatroom' })
//   } else {
//     next()
//   }
// }

const routes = [
  {
    path: '/',
    name: 'Welcome',
    component: Welcome,
    //beforeEnter: noRequireAuth
  },
  {
    path: '/ChatRoom',
    name: 'ChatRoom',
    component: ChatRoom,
    //beforeEnter: requireAuth
  },
  {
    path: '/UserMyPage',
    name: 'MyPage',
    component: UserMyPage,
    //beforeEnter: noRequireAuth
  },
  {
    path: '/UserMpPage/Profile',
    name: 'Profile',
    component: Profile,
    //beforeEnter: noRequireAuth
  },
  {
    path: '/event/create',
    name: 'eventCreate',
    component: eventCreate,
  },
  {
    path: "/event/:id",
    name: "eventDetail",
    component: eventDetail
  },
  {
    path: '/Policy',
    name: 'Policy',
    component: Policy,
    //beforeEnter: noRequireAuth
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router