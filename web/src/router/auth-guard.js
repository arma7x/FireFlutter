import {store} from '../store'

export function requireAuth (to, from, next) {
  if (store.getters.user) {
    next()
  } else {
    next('/signin')
  }
}

export function avoidAuth (to, from, next) {
  if (store.getters.user) {
    next('/')
  } else {
    next()
  }
}
