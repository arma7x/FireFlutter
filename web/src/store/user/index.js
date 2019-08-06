import * as firebase from 'firebase'
import axios from 'axios'

export default {
  state: {
    user: null
  },
  mutations: {
    setUser (state, payload) {
      state.user = payload
    }
  },
  actions: {
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
        commit('setUser', newUser)
        console.log(userNow)
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
        return axios.get(`https://us-central1-${firebase.apps[0].options.projectId}.cloudfunctions.net/selfDestructAccount`, { params: { 'token': idToken } })
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
            dispatch('signUserInCustomToken')
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
            dispatch('signUserInCustomToken')
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
    signUserInCustomToken ({commit}) {
      commit('setLoading', true)
      commit('clearError')
      firebase.auth().currentUser.getIdToken(true)
      .then((idToken) => {
        return axios.get(`https://us-central1-${firebase.apps[0].options.projectId}.cloudfunctions.net/verifyAdmin`, { params: { 'token': idToken } })
      })
      .then((response) => {
        return firebase.auth().signInWithCustomToken(response.data.token)
      })
      .then(
        data => {
          commit('setLoading', false)
          location.reload()
        }
      )
      .catch(
        () => {
          commit('setLoading', false)
        }
      )
    },
    autoSignIn ({commit}, payload) {
      commit('setUser', {
        uid: payload.uid,
        name: payload.name,
        email: payload.email,
        photoUrl: payload.photoUrl,
        admin: payload.admin || false
      })
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
    logout ({commit, dispatch, state}) {
      dispatch('removeActiveDevice', {uid: state.user.uid})
      firebase.auth().signOut()
      commit('setUser', null)
    }
  },
  getters: {
    user (state) {
      return state.user
    }
  }
}
