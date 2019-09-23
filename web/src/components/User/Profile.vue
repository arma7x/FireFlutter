<template>
  <v-container class="center-vertical">
    <v-layout column>
      <!-- <v-layout row v-if="error">
        <v-flex xs12 sm4 offset-sm4>
          <app-alert @dismissed="onDismissed" :text="error.message"></app-alert>
        </v-flex>
      </v-layout> -->
      <v-layout row>
        <v-flex xs12 sm4 offset-sm4>
          <v-card>
            <v-card-text>
              <div class="text-xl-center text-lg-center text-sm-center text-md-center text-xs-center">
                <v-avatar :tile="false" :size="100" color="grey lighten-4">
                  <img v-if="user.photoUrl != null" :src="user.photoUrl" alt="avatar">
                  <v-icon v-if="user.photoUrl == null" size="120">account_circle</v-icon>
                </v-avatar>
                <form @submit.prevent="updateUserAvatar" style="margin:-45px -70px 0 -0;">
                  <v-layout column style="display:flex;align-items:center;justify-content:center;">
                    <input id="avatar" style="display:none;" type="file" accept="image/*" />
                    <v-btn @click.prevent="clickFileUpload" small fab color="primary"><v-icon dark>camera_alt</v-icon></v-btn>
                  </v-layout>
                </form>
              </div>
              <v-list two-line subheader>
                <v-list-tile avatar>
                  <v-list-tile-content>
                    <v-list-tile-title>UID</v-list-tile-title>
                    <v-list-tile-sub-title>{{ user !== undefined && user !== null ? user.uid : ''  }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>
                    <v-list-tile-title>Name</v-list-tile-title>
                    <v-list-tile-sub-title>{{ user !== undefined && user !== null ? user.name : '' }}</v-list-tile-sub-title>
                    <form style="width:100%" @submit.prevent="updateUserName">
                      <v-layout row wrap>
                        <v-flex xs12>
                          <v-text-field
                            name="name"
                            label="Name"
                            id="name"
                            v-model="name"
                            type="text"
                            required></v-text-field>
                        </v-flex>
                      </v-layout>
                    </form>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>
                    <v-list-tile-title>Email</v-list-tile-title>
                    <v-list-tile-sub-title>{{ user !== undefined && user !== null ? user.email : '' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>
                    <v-list-tile-title>Admin</v-list-tile-title>
                    <v-list-tile-sub-title>{{ metadata !== undefined && metadata !== null ? (metadata.role === 1 ? 'TRUE' : 'FALSE') : '' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
              </v-list>
              <v-btn block class="info" @click="updateUserName">UPDATE PROFILE</v-btn>
              <v-btn block class="error" @click="selfDestructAccount">SELF-DESTRUCT ACCOUNT</v-btn>
            </v-card-text>
         </v-card>
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
        name: ''
      }
    },
    computed: {
      user () {
        this.name = this.$store.getters.user.name
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
      document.querySelector('#avatar').addEventListener('change', this.updateUserAvatar)
    },
    methods: {
      clickFileUpload () {
        document.querySelector('#avatar').click()
      },
      updateUserAvatar (e) {
        if (e.target.files.length > 0) {
          this.$store.commit('setLoading', true)
          const storageRef = firebase.storage()
          const path = `/user/${this.$store.getters.user.uid}/avatar/${e.target.files[0].name}`
          const uploadTask = storageRef.ref(path).put(e.target.files[0])
          uploadTask.on('state_changed', (snapshot) => {
            console.log(snapshot)
          }, (error) => {
            this.$store.commit('setError', error)
            this.$store.commit('setLoading', false)
            console.log(error)
          }, () => {
            storageRef.ref(path).getDownloadURL()
            .then((url) => {
              this.$store.commit('setLoading', false)
              this.$store.dispatch('updateUserProfile', { 'photoURL': url })
            }).catch((error) => {
              this.$store.commit('setError', error)
              this.$store.commit('setLoading', false)
            })
          })
        }
      },
      updateUserName () {
        this.$store.dispatch('updateUserProfile', { 'displayName': this.name })
      },
      selfDestructAccount () {
        const prompt = confirm('Confirm to delete your account ?')
        if (prompt) {
          this.$store.dispatch('selfDestructAccount')
          this.$router.push('/')
        }
      } // ,
      // onDismissed () {
        // this.$store.dispatch('clearError')
      // }
    }
  }
</script>
