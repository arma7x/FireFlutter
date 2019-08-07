<template>
  <v-container class="center-vertical">
    <v-layout column>
      <v-layout>
        <v-flex xs12 sm4 offset-sm4>
          <v-card>
            <v-card-text>
              <div class="text-xl-center text-lg-center text-sm-center text-md-center text-xs-center">
                <v-avatar v-if="$store.getters.user.photoUrl != null" :tile="false" :size="100" color="grey lighten-4">
                  <img :src="$store.getters.user.photoUrl" alt="avatar">
                </v-avatar>
                <v-icon left size="100" v-if="$store.getters.user.photoUrl == null">account_circle</v-icon>
              </div>
              <v-list two-line subheader>
                <v-list-tile avatar>
                  <v-list-tile-content>
                    <v-list-tile-title>UID</v-list-tile-title>
                    <v-list-tile-sub-title>{{ user !== undefined && user !== null ? user.uid : ''  }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile avatar>
                  <v-list-tile-content>
                    <v-list-tile-title>Name</v-list-tile-title>
                    <v-list-tile-sub-title>{{ user !== undefined && user !== null ? user.name : '' }}</v-list-tile-sub-title>
                    <form style="width:100%" @submit.prevent="updateUserProfile">
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
                <v-list-tile avatar>
                  <v-list-tile-content>
                    <v-list-tile-title>Email</v-list-tile-title>
                    <v-list-tile-sub-title>{{ user !== undefined && user !== null ? user.email : '' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
                <v-list-tile avatar>
                  <v-list-tile-content>
                    <v-list-tile-title>Admin</v-list-tile-title>
                    <v-list-tile-sub-title>{{ user !== undefined && user !== null ? user.admin.toString().toLocaleUpperCase() : '' }}</v-list-tile-sub-title>
                  </v-list-tile-content>
                </v-list-tile>
              </v-list>
              <v-btn block class="info" @click="updateUserProfile">Update Profile</v-btn>
              <v-btn block class="error" @click="selfDestructAccount">self-Destruct Account</v-btn>
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
      }
    },
    mounted () {
      const db = firebase.database()
      const ref = db.ref('users/' + this.$store.getters.user.uid)
      ref.once('value')
      .then((dataSnapshot) => {
        console.log(dataSnapshot.val())
      })
    },
    methods: {
      updateUserProfile () {
        this.$store.dispatch('updateUserProfile', { 'displayName': this.name })
      },
      selfDestructAccount () {
        const prompt = confirm('Confirm to delete your account ?')
        if (prompt) {
          this.$store.dispatch('selfDestructAccount')
          this.$router.push('/')
        }
      }
    }
  }
</script>
