<template>
  <v-container class="center-vertical">
    <v-layout column>
      <v-layout row v-if="error">
        <v-flex>
          <app-alert @dismissed="onDismissed" :text="error.message"></app-alert>
        </v-flex>
      </v-layout>
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
                    <v-list-tile>
                      <v-list-tile-content>
                        <v-list-tile-title class="body-2">Topic</v-list-tile-title>
                        <v-list-tile-sub-title class="caption">{{ chat.topic }}</v-list-tile-sub-title>
                      </v-list-tile-content>
                    </v-list-tile>
                    <v-layout row>
                      <v-list-tile>
                        <v-list-tile-content>
                          <v-list-tile-title class="body-2">Status</v-list-tile-title>
                          <v-list-tile-sub-title class="caption">{{ chat.status }}</v-list-tile-sub-title>
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
                    <v-list-tile>
                      <v-list-tile-content>
                        <v-list-tile-title class="body-2">Assigned User</v-list-tile-title>
                        <v-list-tile-sub-title class="caption">{{ chat.assigned_user }}</v-list-tile-sub-title>
                      </v-list-tile-content>
                    </v-list-tile>
                  </v-list>
                </div>
              </div>
            </v-card-text>
         </v-card>
        </v-flex>
        <v-flex class="pl-2 pr-2">
          <v-card>
            <v-card-text class="blue-grey lighten-5">
              <div v-if="chat != null">
                <v-list class="blue-grey lighten-5">
                  <v-container class="mx-0 my-0 px-0 py-0 scroll-y" style="height:60vh;" ref="chat_scroller">
                    <v-layout v-if="chat.logs != undefined" column>
                      <v-list two-line disabled class="blue-grey lighten-5">
                        <v-list-tile :key="i" class="mb-2" v-for="(msg, i) in chat.logs">
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
                        ></v-textarea>
                      </v-flex>
                      <v-flex xs2>
                      <v-btn fab small color="info" @click="sendMessage"><v-icon dark>send</v-icon></v-btn>
                      </v-flex>
                    </v-layout>
                  </form>
                </v-list>
              </div>
            </v-card-text>
         </v-card>
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
        chat: null
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
      const ref = db.ref('chats/' + this.$store.getters.user.uid)
      ref.on('value', (dataSnapshot) => {
        this.chat = dataSnapshot.val()
      })
      const ref2 = db.ref('queues')
      ref2.on('value', (dataSnapshot) => {
        console.log(dataSnapshot.val())
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
          console.log(response)
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
        firebase.database().ref('/chats/' + this.$store.getters.user.uid + '/logs').push(data)
        .then(() => {
          this.message = null
          this.$store.commit('clearError')
        })
        .catch((error) => {
          this.$store.commit('setError', error)
        })
      },
      onDismissed () {
        this.$store.dispatch('clearError')
      }
    }
  }
</script>
