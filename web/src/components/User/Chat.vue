<template>
  <v-container class="center-vertical">
    <v-layout column>
      <!-- <v-layout row v-if="error">
        <v-flex xs12 sm4 offset-sm4>
          <app-alert @dismissed="onDismissed" :text="error.message"></app-alert>
        </v-flex>
      </v-layout> -->
      <v-layout row v-if="chat == null">
        <v-flex>
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
        <v-flex class="pl-2 pr-2 hidden-xs-only">
          <v-card class="mb-2">
            <v-card-text>
              <div class="text-xl-center text-lg-center text-sm-center text-md-center text-xs-center">
                <div v-if="chat != null">
                  <v-list subheader>
                    <v-layout row>
                      <v-list-tile>
                        <v-list-tile-content>
                          <v-list-tile-title class="body-2">Topic</v-list-tile-title>
                          <v-list-tile-sub-title class="caption">{{ chat.topic }}</v-list-tile-sub-title>
                        </v-list-tile-content>
                      </v-list-tile>
                      <v-spacer></v-spacer>
                      <v-list-tile>
                        <v-list-tile-content>
                          <v-list-tile-title class="body-2">Timestamp</v-list-tile-title>
                          <v-list-tile-sub-title class="caption">{{ new Date(chat.timestamp).toLocaleString() }}</v-list-tile-sub-title>
                        </v-list-tile-content>
                      </v-list-tile>
                    </v-layout>
                    <v-layout row>
                      <v-list-tile>
                        <v-list-tile-avatar size="40" color="grey" v-if="chat.assigned_user != false && assigned_user != null">
                          <img v-if="assigned_user.photoUrl != null" :src="assigned_user.photoUrl">
                          <v-icon v-if="assigned_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                        </v-list-tile-avatar>
                        <v-list-tile-content>
                          <v-list-tile-title class="body-2">Supervisor</v-list-tile-title>
                          <v-list-tile-sub-title class="caption">{{ assigned_user != null ? assigned_user.name : 'TBA' }}</v-list-tile-sub-title>
                        </v-list-tile-content>
                      </v-list-tile>
                      <v-spacer></v-spacer>
                      <v-list-tile>
                        <v-list-tile-avatar size="40" color="grey" v-if="queue_user != null">
                          <img v-if="queue_user.photoUrl != null" :src="queue_user.photoUrl">
                          <v-icon v-if="queue_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                        </v-list-tile-avatar>
                        <v-list-tile-content>
                          <v-list-tile-title class="body-2">Client</v-list-tile-title>
                          <v-list-tile-sub-title class="caption">{{ queue_user != null ? queue_user.name : '-' }}</v-list-tile-sub-title>
                        </v-list-tile-content>
                      </v-list-tile>
                    </v-layout>
                    <v-layout row>
                      <v-list-tile v-if="user.admin">
                        <v-list-tile-content>
                          <v-list-tile-title class="body-2 pb-2">Status</v-list-tile-title>
                          <v-list-tile-sub-title class="caption">
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
        </v-flex>
        <v-flex class="pl-2 pr-2">
           <!-- <v-card>
            <v-card-text class="blue-grey lighten-5"> -->
              <div v-if="chat != null">
                <v-list class="blue-grey lighten-5">
                  <v-container class="mx-0 my-0 px-0 py-0 scroll-y" style="height:60vh;" ref="chat_scroller">
                    <v-layout v-if="chat.logs != undefined" column>
                      <v-list two-line disabled class="blue-grey lighten-5">
                        <v-list-tile :key="i" class="mb-2" v-for="(msg, i) in chat.logs">
                          <v-list-tile-avatar class="ml-1" color="grey" size="40" v-if="msg.user != user.uid && msg.user == chat.assigned_user">
                            <img v-if="assigned_user.photoUrl != null" :src="assigned_user.photoUrl">
                            <v-icon v-if="assigned_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                          </v-list-tile-avatar>
                          <v-list-tile-avatar class="ml-1" color="grey" size="40" v-if="msg.user != user.uid && msg.user == uid">
                            <img v-if="queue_user.photoUrl != null" :src="queue_user.photoUrl">
                            <v-icon v-if="queue_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                          </v-list-tile-avatar>
                          <v-flex xs12 sm5 :class="{ 'col-auto ml-auto': msg.user == user.uid }">
                            <v-card>
                              <v-card-text class="mx-0">
                                <v-list-tile-content>
                                  <v-list-tile-title :style="{ textAlign: (msg.user == user.uid ? 'right' : 'left') }" v-text="msg.message.data"></v-list-tile-title>
                                  <v-list-tile-sub-title :style="{ textAlign: (msg.user == user.uid ? 'right' : 'left') }" class="caption">{{ new Date(msg.timestamp).toLocaleString() }}</v-list-tile-sub-title>
                                </v-list-tile-content>
                              </v-card-text>
                            </v-card>
                          </v-flex>
                          <v-list-tile-avatar class="ml-1" color="grey" size="40" v-if="msg.user == user.uid">
                            <img v-if="user.photoUrl != null" :src="user.photoUrl">
                            <v-icon v-if="user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                          </v-list-tile-avatar>
                        </v-list-tile>
                      </v-list>
                    </v-layout>
                  </v-container>
                  <form style="width:100%;" @submit.prevent="sendMessage" class="blue-grey lighten-5">
                    <v-layout row wrap align-center class="blue-grey lighten-5">
                      <v-flex xs10 class="blue-grey lighten-5">
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
                          class="pl-4"
                        ></v-textarea>
                      </v-flex>
                      <v-flex xs2 style="display:flex;align-items:center;justify-content:center;">
                      <v-btn fab small color="info" @click="sendMessage"><v-icon dark>send</v-icon></v-btn>
                      </v-flex>
                    </v-layout>
                  </form>
                </v-list>
              </div>
            <!-- </v-card-text>
         </v-card> -->
        </v-flex>
      </v-layout>
    </v-layout>
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
        queue_user: null
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
      const ref = db.ref('chats/' + this.uid)
      ref.on('value', (dataSnapshot) => {
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
      joinQueue () {
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
        this.$store.commit('setLoading', true)
        firebase.auth().currentUser.getIdToken(true)
        .then((idToken) => {
          return axios.get(`https://us-central1-${firebase.apps[0].options.projectId}.cloudfunctions.net/deleteQueue`, { params: { 'token': idToken } })
        })
        .then((response) => {
          this.$store.commit('setLoading', false)
          this.$store.commit('clearError')
        })
        .catch((error) => {
          this.$store.commit('setLoading', false)
          this.$store.commit('setError', error.response.data)
        })
      },
      adminDeleteQueue () {
        this.$store.commit('setLoading', true)
        firebase.auth().currentUser.getIdToken(true)
        .then((idToken) => {
          return axios.get(`https://us-central1-${firebase.apps[0].options.projectId}.cloudfunctions.net/adminDeleteQueue`, { params: { 'token': idToken, 'queue': this.uid } })
        })
        .then((response) => {
          this.$store.commit('setLoading', false)
          this.$store.commit('clearError')
          this.$router.go(-1)
        })
        .catch((error) => {
          this.$store.commit('setLoading', false)
          this.$store.commit('setError', error.response.data)
        })
      } // ,
      // onDismissed () {
        // this.$store.dispatch('clearError')
      // }
    }
  }
</script>
