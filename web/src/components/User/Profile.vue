<template>
  <v-container>
  <v-layout>
    <v-flex xs12 sm6 offset-sm3>
      <v-card>
        <v-card-text>
          <div class="text-md-center">
            <v-icon large color="green darken-2">check_circle</v-icon>
              <h1 class="green--text">Login Success</h1>
              <h4 class="headline mb-0"><b class="red--text">UID :</b> {{ user !== undefined && user !== null ? user.uid : ''  }}</h4>
              <h4 class="headline mb-0"><b class="red--text">Name :</b> {{ user !== undefined && user !== null ? user.name : '' }}</h4>
              <h4 class="headline mb-0"><b class="red--text">Email :</b> {{ user !== undefined && user !== null ? user.email : '' }}</h4>
              <p>{{ JSON.stringify(user, null, 2) }}</p>
              <v-btn @click="updateUserProfile">Update Profile</v-btn>
              <v-btn @click="selfDestructAccount">self-Destruct Account</v-btn>
          </div>
        </v-card-text>
     </v-card>
    </v-flex>
  </v-layout>
  </v-container>
</template>

<script>
  import * as firebase from 'firebase'

  export default {
    computed: {
      user () {
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
        this.$store.dispatch('updateUserProfile', { 'displayName': 'Abu Dalo' })
      },
      selfDestructAccount () {
        this.$store.dispatch('selfDestructAccount')
        this.$router.push('/')
      }
    }
  }
</script>
