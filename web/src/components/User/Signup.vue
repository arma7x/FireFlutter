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
              <v-container>
                <form @submit.prevent="onSignup">
                  <v-layout row>
                    <v-flex xs12>
                      <v-text-field
                        name="email"
                        label="Email"
                        id="email"
                        v-model="email"
                        type="email"
                        required></v-text-field>
                    </v-flex>
                  </v-layout>
                  <v-layout row>
                    <v-flex xs12>
                      <v-text-field
                        name="password"
                        label="Password"
                        id="password"
                        v-model="password"
                        v-bind:type="visible ? 'text' : 'password'"
                        required></v-text-field>
                    </v-flex>
                  </v-layout>
                  <v-layout row>
                    <v-flex xs12>
                      <v-text-field
                        name="confirmPassword"
                        label="Confirm Password"
                        id="confirmPassword"
                        v-model="confirmPassword"
                        v-bind:type="visible ? 'text' : 'password'"
                        :append-icon="visible ? 'visibility_off' : 'visibility'"
                        @click:append="() => (visible = !visible)"
                        :rules="[comparePasswords]"
                        required></v-text-field>
                    </v-flex>
                  </v-layout>
                  <v-layout row>
                    <v-flex xs12>
                      <div class="text-xs-center">
                      <v-btn block type="submit" :disabled="loading" :loading="loading">
                        Sign up
                        <v-icon right>send</v-icon>
                        <span slot="loader" class="custom-loader">
                          <v-icon light>cached</v-icon>
                         </span>
                      </v-btn>
                      </div>
                      <div class="text-xs-center">
                        <v-btn block color="red" dark :disabled="loading" :loading="loading" @click.prevent="onSigninGoogle">Login with Google
                          <v-icon right dark>lock_open</v-icon>
                          <span slot="loader" class="custom-loader">
                          <v-icon light>cached</v-icon>
                         </span>
                        </v-btn>
                      </div>
                      <!-- <div class="text-xs-center">
                        <v-btn block color="primary" dark :disabled="loading" :loading="loading" @click.prevent="onSigninFacebook">Login with Facebook
                          <v-icon right dark>lock_open</v-icon>
                          <span slot="loader" class="custom-loader">
                          <v-icon light>cached</v-icon>
                         </span>
                        </v-btn>
                      </div>
                      <div class="text-xs-center">
                        <v-btn block dark :disabled="loading" :loading="loading" @click.prevent="onSigninGithub">Login with Github
                          <v-icon right dark>lock_open</v-icon>
                          <span slot="loader" class="custom-loader">
                          <v-icon light>cached</v-icon>
                         </span>
                        </v-btn>
                      </div>
                      <div class="text-xs-center">
                        <v-btn block color="info" dark :disabled="loading" :loading="loading" @click.prevent="onSigninTwitter">Login with Twitter
                          <v-icon right dark>lock_open</v-icon>
                          <span slot="loader" class="custom-loader">
                          <v-icon light>cached</v-icon>
                         </span>
                        </v-btn>
                      </div> -->
                    </v-flex>
                  </v-layout>
                </form>
              </v-container>
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    data () {
      return {
        email: '',
        password: '',
        confirmPassword: '',
        visible: false
      }
    },
    computed: {
      comparePasswords () {
        if (this.password.length < 8 || this.confirmPassword.length < 8) {
          return 'Minimum length is 8 characters'
        }
        return this.password !== this.confirmPassword ? 'Passwords do not match' : false
      },
      user () {
        return this.$store.getters.user
      },
      error () {
        return this.$store.getters.error
      },
      loading () {
        return this.$store.getters.loading
      }
    },
    watch: {
      user (value) {
        if (value !== null && value !== undefined) {
          this.$router.push('/profile')
        }
      }
    },
    methods: {
      onSignup () {
        if (this.password.length < 8 || this.confirmPassword.length < 8) {
          return 'Minimum length is 8 characters'
        }
        if (this.password !== this.confirmPassword) {
          return
        }
        this.$store.dispatch('signUserUp', {email: this.email, password: this.password})
      },
      onSigninGoogle () {
        this.$store.dispatch('signUserInGoogle')
      },
      onSigninFacebook () {
        this.$store.dispatch('signUserInFacebook')
      },
      onSigninGithub () {
        this.$store.dispatch('signUserInGithub')
      },
      onSigninTwitter () {
        this.$store.dispatch('signUserInTwitter')
      } // ,
      // onDismissed () {
        // this.$store.dispatch('clearError')
      // }
    }
  }
</script>
