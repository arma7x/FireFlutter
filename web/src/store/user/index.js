import * as firebase from 'firebase'
import axios from 'axios'
import Config from '../../config'

export default {
  state: {
    user: null,
    metadata: null
  },
  mutations: {
    setUser (state, payload) {
      state.user = payload
    },
    setMetadata (state, payload) {
      state.metadata = payload
    }
  },
  actions: {
    updateMetadata ({commit}, payload) {
      commit('setMetadata', payload)
    },
    updateUserProfile ({commit, state}, payload) {
      commit('setLoading', true)
      commit('clearError')
      const userNow = firebase.auth().currentUser
      userNow.updateProfile(payload)
      .then(() => {
        commit('setLoading', false)
        commit('clearError')
        const newUser = {
          uid: userNow.uid,
          name: userNow.displayName,
          email: userNow.email,
          photoUrl: userNow.photoURL
        }
        firebase.database().ref('/users_public/' + userNow.uid).set({
          'name': userNow.displayName || 'Unknown',
          'photoUrl': userNow.photoURL
        })
        commit('setUser', newUser)
        console.log(userNow.providerData[0].providerId)
        console.log(userNow)
        // userNow.reauthenticateAndRetrieveDataWithCredential(firebase.auth().signInWithPopup(new firebase.auth.GoogleAuthProvider()))
      })
      .catch((error) => {
        commit('setLoading', false)
        commit('setError', error)
        console.log(error)
      })
    },
    selfDestructAccount ({commit, dispatch, state}, payload) {
      commit('setLoading', true)
      firebase.auth().currentUser.getIdToken(true)
      .then((idToken) => {
        return axios.get(`https://us-central1-${Config.firebase.projectId}.cloudfunctions.net/selfDestructAccount`, { params: { 'token': idToken } })
      })
      .then((response) => {
        commit('setLoading', false)
        commit('clearError')
        firebase.auth().signOut()
        commit('setUser', null)
      })
      .catch((error) => {
        commit('setLoading', false)
        commit('setError', error)
        console.log(error)
      })
    },
    signUserUp ({commit, dispatch, state}, payload) {
      commit('setLoading', true)
      commit('clearError')
      firebase.auth().createUserWithEmailAndPassword(payload.email, payload.password)
        .then(
          user => {
            commit('setLoading', false)
            const newUser = {
              uid: user.user.uid,
              name: user.user.displayName,
              email: user.user.email,
              photoUrl: user.user.photoURL
            }
            commit('setUser', newUser)
            dispatch('addActiveDevice', {uid: state.user.uid})
          }
        )
        .catch(
          error => {
            commit('setLoading', false)
            commit('setError', error)
            console.log(error)
          }
        )
    },
    signUserIn ({commit, dispatch, state}, payload) {
      commit('setLoading', true)
      commit('clearError')
      firebase.auth().signInWithEmailAndPassword(payload.email, payload.password)
        .then(
          user => {
            commit('setLoading', false)
            const newUser = {
              uid: user.user.uid,
              name: user.user.displayName,
              email: user.user.email,
              photoUrl: user.user.photoURL
            }
            commit('setUser', newUser)
            dispatch('addActiveDevice', {uid: state.user.uid})
            dispatch('goOnline')
          }
        )
        .catch(
          error => {
            commit('setLoading', false)
            commit('setError', error)
            console.log(error)
          }
        )
    },
    signUserInGoogle ({commit, dispatch, state}) {
      commit('setLoading', true)
      commit('clearError')
      firebase.auth().signInWithPopup(new firebase.auth.GoogleAuthProvider())
        .then(
          user => {
            commit('setLoading', false)
            const newUser = {
              uid: user.user.uid,
              name: user.user.displayName,
              email: user.user.email,
              photoUrl: user.user.photoURL
            }
            commit('setUser', newUser)
            dispatch('addActiveDevice', {uid: state.user.uid})
            dispatch('goOnline')
          }
        )
        .catch(
          error => {
            commit('setLoading', false)
            commit('setError', error)
            console.log(error)
          }
        )
    },
    signUserInFacebook ({commit}) {
      commit('setLoading', true)
      commit('clearError')
      firebase.auth().signInWithPopup(new firebase.auth.FacebookAuthProvider())
        .then(
          user => {
            commit('setLoading', false)
            const newUser = {
              uid: user.user.uid,
              name: user.user.displayName,
              email: user.user.email,
              photoUrl: user.user.photoURL
            }
            commit('setUser', newUser)
          }
        )
        .catch(
          error => {
            commit('setLoading', false)
            commit('setError', error)
            console.log(error)
          }
        )
    },
    signUserInGithub ({commit}) {
      commit('setLoading', true)
      commit('clearError')
      firebase.auth().signInWithPopup(new firebase.auth.GithubAuthProvider())
        .then(
          user => {
            commit('setLoading', false)
            const newUser = {
              uid: user.user.uid,
              name: user.user.displayName,
              email: user.user.email,
              photoUrl: user.user.photoURL
            }
            commit('setUser', newUser)
          }
        )
        .catch(
          error => {
            commit('setLoading', false)
            commit('setError', error)
            console.log(error)
          }
        )
    },
    signUserInTwitter ({commit}) {
      commit('setLoading', true)
      commit('clearError')
      firebase.auth().signInWithPopup(new firebase.auth.TwitterAuthProvider())
        .then(
          user => {
            commit('setLoading', false)
            const newUser = {
              uid: user.user.uid,
              name: user.user.displayName,
              email: user.user.email,
              photoUrl: user.user.photoURL
            }
            commit('setUser', newUser)
          }
        )
        .catch(
          error => {
            commit('setLoading', false)
            commit('setError', error)
            console.log(error)
          }
        )
    },
    autoSignIn ({commit, dispatch}, payload) {
      commit('setUser', {
        uid: payload.uid,
        name: payload.name,
        email: payload.email,
        photoUrl: payload.photoUrl,
        admin: payload.admin || false
      })
      dispatch('goOnline')
    },
    resetPasswordWithEmail ({ commit }, payload) {
      const { email } = payload
      commit('setLoading', true)
      firebase.auth().sendPasswordResetEmail(email)
      .then(
        () => {
          commit('setLoading', false)
          console.log('Email Sent')
        }
      )
      .catch(
        error => {
          commit('setLoading', false)
          commit('setError', error)
          console.log(error)
        }
      )
    },
    goOnline ({state, dispatch}) {
      const onlineRef = firebase.database().ref('/users/' + state.user.uid + '/online')
      onlineRef.onDisconnect().set(false)
      onlineRef.set(true)
      const lastOnlineRef = firebase.database().ref('/users/' + state.user.uid + '/last_online')
      lastOnlineRef.onDisconnect().set(firebase.database.ServerValue.TIMESTAMP)
      lastOnlineRef.set(firebase.database.ServerValue.TIMESTAMP)
      firebase.database().ref('/users/' + state.user.uid)
      .on('value', (dataSnapshot) => {
        dispatch('updateMetadata', dataSnapshot.val())
      })
    },
    async goOffline ({state}) {
      await firebase.database().ref('/users/' + state.user.uid + '/online').set(false)
      await firebase.database().ref('/users/' + state.user.uid + '/last_online').set(firebase.database.ServerValue.TIMESTAMP)
    },
    logout ({commit, dispatch, state}) {
      dispatch('removeActiveDevice', {uid: state.user.uid})
      dispatch('goOffline')
      commit('setUser', null)
      commit('setMetadata', null)
      firebase.auth().signOut()
    }
  },
  getters: {
    user (state) {
      return state.user
    },
    metadata (state) {
      return state.metadata
    }
  }
}
