<template>
  <v-container class="no-center-vertical">
    <v-layout column>
      <!-- <v-layout row v-if="error">
        <v-flex xs12 sm4 offset-sm4>
          <app-alert @dismissed="onDismissed" :text="error.message"></app-alert>
        </v-flex>
      </v-layout> -->
      <v-layout row>
        <v-flex xs12 sm6 offset-sm3>
          <div v-if="queues != null" class="py-0">
            <v-card :key="i" v-for="(chat, i) in queues" avatar class="mb-2">
              <v-layout column>
                <v-card-text>
                  <v-layout align-start class="body-2">
                    <v-icon class="mr-1 body-2" v-if="chat.status != 0" color="info">lock</v-icon>
                    <v-icon class="mr-1 body-2" v-if="chat.status == 0" color="warning">lock_open</v-icon>
                    {{ chat.topic }}
                  </v-layout>
                  <v-layout row class="mt-1">
                    <v-avatar v-if="users[chat.key]" size="40" color="grey">
                      <img v-if="users[chat.key].photoUrl != null" :src="users[chat.key].photoUrl">
                      <v-icon v-if="users[chat.key].photoUrl == null" size="50" color="white">account_circle</v-icon>
                    </v-avatar>
                    <v-layout row class="px-2">
                      <v-layout>
                        <v-layout row v-if="users[chat.key]">
                          <v-layout column>
                          <span class="body-2">Client</span>
                          <span class="caption grey--text">{{ users[chat.key].name }}</span>
                          </v-layout>
                        </v-layout>
                      </v-layout>
                      <v-spacer v-if="chat.assigned_user != false && chat.assigned_user != user.uid"></v-spacer>
                      <v-layout v-if="chat.assigned_user != false && chat.assigned_user != user.uid">
                        <v-layout row>
                          <v-layout column align-end>
                          <span class="body-2">Supervisor</span>
                          <span class="caption grey--text">{{ users[chat.assigned_user].name }}</span>
                          </v-layout>
                        </v-layout>
                      </v-layout>
                    </v-layout>
                    <v-layout align-start justify-end v-if="chat.assigned_user == user.uid || chat.assigned_user == false">
                      <v-btn class="px-0 py-0 mx-0 my-0" v-if="chat.assigned_user == user.uid" fab small color="primary" @click="joinChat(chat.key)">
                        <v-icon>chat</v-icon>
                      </v-btn>
                      <v-btn class="px-0 py-0 mx-0 my-0" v-if="chat.assigned_user == false" fab small color="warning" @click="handleChat(chat.key)">
                        <v-icon>supervisor_account</v-icon>
                      </v-btn>
                    </v-layout>
                    <v-avatar size="40" color="grey" v-if="chat.assigned_user != false && chat.assigned_user != user.uid && (users[chat.assigned_user] !== null && users[chat.assigned_user] !== undefined)">
                      <img v-if="users[chat.assigned_user].photoUrl != null" :src="users[chat.assigned_user].photoUrl">
                      <v-icon v-if="users[chat.assigned_user].photoUrl == null" size="50" color="white">account_circle</v-icon>
                    </v-avatar>
                  </v-layout>
                  <v-layout align-end justify-end style="line-height: normal;" column v-if="users[chat.key]">
                    <v-layout align-end class="mt-2 mx-1 caption">
                      <v-icon class="mr-1 caption" color="primary">calendar_today</v-icon>
                      {{ new Date(chat.timestamp).toLocaleString() }}
                    </v-layout>
                  </v-layout>
                </v-card-text>
              </v-layout>
            </v-card>
          </div>
        </v-flex>
      </v-layout>
    </v-layout>
  </v-container>
</template>

<script>
  import * as firebase from 'firebase'
  import Api from '../../api'

  export default {
    data () {
      return {
        users: {},
        queues: null
      }
    },
    computed: {
      user () {
        return this.$store.getters.user
      },
      error () {
        return this.$store.getters.error
      }
    },
    mounted () {
      const db = firebase.database()
      const ref = db.ref('queues')
      ref.orderByChild('timestamp').on('value', (dataSnapshot) => {
        let q = []
        for (let k in dataSnapshot.val()) {
          const obj = dataSnapshot.val()[k]
          obj['key'] = k
          q.push(obj)
        }
        q.sort((a, b) => (a.timestamp > b.timestamp) ? 1 : -1)
        this.queues = q
        let index = 1
        this.queues.forEach((value) => {
          if (value.assigned_user === false) {
            const update = { queue_number: index }
            firebase.database().ref('chats/' + value.key).update(update)
            firebase.database().ref('queues/' + value.key).update(update)
            index++
          }
        })
      })
      db.ref('users_public')
      .on('value', (usersSnapshot) => {
        this.users = usersSnapshot.val()
      })
    },
    methods: {
      joinChat (id) {
        this.$router.push({ path: 'chat', query: { id } })
      },
      handleChat (id) {
        if (confirm('Are sure to put this queue under your supervision ?')) {
          this.$store.commit('setLoading', true)
          let token
          firebase.auth().currentUser.getIdToken(true)
          .then((idToken) => {
            token = idToken
            return Api.adminSuperviseQueue({ 'token': idToken, 'queue': id })
          })
          .then((response) => {
            this.$store.commit('setLoading', false)
            this.$store.commit('clearError')
            Api.adminNotifyClient({ 'token': token, 'queue': id })
            this.joinChat(id)
          })
          .catch((error) => {
            this.$store.commit('setLoading', false)
            this.$store.commit('setError', error.response.data)
          })
        }
      } // ,
      // onDismissed () {
        // this.$store.dispatch('clearError')
      // }
    }
  }
</script>
