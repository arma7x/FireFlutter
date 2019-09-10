import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as cors from 'cors';

const serviceAccount = require('../service_account.json');
const LEVEL = {
  ADMIN: 1,
  MEMBER: 999
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://fireflutter-f1304.firebaseio.com'
});

export const selfDestructAccount = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const token = request.query.token || 'string';
  let uid:string;
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    uid = decodedToken.uid
    console.log('/users/' + uid)
    return admin.auth().deleteUser(uid);
  })
  .then(() => {
    return admin.database().ref('/users').child(uid).remove()
  })
  .then(() => {
    return admin.database().ref('/users_public').child(uid).remove()
  })
  .then(() => {
    corsFn(request, response, () => {
      response.status(200).json({ 'message': 'Your account was deleted' });
    });
  })
  .catch((error) => {
    corsFn(request, response, () => {
      response.status(400).json(error);
    });
  });
});

export const joinQueue = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const token = request.query.token || 'string';
  let uid:string;
  let chatRef:admin.database.Reference;
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    uid = decodedToken.uid;
    if (request.query.topic === undefined || request.query.topic === null) {
      return Promise.reject({ 'message': 'Please enter topic of discussion' });
    }
    chatRef = admin.database().ref('/chats/' + uid);
    return chatRef.once('value');
  })
  .then((snapshot) => {
    if (snapshot.exists()) {
      return Promise.reject({ 'message': 'Already in queue' });
    } else {
      return admin.database().ref('/queues/' + uid).set({
        "topic": request.query.topic,
        "timestamp": new Date().getTime(),
        "status": 0,
        "assigned_user": false
      });
    }
  })
  .then(() => {
    console.log("SEND NOTIFICATION TO ADMIN");
    const adminsRef = admin.database().ref('/users').orderByChild('role').equalTo(1)
    adminsRef.once('value')
    .then((snapshots) => {
      const regFCMTokens = []
      for (const k in snapshots.val()) {
        if (snapshots.val()[k]['devices']) {
          for (const i in snapshots.val()[k]['devices']) {
            regFCMTokens.push(snapshots.val()[k]['devices'][i]['fcm'])
          }
        }
      }
      if (regFCMTokens.length > 0) {
        const payload = {
          notification: {
            title: 'Chat Queue',
            body : 'New user waiting in queue list'
          }
        };
        console.log(regFCMTokens);
        admin.messaging().sendToDevice(regFCMTokens, payload)
        .then((success) => {
          console.log(success);
        })
        .catch((error) => {
          console.log(error);
        });
      } else {
        console.log("NO ADMIN LOGGED IN");
      }
    })
    .catch((error) => {
      console.log(error);
    });
    return chatRef.set({
      "topic": request.query.topic,
      "timestamp": new Date().getTime(),
      "status": 0,
      "assigned_user": false
    });
  })
  .then(() => {
    corsFn(request, response, () => {
      response.status(200).json({ 'message': 'Your have joined queued' });
    });
  })
  .catch((error) => {
    corsFn(request, response, () => {
      response.status(400).json(error);
    });
  });
});

export const deleteQueue = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const token = request.query.token || 'string';
  let uid:string;
  let chatRef:admin.database.Reference;
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    uid = decodedToken.uid;
    chatRef = admin.database().ref('/chats/' + uid);
    return chatRef.once('value');
  })
  .then((snapshot) => {
    if (!snapshot.exists()) {
      return Promise.reject({ 'message': 'Queue does not exist' });
    } else if(snapshot.val().status === 1) {
      return Promise.reject({ 'message': 'Your queues is active' });
    } else {
      return admin.database().ref('/queues/' + uid).remove();
    }
  })
  .then(() => {
    return chatRef.remove();
  })
  .then(() => {
    corsFn(request, response, () => {
      response.status(200).json({ 'message': 'Succesfully remove your chat from queue list' });
    });
  })
  .catch((error) => {
    corsFn(request, response, () => {
      response.status(400).json(error);
    });
  });
});

