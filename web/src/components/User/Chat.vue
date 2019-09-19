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
              <form style="width:100%" @submit.prevent="enterQueue">
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
                    <v-btn block class="primary" @click="enterQueue">Enter Queue</v-btn>
                  </v-flex>
                </v-layout>
              </form>
            </v-card-text>
         </v-card>
        </v-flex>
      </v-layout>
      <v-layout row v-if="chat != null">
        <v-flex xs12 sm6 offset-sm3>
          <v-container class="mx-0 my-0 px-0 py-0 scroll-y" style="height:72vh;" ref="chat_scroller">
            <v-layout class="mx-0 px-0" column v-if="chat.logs != undefined">
              <ul style="list-style: none;" class="mx-0 px-0">
                <li :key="i" v-for="(msg, i) in chat.logs">
                  <v-layout class="mb-2 mx-0 px-0" row>
                    <v-list-tile-avatar class="mr-2" style="min-width:0!important;" color="grey" size="40" v-if="msg.user != user.uid && msg.user == chat.assigned_user && assigned_user !== null && assigned_user !== undefined">
                      <img v-if="assigned_user.photoUrl != null" :src="assigned_user.photoUrl">
                      <v-icon v-if="assigned_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                    </v-list-tile-avatar>
                    <v-list-tile-avatar class="mr-2" style="min-width:0!important;" color="grey" size="40" v-if="msg.user != user.uid && msg.user == uid && queue_user !== null && queue_user !== undefined">
                      <img v-if="queue_user.photoUrl != null" :src="queue_user.photoUrl">
                      <v-icon v-if="queue_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                    </v-list-tile-avatar>
                    <div :class="{ 'col-auto ml-auto': msg.user == user.uid }">
                      <v-card class="chat-box">
                        <v-card-text class="px-2 py-1 mx-0 my-0">
                          <v-list-tile-content>
                            <v-list-tile-sub-title :style="{ textAlign: (msg.user == user.uid ? 'right' : 'left') }" style="white-space: normal;" class="black--text">{{ msg.message.data }}</v-list-tile-sub-title>
                            <v-list-tile-sub-title :style="{ textAlign: (msg.user == user.uid ? 'right' : 'left') }" class="mt-2 caption grey--text">{{ new Date(msg.timestamp).toLocaleString() }}</v-list-tile-sub-title>
                          </v-list-tile-content>
                        </v-card-text>
                      </v-card>
                    </div>
                    <v-list-tile-avatar class="ml-2" style="min-width:0!important;" color="grey" size="40" v-if="user && msg.user == user.uid">
                      <img v-if="user.photoUrl != null" :src="user.photoUrl">
                      <v-icon v-if="user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                    </v-list-tile-avatar>
                  </v-layout>
                </li>
              </ul>
            </v-layout>
          </v-container>
          <form style="width:100%;" @submit.prevent="sendMessage" class="transparent">
            <v-layout row class="transparent">
              <v-flex xs2 style="display:flex;flex-basis:0!important;align-items:center;justify-content:center;">
                <v-btn fab small class="ml-0 mr-2" color="info" @click="toggleHidden"><v-icon dark>announcement</v-icon></v-btn>
              </v-flex>
              <v-layout xs8 class="transparent" style="">
                <v-textarea
                  class="px-0 py-0 mx-0 my-0"
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
              </v-layout>
              <v-flex xs2 style="display:flex;flex-basis:0!important;align-items:center;justify-content:center;">
                <v-btn fab small class="ml-2 mr-0" color="primary" @click="sendMessage"><v-icon dark>send</v-icon></v-btn>
              </v-flex>
            </v-layout>
          </form>
        </v-flex>
      </v-layout>
    </v-layout>
    <v-dialog v-model="hidden" max-width="280px">
      <v-card>
        <v-card-text>
          <div class="text-xl-center text-lg-center text-sm-center text-md-center text-xs-center">
            <div v-if="chat != null && metadata.role != null">
              <v-list subheader>
                <v-list-tile>
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Topic</v-list-tile-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile style="margin-top:-15px;">
                  <v-list-tile-content>
                    <v-list-tile-sub-title style="white-space: normal!important;"><p class="body-1 mt-1">{{ chat.topic }}</p></v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile class="mt-1">
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Timestamp</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ new Date(chat.timestamp).toLocaleString() }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile class="mt-1">
                  <v-list-tile-avatar size="40" color="grey" v-if="chat.assigned_user != false && assigned_user != null && assigned_user != undefined">
                    <img v-if="assigned_user.photoUrl != null" :src="assigned_user.photoUrl">
                    <v-icon v-if="assigned_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                  </v-list-tile-avatar>
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Supervisor</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ assigned_user != null ? assigned_user.name : 'TBA' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile class="mt-1">
                  <v-list-tile-avatar size="40" color="grey" v-if="queue_user != null && queue_user != undefined">
                    <img v-if="queue_user.photoUrl != null" :src="queue_user.photoUrl">
                    <v-icon v-if="queue_user.photoUrl == null" size="50" color="white">account_circle</v-icon>
                  </v-list-tile-avatar>
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Client</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ queue_user != null ? queue_user.name : '-' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile v-if="queue_user_private != null && metadata.role == 1" class="mt-1">
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">Client Status</v-list-tile-title>
                    <v-list-tile-sub-title class="body-1">{{ queue_user_private.online != true ? `Last Seen ${new Date(queue_user_private.last_online).toLocaleString()}` : 'Online' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile><v-list-tile v-if="queue_user_private != null && metadata.role == 1" class="mt-1">
                  <v-list-tile-content>
                    <v-list-tile-title class="body-2">
                      Status
                      <v-icon v-if="chat.status != 0" color="error">lock</v-icon>
                      <v-icon v-if="chat.status == 0" color="success">lock_open</v-icon>
                    </v-list-tile-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-layout row>
                  <v-list-tile v-if="metadata.role == 1">
                    <v-list-tile-content>
                      <v-list-tile-sub-title class="body-1">
                        <v-switch class="mt-2 ml-3" v-model="chat.status == 0 ? false : true" @change="adminToggleStatus"></v-switch>
                      </v-list-tile-sub-title>
                    </v-list-tile-content>
                  </v-list-tile>
                  <v-spacer v-if="metadata.role == 1 && chat.status == 0"></v-spacer>
                  <v-layout v-if="metadata.role == 1 && chat.status == 0">
                    <v-btn color="error" block @click="adminDeleteQueue">
                      DELETE QUEUE
                    </v-btn>
                  </v-layout>
                </v-layout>
                <v-layout class="mt-1" v-if="user.uid == uid && chat.status == 0">
                  <v-btn block class="py-2" color="error" @click="exitQueue">
                    EXIT QUEUE
                  </v-btn>
                </v-layout>
                <v-layout class="mt-1" v-if="metadata.role == 1">
                  <v-btn block class="py-2" color="success" @click="adminNotifyClient">
                    NOTIFY CLIENT
                  </v-btn>
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
  import Api from '../../api'

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
      metadata () {
        return this.$store.getters.metadata
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
      .on('value', (userSnapshot) => {
        this.queue_user_private = userSnapshot.val()
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
          if (this.$store.getters.user.uid !== this.uid) {
            this.$router.push({ path: 'queue' })
          }
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
      enterQueue () {
        if (confirm('Are sure to enter queue list ?')) {
          this.$store.commit('setLoading', true)
          this.$store.commit('clearError')
          firebase.auth().currentUser.getIdToken(true)
          .then((idToken) => {
            return Api.enterQueue({ 'token': idToken, 'topic': this.topic })
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
        if (this.message.length > 0) {
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
        }
      },
      exitQueue () {
        if (confirm('Are sure to exit from queue list ?')) {
          this.$store.commit('setLoading', true)
          firebase.auth().currentUser.getIdToken(true)
          .then((idToken) => {
            return Api.exitQueue({ 'token': idToken })
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
      adminToggleStatus () {
        const status = { status: (this.chat.status === 0 ? 1 : 0) }
        firebase.database().ref('chats/' + this.uid).update(status)
        .then(() => {
          firebase.database().ref('queues/' + this.uid).update(status)
        })
        .catch((error) => {
          this.$store.commit('setError', error)
        })
      },
      adminNotifyClient () {
        this.$store.commit('setLoading', true)
        firebase.auth().currentUser.getIdToken(true)
        .then((idToken) => {
          return Api.adminNotifyClient({ 'token': idToken, 'queue': this.uid })
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
      },
      adminDeleteQueue () {
        if (confirm('Are sure to remove this chat from queue list ?')) {
          this.$store.commit('setLoading', true)
          firebase.auth().currentUser.getIdToken(true)
          .then((idToken) => {
            return Api.adminDeleteQueue({ 'token': idToken, 'queue': this.uid })
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

<style lang="stylus">
  .chat-box {
    max-width: 140px!important;
  }
  @media (min-width: 768px) {
    .chat-box {
      max-width: 270px!important;
    }
  }
</style>
