// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here, other Firebase libraries
// are not available in the service worker.
importScripts('/service-worker.js');
importScripts('/firebase-app.js');
importScripts('/firebase-messaging.js');

addEventListener("fetch", function(e) {
  const CACHE_NAME = "CROSS_ORIGIN"
  e.respondWith((async function() {
    const cache = await caches.open(CACHE_NAME);
    const cachedResponse = await cache.match(e.request);
    if (cachedResponse) {
      return cachedResponse;
    }

    const clonedReq = e.request.clone();
    const networkResponse = await fetch(clonedReq, {'mode':'no-cors'});

    const hosts = [
      'https://fonts.googleapis.com',
      'https://fonts.gstatic.com',
    ];

    if (hosts.some((host) => e.request.url.startsWith(host))) {
      // This clone() happens before 'return networkResponse' 
      const clonedResponse = networkResponse.clone();

      e.waitUntil((async function() {
        const cache = await caches.open(CACHE_NAME);
        // This will be called after 'return networkResponse'
        // so make sure you already have the clone!
        await cache.put(e.request, clonedResponse);
      })());
    }

    return networkResponse;
  })());
});

// Initialize the Firebase app in the service worker by passing in the
// messagingSenderId.
firebase.initializeApp({
  'messagingSenderId': '436808076830'
});

firebase.messaging().setBackgroundMessageHandler(function(payload) {
  console.log('Message received::', payload.notification);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/static/img/icons/android-chrome-192x192.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
