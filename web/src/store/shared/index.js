import * as firebase from 'firebase'

export default {
  state: {
    offline: false,
    client_id: '',
    fcm: '',
    loading: false,
    error: null
  },
  mutations: {
    setOffline (state, payload) {
      state.offline = payload
    },
    setClientId (state, payload) {
      state.client_id = payload
    },
    setFcm (state, payload) {
      state.fcm = payload
    },
    setLoading (state, payload) {
      state.loading = payload
    },
    setError (state, payload) {
      state.error = payload
    },
    clearError (state) {
      state.error = null
    }
  },
  actions: {
    setClientId ({commit}, payload) {
      commit('setClientId', payload)
    },
    setFcm ({commit}, payload) {
      commit('setFcm', payload)
    },
    clearError ({commit}) {
      commit('clearError')
    },
    setError ({commit}, payload) {
      commit('setError', payload)
    },
    addActiveDevice ({commit, state}, payload) {
      const deviceInfo = {
        client: window.navigator.userAgent,
        datetime: new Date().getTime(),
        fcm: state.fcm
      }
      firebase.database().ref('/users/' + payload.uid + '/devices').set({[state.client_id]: deviceInfo})
    },
    async removeActiveDevice ({commit, state}, payload) {
      await firebase.database().ref('/users/' + payload.uid + '/devices').child(state.client_id).remove()
    }
  },
  getters: {
    offline (state) {
      return state.offline
    },
    client_id (state) {
      return state.client_id
    },
    fcm (state) {
      return state.fcm
    },
    loading (state) {
      return state.loading
    },
    error (state) {
      return state.error
    }
  }
}
