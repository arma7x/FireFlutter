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
          <v-list subheader v-if="queues != null" class="py-0">
            <v-list-tile :key="i" v-for="(chat, i) in queues" avatar @click="">
              <v-list-tile-avatar v-if="users[chat.key]" size="40" color="grey">
                <img v-if="users[chat.key].photoUrl != null" :src="users[chat.key].photoUrl">
                <v-icon v-if="users[chat.key].photoUrl == null" size="50" color="white">account_circle</v-icon>
              </v-list-tile-avatar>
              <v-list-tile-content v-if="users[chat.key]">
                <v-list-tile-title>
                  <v-icon v-if="chat.status != 0" size="16" color="info">lock</v-icon>
                  <v-icon v-if="chat.status == 0" size="16" color="warning">lock_open</v-icon>
                  {{ chat.topic }}
                </v-list-tile-title>
                <v-list-tile-sub-title v-if="users[chat.key]">
                  <v-layout row>
                  {{ users[chat.key].name }}
                  <v-spacer></v-spacer>
                  {{ new Date(chat.timestamp).toLocaleString() }}
                  <v-spacer v-if="chat.assigned_user != false && chat.assigned_user != user.uid"></v-spacer>
                  <span v-if="chat.assigned_user != false && chat.assigned_user != user.uid">{{ users[chat.assigned_user].name }}</span>
                  </v-layout>
                </v-list-tile-sub-title>
              </v-list-tile-content>
              <v-list-tile-action v-if="chat.assigned_user == user.uid || chat.assigned_user == false">
                <v-btn v-if="chat.assigned_user == user.uid" fab small color="primary" @click="joinChat(chat.key)">
                  <v-icon>chat</v-icon>
                </v-btn>
                <v-btn v-if="chat.assigned_user == false" fab small color="warning" @click="handleChat(chat.key)">
                  <v-icon>supervisor_account</v-icon>
                </v-btn>
              </v-list-tile-action>
              <v-list-tile-avatar size="40" color="grey" v-if="chat.assigned_user != false && chat.assigned_user != user.uid && (users[chat.assigned_user] !== null && users[chat.assigned_user] !== undefined)">
                <img v-if="users[chat.assigned_user].photoUrl != null" :src="users[chat.assigned_user].photoUrl">
                <v-icon v-if="users[chat.assigned_user].photoUrl == null" size="50" color="white">account_circle</v-icon>
              </v-list-tile-avatar>
            </v-list-tile>
          </v-list>
        </v-flex>
      </v-layout>
    </v-layout>
  </v-container>
</template>

<script>
  import * as firebase from 'firebase'

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
          const user = { assigned_user: this.user.uid, status: 1 }
          firebase.database().ref('queues/' + id).update(user)
          .then(() => {
            return firebase.database().ref('chats/' + id).update(user)
          })
          .then(() => {
            this.joinChat(id)
          })
          .catch((error) => {
            this.$store.commit('setError', error)
          })
        }
      } // ,
      // onDismissed () {
        // this.$store.dispatch('clearError')
      // }
    }
  }
</script>