export const adminNotifyClient = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const queue = request.query.queue;
  const token = request.query.token || 'string';
  let uid:string;
  if (queue === null || queue ===  undefined) {
    corsFn(request, response, () => {
      response.status(400).json({ 'message': 'Queue id is required' });
    });
  }
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    uid = decodedToken.uid;
    const adminRef = admin.database().ref('/users/' + uid).child('role');
    return adminRef.once('value');
  })
  .then((snapshot) => {
    if (snapshot.val() !== LEVEL.ADMIN) {
      return Promise.reject({ 'message': 'Permission denied' });
    }
    const chatRef = admin.database().ref('/chats/' + queue);
    return chatRef.once('value')
  })
  .then((snapshotChat) => {
    if (!snapshotChat.exists()) {
      return Promise.reject({ 'message': 'Queue does not exist' });
    } else {
      const clientRef = admin.database().ref('/users/' + queue)
      return clientRef.once('value')
    }
  })
  .then((snapshotClient) => {
    console.log("SEND NOTIFICATION TO CLIENT");
    const regFCMTokens = []
    if (snapshotClient.val()['devices']) {
      for (const i in snapshotClient.val()['devices']) {
        regFCMTokens.push(snapshotClient.val()['devices'][i]['fcm'])
      }
    }
    if (regFCMTokens.length > 0) {
      const payload = {
        notification: {
          title: 'Chat',
          body : 'Admin is ready to chat with you'
        }
      };
      console.log(regFCMTokens);
      return admin.messaging().sendToDevice(regFCMTokens, payload)
    } else {
      console.log("NO ACTIVE CLIENT");
      return Promise.reject({ 'message': 'Client does not logged-in in any device' });
    }
  })
  .then((success) => {
    console.log(success);
    corsFn(request, response, () => {
      response.status(200).json({ 'message': 'Succesfully send notification to client' });
    });
  })
  .catch((error) => {
    corsFn(request, response, () => {
      response.status(400).json(error);
    });
  });
});

export const adminDeleteQueue = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const queue = request.query.queue;
  let uid:string;
  let chatRef:admin.database.Reference;
  if (queue === null || queue ===  undefined) {
    corsFn(request, response, () => {
      response.status(400).json({ 'message': 'Queue id is required' });
    });
  }
  const token = request.query.token || 'string';
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    uid = decodedToken.uid;
    const adminRef = admin.database().ref('/users/' + uid).child('role');
    return adminRef.once('value');
  })
  .then((snapshot) => {
    if (snapshot.val() !== LEVEL.ADMIN) {
      return Promise.reject({ 'message': 'Permission denied' });
    }
    chatRef = admin.database().ref('/chats/' + queue);
    return chatRef.once('value');
  })
  .then((snapshot) => {
    if (!snapshot.exists()) {
      return Promise.reject({ 'message': 'Queue does not exist' });
    } else if(snapshot.val().status === 1) {
      return Promise.reject({ 'message': 'Current queues is active' });
    } else {
      return admin.database().ref('/queues/' + queue).remove();
    }
  })
  .then(() => {
    return chatRef.remove();
  })
  .then(() => {
    corsFn(request, response, () => {
      response.status(200).json({ 'message': 'Succesfully remove you from chat queue list' });
    });
  })
  .catch((error) => {
    corsFn(request, response, () => {
      response.status(400).json(error);
    });
  });
});

export const onUserCreated = functions.auth.user().onCreate((user) => {
  admin.database().ref('/users/' + user.uid).set({ 'role': LEVEL.MEMBER, 'online': false })
  .then(() => {
    console.log(user)
    return admin.database().ref('/users_public/' + user.uid).set({
      'name': user.displayName || 'Unknown',
      'photoUrl': user.photoURL
    });
  })
  .catch((error) => {
    console.log(error);
  });
});