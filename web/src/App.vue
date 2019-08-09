<template>
  <v-app>
    <v-navigation-drawer fixed temporary touchless v-model="sideNav">
      <v-toolbar flat class="primary">
        <v-list class="pa-0">
          <v-list-tile avatar>
            <v-list-tile-avatar size="40" color="white">
              <img v-if="userIsAuthenticated && $store.getters.user.photoUrl != null" :src="$store.getters.user.photoUrl">
              <v-icon size="49" v-if="userIsAuthenticated && $store.getters.user.photoUrl == null">account_circle</v-icon>
              <v-icon size="49" v-if="!userIsAuthenticated">account_circle</v-icon>
            </v-list-tile-avatar>
            <v-list-tile-content>
              <v-list-tile-title class="white--text">{{ userIsAuthenticated ? $store.getters.user.name : 'Hi, Guest' }}</v-list-tile-title>
              <v-list-tile-sub-title class="white--text">{{ userIsAuthenticated ? $store.getters.user.email : 'Please sign in' }}</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>
        </v-list>
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
        <router-link to="/" tag="span" style="cursor: pointer">FireFlutter</router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-xs-only">
        <v-toolbar class="primary font-weight-bold text-uppercase" flat>
          <v-avatar :tile="false" :size="49" color="grey lighten-4">
            <img v-if="userIsAuthenticated && $store.getters.user.photoUrl != null" :src="$store.getters.user.photoUrl" alt="avatar">
            <v-icon v-if="userIsAuthenticated && $store.getters.user.photoUrl == null" left size="49">account_circle</v-icon>
            <v-icon v-if="!userIsAuthenticated" left size="49">account_circle</v-icon>
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
        sideNav: false
      }
    },
    computed: {
      menuItems () {
        let menuItems = [
          {icon: 'exit_to_app', title: 'Sign in', link: '/signin'},
          {icon: 'person_add', title: 'Sign up', link: '/signup'},
          {icon: 'lock_open', title: 'Reset Password', link: '/reset-password'}
        ]
        if (this.userIsAuthenticated) {
          menuItems = [
            {icon: 'person', title: 'Profile', link: '/profile'}
          ]
        }
        return menuItems
      },
      userIsAuthenticated () {
        return this.$store.getters.user !== null && this.$store.getters.user !== undefined
      },
      loading () {
        return this.$store.getters.loading
      }
    },
    methods: {
      onLogout () {
        this.$store.dispatch('logout')
        this.$router.push('/')
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
