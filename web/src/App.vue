<template>
  <v-app>
    <v-layout class="primary" style="flex:none!important" row v-if="error">
      <v-flex xs12>
        <app-alert class="my-0 mx-0" @dismissed="onDismissed" :text="error.message"></app-alert>
      </v-flex>
    </v-layout>
    <v-navigation-drawer fixed temporary :touchless="touchless" v-model="sideNav" width="280">
      <v-toolbar flat class="primary" height="150">
        <v-layout class="mx-0 px-0" style="margin-left:-12px!important;" column>
          <v-list class="pa-0">
            <v-list-tile avatar>
              <v-list-tile-avatar size="60" color="primary" v-if="userIsAuthenticated && $store.getters.user">
                <img v-if="$store.getters.user.photoUrl != null" :src="$store.getters.user.photoUrl">
                <v-icon size="69" color="white" v-if="$store.getters.user.photoUrl == null">account_circle</v-icon>
              </v-list-tile-avatar>
              <v-list-tile-avatar size="60" color="primary" v-if="!userIsAuthenticated">
                <v-icon size="69" color="white">account_circle</v-icon>
              </v-list-tile-avatar>
            </v-list-tile>
          </v-list>
          <v-list class="pa-0 mt-2">
            <v-list-tile>
              <v-list-tile-content>
                <v-list-tile-title class="body-2 white--text">{{ userIsAuthenticated ? $store.getters.user.name : 'Hi, Guest' }}</v-list-tile-title>
                <v-list-tile-sub-title class="white--text">{{ userIsAuthenticated ? $store.getters.user.email : 'Please sign in' }}</v-list-tile-sub-title>
              </v-list-tile-content>
            </v-list-tile>
          </v-list>
        </v-layout>
      </v-toolbar>
      <v-list>
        <v-list-tile
          v-for="item in menuItems"
          :key="item.title"
          :to="item.link">
          <v-list-tile-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>{{ item.title }}</v-list-tile-content>
        </v-list-tile>
        <v-list-tile
          v-if="userIsAuthenticated"
          @click="onLogout">
          <v-list-tile-action>
            <v-icon>exit_to_app</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>Logout</v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar dark class="primary">
      <v-toolbar-side-icon
        @click.stop="sideNav = !sideNav"
        class="hidden-sm-and-up "></v-toolbar-side-icon>
      <v-toolbar-title>
        <router-link to="/" tag="span" style="cursor: pointer">{{ app_name }}<v-icon right v-if="offline">wifi_off</v-icon></router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-xs-only">
        <v-toolbar class="primary font-weight-bold text-uppercase" flat>
          <v-avatar v-if="userIsAuthenticated && $store.getters.user" :tile="false" :size="49" color="transparent" style="margin-right:5px;">
            <img v-if="$store.getters.user.photoUrl != null" :src="$store.getters.user.photoUrl" alt="avatar">
            <v-icon v-if="$store.getters.user.photoUrl == null" size="60">account_circle</v-icon>
          </v-avatar>
          <v-avatar v-if="!userIsAuthenticated" :tile="false" :size="49" color="transparent" style="margin-right:5px;">
            <v-icon size="60">account_circle</v-icon>
          </v-avatar>
          {{ userIsAuthenticated ? $store.getters.user.name : 'Hi, Guest' }}
        </v-toolbar>
        <v-btn
          flat
          v-for="item in menuItems"
          :key="item.title"
          :to="item.link">
          <v-icon left dark>{{ item.icon }}</v-icon>
          {{ item.title }}
        </v-btn>
        <v-btn
          v-if="userIsAuthenticated"
          flat
          @click="onLogout">
          <v-icon left dark>exit_to_app</v-icon>
          Logout
        </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    <main>
      <router-view></router-view>
      <v-dialog v-model="loading" :persistent="true" max-width="64px">
        <v-layout justify-center flat>
          <v-card>
            <v-card-title>
              <v-progress-circular indeterminate color="primary"></v-progress-circular>
            </v-card-title>
          </v-card>
        </v-layout>
      </v-dialog>
    </main>
  </v-app>
</template>

<script>
  export default {
    data () {
      return {
        app_name: window.APP_NAME,
        touchless: false,
        sideNav: false
      }
    },
    computed: {
      menuItems () {
        let menuItems = [
          {icon: 'exit_to_app', title: 'Sign in', link: '/signin'},
          {icon: 'person_add', title: 'Sign up', link: '/signup'},
          {icon: 'lock_open', title: 'Reset Password', link: '/resetpassword'}
        ]
        if (this.userIsAuthenticated) {
          menuItems = [
            {icon: 'person', title: 'Profile', link: '/profile'}
          ]
          if (this.$store.getters.metadata !== null && this.$store.getters.metadata !== undefined) {
            if (this.$store.getters.metadata.role !== 1) {
              menuItems = [...menuItems, {icon: 'live_help', title: 'Chat', link: '/chat'}]
            }
            if (this.$store.getters.metadata.role === 1) {
              menuItems = [...menuItems, {icon: 'traffic', title: 'Queue', link: '/queue'}]
            }
          }
        }
        return menuItems
      },
      userIsAuthenticated () {
        return this.$store.getters.user !== null && this.$store.getters.user !== undefined
      },
      loading () {
        return this.$store.getters.loading
      },
      error () {
        return this.$store.getters.error
      },
      offline () {
        return this.$store.getters.offline
      }
    },
    methods: {
      onLogout () {
        this.$store.dispatch('logout')
        this.$router.push('/')
      },
      onDismissed () {
        this.$store.dispatch('clearError')
      }
    }
  }
</script>

<style lang="stylus">
  @import './stylus/main'
  .center-vertical {
    min-height: 90vh;
    display: flex;
    align-items: center;
    justify-content: center;
  }
</style>
