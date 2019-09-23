// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here, other Firebase libraries
// are not available in the service worker.
importScripts('/service-worker.js?version=1569231947400');
importScripts('/firebase-app.js');
importScripts('/firebase-messaging.js');

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
