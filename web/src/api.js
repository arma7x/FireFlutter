import axios from 'axios'
import Config from './config'

export default class Api {

  static SELF_DESTRUCT_ACCOUNT = 'selfDestructAccount'
  static ENTER_QUEUE = 'enterQueue'
  static EXIT_QUEUE = 'exitQueue'
  static ADMIN_DELETE_QUEUE = 'adminDeleteQueue'
  static ADMIN_NOTIFY_CLIENT = 'adminNotifyClient'

  static selfDestructAccount (params) {
    return axios.get(`https://us-central1-${Config.firebase.projectId}.cloudfunctions.net/${this.SELF_DESTRUCT_ACCOUNT}`, { params: params })
  }

  static enterQueue (params) {
    return axios.get(`https://us-central1-${Config.firebase.projectId}.cloudfunctions.net/${this.ENTER_QUEUE}`, { params: params })
  }

  static exitQueue (params) {
    return axios.get(`https://us-central1-${Config.firebase.projectId}.cloudfunctions.net/${this.EXIT_QUEUE}`, { params: params })
  }

  static adminDeleteQueue (params) {
    return axios.get(`https://us-central1-${Config.firebase.projectId}.cloudfunctions.net/${this.ADMIN_DELETE_QUEUE}`, { params: params })
  }

  static adminNotifyClient (params) {
    return axios.get(`https://us-central1-${Config.firebase.projectId}.cloudfunctions.net/${this.ADMIN_NOTIFY_CLIENT}`, { params: params })
  }

}
