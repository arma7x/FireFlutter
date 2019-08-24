<template>
  <v-container class="center-vertical">
    <v-layout column>
      <!-- <v-layout row v-if="error">
        <v-flex xs12 sm4 offset-sm4>
          <app-alert @dismissed="onDismissed" :text="error.message"></app-alert>
        </v-flex>
      </v-layout> -->
      <v-layout row v-if="chat == null">
        <v-flex xs12 sm6 offset-sm3>
          <v-card class="mb-2">
            <v-card-text>
              <form style="width:100%" @submit.prevent="joinQueue">
                <v-layout row wrap>
                  <v-flex xs12>
                    <v-text-field
                      name="topic"
                      label="Topic of discussion or issue ?"
                      id="topic"
                      v-model="topic"
                      type="text"
                      required>
                    </v-text-field>
                    <v-btn block class="primary" @click="joinQueue">Join Queue</v-btn>
                  </v-flex>
                </v-layout>
              </form>
            </v-card-text>
         </v-card>
        </v-flex>
      </v-layout>
      <v-layout row v-if="chat != null">
        <v-flex xs12 sm6 offset-sm3>
          <div v-if="chat != null">
            <v-container class="mx-0 my-0 px-0 py-0 scroll-y" style="height:68vh;" ref="chat_scroller">
              <v-layout class="mx-0 px-0" column v-if="chat.logs != undefined">
                <ul style="list-style: none;">
                  <li :key="i" v-for="(msg, i) in chat.logs">
                    <v-layout class="mb-2 px-0" row>
                      <v-list-tile-avatar color="grey" size="40" v-if="msg.user != user.uid && msg.user == chat.assigned_user">
                        <img v-if="assigned_user.photoUrl != null" :src="assigned_user.photoUrl">
                        <v-icon v-if="assigned_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                      </v-list-tile-avatar>
                      <v-list-tile-avatar color="grey" size="40" v-if="msg.user != user.uid && msg.user == uid">
                        <img v-if="queue_user.photoUrl != null" :src="queue_user.photoUrl">
                        <v-icon v-if="queue_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                      </v-list-tile-avatar>
                      <v-flex xs12 sm6 :class="{ 'col-auto ml-auto': msg.user == user.uid }">
                        <v-card>
                          <v-card-text class="mx-0 my-0">
                            <v-list-tile-content>
                              <v-list-tile-sub-title :style="{ textAlign: (msg.user == user.uid ? 'right' : 'left') }" style="white-space: normal;" class="black--text">{{ msg.message.data }}</v-list-tile-sub-title>
                              <v-list-tile-sub-title :style="{ textAlign: (msg.user == user.uid ? 'right' : 'left') }" class="caption grey--text">{{ new Date(msg.timestamp).toLocaleString() }}</v-list-tile-sub-title>
                            </v-list-tile-content>
                          </v-card-text>
                        </v-card>
                      </v-flex>
                      <v-list-tile-avatar class="ml-3" color="grey" size="40" v-if="msg.user == user.uid">
                        <img v-if="user.photoUrl != null" :src="user.photoUrl">
                        <v-icon v-if="user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                      </v-list-tile-avatar>
                    </v-layout>
                  </li>
                </ul>
              </v-layout>
            </v-container>
            <form style="width:100%;" @submit.prevent="sendMessage" class="transparent">
              <v-layout row wrap align-center class="transparent">
                <v-flex xs2 style="display:flex;align-items:center;justify-content:center;">
                  <v-btn fab small color="info" @click="toggleHidden"><v-icon dark>announcement</v-icon></v-btn>
                </v-flex>
                <v-flex xs8 class="transparent">
                  <v-textarea
                    v-model="message"
                    :auto-grow="autoGrow"
                    :clearable="clearable"
                    :counter="counter ? counter : false"
                    :filled="filled"
                    :flat="flat"
                    :hint="hint"
                    :label="label"
                    :loading="loading"
                    :no-resize="noResize"
                    :outlined="outlined"
                    :persistent-hint="persistentHint"
                    :placeholder="placeholder"
                    :rounded="rounded"
                    :row-height="rowHeight"
                    :rows="rows"
                    :shaped="shaped"
                    :single-line="singleLine"
                    :solo="solo"
                  ></v-textarea>
                </v-flex>
                <v-flex xs2 style="display:flex;align-items:center;justify-content:center;">
                  <v-btn fab small color="primary" @click="sendMessage"><v-icon dark>send</v-icon></v-btn>
                </v-flex>
              </v-layout>
            </form>
          </div>
        </v-flex>
      </v-layout>
    </v-layout>
    <v-dialog v-model="hidden" max-width="280px">
      <v-card>
        <v-card-text>
          <div class="text-xl-center text-lg-center text-sm-center text-md-center text-xs-center">
            <div v-if="chat != null">
              <v-list subheader>
                <v-list-tile>
                  <v-list-tile-content>
                    <v-list-tile-title class="title">Topic</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ chat.topic }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile class="mt-1">
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Timestamp</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ new Date(chat.timestamp).toLocaleString() }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile class="mt-1">
                  <v-list-tile-avatar size="40" color="grey" v-if="chat.assigned_user != false && assigned_user != null">
                    <img v-if="assigned_user.photoUrl != null" :src="assigned_user.photoUrl">
                    <v-icon v-if="assigned_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                  </v-list-tile-avatar>
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Supervisor</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ assigned_user != null ? assigned_user.name : 'TBA' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile class="mt-1">
                  <v-list-tile-avatar size="40" color="grey" v-if="queue_user != null">
                    <img v-if="queue_user.photoUrl != null" :src="queue_user.photoUrl">
                    <v-icon v-if="queue_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                  </v-list-tile-avatar>
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Client</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ queue_user != null ? queue_user.name : '-' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile v-if="queue_user_private != null && user.admin" class="mt-1">
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Client Status</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ queue_user_private.online != true ? `Last Seen ${new Date(queue_user_private.last_online).toLocaleString()}` : 'Online' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-layout row class="mt-1">
                  <v-list-tile v-if="user.admin">
                    <v-list-tile-content>
                      <v-list-tile-title class="body-2 pb-2">{{ chat.status == 0 ? 'Unlocked' : 'Locked' }}</v-list-tile-title>
                      <v-list-tile-sub-title class="body-1">
                        <v-switch class="my-0 mx-2" v-model="chat.status == 0 ? false : true" @change="adminToggleStatus"></v-switch>
                      </v-list-tile-sub-title>
                    </v-list-tile-content>
                  </v-list-tile>
                  <v-spacer v-if="user.admin && chat.status == 0"></v-spacer>
                  <v-list-tile v-if="user.admin && chat.status == 0">
                    <v-list-tile-content>
                      <v-list-tile-title class="body-2">Delete Queue</v-list-tile-title>
                        <v-btn color="error" @click="adminDeleteQueue">
                          Delete
                          <v-icon right>delete</v-icon>
                        </v-btn>
                    </v-list-tile-content>
                  </v-list-tile>
                  <v-spacer v-if="user.uid == uid && chat.status == 0"></v-spacer>
                  <v-list-tile v-if="user.uid == uid && chat.status == 0">
                    <v-list-tile-content>
                      <v-list-tile-title class="body-2">Delete Queue</v-list-tile-title>
                        <v-btn color="error" @click="deleteQueue">
                          Delete
                          <v-icon right>delete</v-icon>
                        </v-btn>
                    </v-list-tile-content>
                  </v-list-tile>
                  </v-layout>
              </v-list>
            </div>
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
  import * as firebase from 'firebase'
  import axios from 'axios'

  export default {
    data () {
      return {
        autoGrow: false,
        autofocus: true,
        clearable: false,
        counter: true,
        filled: false,
        flat: false,
        hint: '',
        label: '',
        loading: false,
        noResize: false,
        outlined: false,
        persistentHint: false,
        placeholder: '',
        rounded: false,
        rowHeight: 24,
        rows: 2,
        shaped: false,
        singleLine: false,
        solo: false,
        item: 'chat',
        topic: null,
        message: null,
        chat: null,
        uid: null,
        assigned_user: null,
        queue_user: null,
        queue_user_private: null,
        hidden: false
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
      const uid = this.$route.query.id ? this.$route.query.id : this.$store.getters.user.uid
      this.uid = uid
      if (this.queue_user == null) {
        db.ref('users_public/' + this.uid)
        .once('value', (userSnapshot) => {
          this.queue_user = userSnapshot.val()
        })
      }
      db.ref('users/' + this.uid)
      .once('value', (userSnapshot) => {
        this.queue_user_private = userSnapshot.val()
        console.log(this.queue_user_private)
      })
      db.ref('chats/' + this.uid).on('value', (dataSnapshot) => {
        if (dataSnapshot.val()) {
          this.chat = dataSnapshot.val()
          if (dataSnapshot.val().assigned_user && this.assigned_user == null) {
            db.ref('users_public/' + dataSnapshot.val().assigned_user)
            .once('value', (userSnapshot) => {
              this.assigned_user = userSnapshot.val()
            })
          }
        } else {
          this.chat = null
        }
      })
    },
    updated () {
      if (this.$refs.chat_scroller) {
        this.$refs.chat_scroller.scrollTop = this.$refs.chat_scroller.scrollHeight
      }
    },
    methods: {
      toggleHidden () {
        this.hidden = !this.hidden
      },
      joinQueue () {
        if (confirm('Are sure to enter chat queue list ?')) {
          this.$store.commit('setLoading', true)
          this.$store.commit('clearError')
          firebase.auth().currentUser.getIdToken(true)
          .then((idToken) => {
            return axios.get(`https://us-central1-${firebase.apps[0].options.projectId}.cloudfunctions.net/joinQueue`, { params: { 'token': idToken, topic: this.topic } })
          })
          .then((response) => {
            this.$store.commit('setLoading', false)
          })
          .catch((error) => {
            this.$store.commit('setLoading', false)
            this.$store.commit('setError', error.response.data)
          })
        }
      },
      sendMessage () {
        this.$store.commit('clearError')
        const data = {
          'user': this.$store.getters.user.uid,
          'timestamp': firebase.database.ServerValue.TIMESTAMP,
          'message': {
            'mime': 'text',
            'data': this.message,
            'caption': ''
          }
        }
        firebase.database().ref('/chats/' + this.uid + '/logs').push(data)
        .then(() => {
          this.message = null
          this.$store.commit('clearError')
        })
        .catch((error) => {
          this.$store.commit('setError', error)
        })
      },
      adminToggleStatus () {
        const status = { status: (this.chat.status === 0 ? 1 : 0) }
        firebase.database().ref('chats/' + this.uid).update(status)
        firebase.database().ref('queues/' + this.uid).update(status)
      },
      deleteQueue () {
        if (confirm('Are sure to exit from chat queue list ?')) {
          this.$store.commit('setLoading', true)
          firebase.auth().currentUser.getIdToken(true)
          .then((idToken) => {
            return axios.get(`https://us-central1-${firebase.apps[0].options.projectId}.cloudfunctions.net/deleteQueue`, { params: { 'token': idToken } })
          })
          .then((response) => {
            this.$store.commit('setLoading', false)
            this.$store.commit('clearError')
            this.hidden = false
          })
          .catch((error) => {
            this.$store.commit('setLoading', false)
            this.$store.commit('setError', error.response.data)
          })
        }
      },
      adminDeleteQueue () {
        if (confirm('Are sure to delete this chat from queue list ?')) {
          this.$store.commit('setLoading', true)
          firebase.auth().currentUser.getIdToken(true)
          .then((idToken) => {
            return axios.get(`https://us-central1-${firebase.apps[0].options.projectId}.cloudfunctions.net/adminDeleteQueue`, { params: { 'token': idToken, 'queue': this.uid } })
          })
          .then((response) => {
            this.$store.commit('setLoading', false)
            this.$store.commit('clearError')
            this.hidden = false
            this.$router.go(-1)
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
