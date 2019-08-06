export function makeid (length) {
  let result = ''
  const characters = '_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  const charactersLength = characters.length
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength))
  }
  return result
}

export function deconstructJWT (token) {
  const segments = token.split('.')
  if (segments.length !== 3) {
    throw new Error('Invalid JWT')
  }
  const claims = segments[1]
  return JSON.parse(decodeURIComponent(escape(window.atob(claims))))
}
