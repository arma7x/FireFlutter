import Vue from 'vue'
import Router from 'vue-router'
const Home = () => import('@/components/Home')
const Profile = () => import('@/components/User/Profile')
const Chat = () => import('@/components/User/Chat')
const Queue = () => import('@/components/User/Queue')
const Signup = () => import('@/components/User/Signup')
const Signin = () => import('@/components/User/Signin')
const ResetPassword = () => import('@/components/User/ResetPassword')
import {requireAuth, avoidAuth} from './auth-guard'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/profile',
      name: 'Profile',
      component: Profile,
      beforeEnter: requireAuth
    },
    {
      path: '/chat',
      name: 'Chat',
      component: Chat,
      beforeEnter: requireAuth
    },
    {
      path: '/queue',
      name: 'Queue',
      component: Queue,
      beforeEnter: requireAuth
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup,
      beforeEnter: avoidAuth
    },
    {
      path: '/signin',
      name: 'Signin',
      component: Signin,
      beforeEnter: avoidAuth
    },
    {
      path: '/reset-password',
      name: 'Reset Password',
      component: ResetPassword,
      beforeEnter: avoidAuth
    }
  ],
  mode: 'history'
})
