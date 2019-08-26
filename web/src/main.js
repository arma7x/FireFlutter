// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import 'babel-polyfill'
import Vue from 'vue'
import Vuetify from 'vuetify'
import * as firebase from 'firebase'
import router from './router'
import { store } from './store'
import Config from './config'
import { makeid } from './utils'
const App = () => import('./App')
const AlertCmp = () => import('./components/Shared/Alert.vue')

Vue.use(Vuetify)
Vue.config.productionTip = false

router.beforeEach((to, from, next) => {
  document.title = `FireFlutter | ${to.name}`
  next()
})

Vue.component('app-alert', AlertCmp)
/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App },
  created () {
    if (localStorage.getItem('client_id') === null) {
      localStorage.setItem('client_id', makeid(20))
    }
    this.$store.dispatch('setClientId', localStorage.getItem('client_id'))
    firebase.initializeApp(Config.firebase)
    firebase.auth().onAuthStateChanged((user) => {
      if (user) {
        firebase.auth().currentUser.getIdTokenResult()
        .then((_user) => {
          const userObj = {
            uid: _user.claims.user_id,
            name: _user.claims.name || 'Unknown',
            email: _user.claims.email,
            photoUrl: _user.claims.picture,
            admin: _user.claims.admin || false
          }
          this.$store.dispatch('autoSignIn', userObj)
          firebase.database().ref('users/' + _user.claims.user_id)
          .on('value', (dataSnapshot) => {
            this.$store.dispatch('updateMetadata', dataSnapshot.val())
          })
        })
      }
    })
    firebase.database().ref('.info/connected').on('value', (snap) => {
      if (snap.val() === true) {
        if (this.$store.getters.user !== null && this.$store.getters.user !== undefined) {
          const onlineRef = firebase.database().ref('/users/' + this.$store.getters.user.uid + '/online')
          onlineRef.onDisconnect().set(false)
          onlineRef.set(true)
          const lastOnlineRef = firebase.database().ref('/users/' + this.$store.getters.user.uid + '/last_online')
          lastOnlineRef.onDisconnect().set(firebase.database.ServerValue.TIMESTAMP)
          lastOnlineRef.set(firebase.database.ServerValue.TIMESTAMP)
        }
      }
    })
    const messaging = firebase.messaging()
    messaging.usePublicVapidKey(Config.firebaseMessagingPublicVapidKey)
    Notification.requestPermission()
    .then((permission) => {
      return messaging.getToken()
    })
    .then((token) => {
      this.$store.dispatch('setFcm', token)
      if (this.$store.getters.user !== null && this.$store.getters.user !== undefined) {
        this.$store.dispatch('addActiveDevice', {uid: this.$store.getters.user.id})
      }
    })
    .catch((e) => {
      console.log(e)
    })
    messaging.onTokenRefresh(() => {
      messaging.getToken()
      .then((refreshedToken) => {
        this.$store.dispatch('setFcm', refreshedToken)
        if (this.$store.getters.user !== null && this.$store.getters.user !== undefined) {
          this.$store.dispatch('addActiveDevice', {uid: this.$store.getters.user.id})
        }
      })
      .catch((err) => {
        console.log(err)
      })
    })
  }
})
