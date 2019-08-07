import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as cors from 'cors';

const serviceAccount = require('../service_account.json');
const ADMIN = 'Uc22I5nWJbh10eqIsxEDDLUHI0k2';
const LEVEL = {
  ADMIN: 0,
  MEMBER: 999
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://fireflutter-f1304.firebaseio.com'
});

export const verifyAdmin = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const token = request.query.token || 'string';
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    if (decodedToken.uid !== ADMIN) {
      return Promise.reject({ 'message': 'Permission denied' });
    }
    const additionalClaims = {
      admin: true
    };
    return admin.auth().createCustomToken(decodedToken.uid, additionalClaims);
  })
  .then((customToken) => {
    corsFn(request, response, () => {
      response.status(200).json({ token: customToken });
    });
  })
  .catch((error) => {
    corsFn(request, response, () => {
      response.status(400).json(error);
    });
  });
});

export const updateUserProfile = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const token = request.query.token || 'string';
  const userProperty = {};
  if (request.query.displayName) {
    Object.assign(userProperty, { 'displayName': request.query.displayName });
  }
  if (request.query.photoURL) {
    Object.assign(userProperty, { 'photoURL': request.query.photoURL });
  }
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    return admin.auth().updateUser(decodedToken.uid, userProperty);
  })
  .then((userRecord) => {
    corsFn(request, response, () => {
      response.status(200).json({ user: userRecord.toJSON() });
    });
  })
  .catch((error) => {
    corsFn(request, response, () => {
      response.status(400).json(error);
    });
  });
});

export const selfDestructAccount = functions.https.onRequest((request, response) => {
  const corsFn = cors();
  const token = request.query.token || 'string';
  admin.auth().verifyIdToken(token)
  .then((decodedToken) => {
    console.log('/users/'+decodedToken.uid)
    // admin.database().ref('/users/'+decodedToken.uid).set({'deleted': true})
    admin.database().ref('/users').child(decodedToken.uid).remove()
    .then(() => {
      console.log('DELETED::'+decodedToken.uid)
    })
    .catch((error) => {
      console.log(error);
    });
    return admin.auth().deleteUser(decodedToken.uid);
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

exports.onUserCreated = functions.auth.user().onCreate((user) => {
  admin.database().ref('/users/'+user.uid).set({'role': LEVEL.MEMBER})
  .then(() => {
    console.log(user)
  })
  .catch((error) => {
    console.log(error);
  });
});
