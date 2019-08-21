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
          <v-card class="mb-2" :key="i" v-for="(chat, i) in queues">
            <v-card-text>
              {{ JSON.stringify(chat, null, 2) }}
              <v-btn flat @click.prevent="$router.push({ path: 'chat', query: { id: i } })">
                {{ i }}
              </v-btn>
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
      ref.on('value', (dataSnapshot) => {
        this.queues = dataSnapshot.val()
        console.log(dataSnapshot.val())
      })
    },
    methods: {
      // onDismissed () {
        // this.$store.dispatch('clearError')
      // }
    }
  }
</script>
