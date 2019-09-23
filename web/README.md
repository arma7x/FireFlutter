### Installation

#### Step 1
Enabled auth method Email/Password & Google [Firebase console](https://console.firebase.google.com) 

#### Step 2
- Update web app's configuration file ``src/config.js`` [Firebase console](https://console.firebase.google.com)
- Get [firebaseMessagingPublicVapidKey](https://stackoverflow.com/questions/54996206/firebase-cloud-messaging-where-to-find-public-vapid-key)
- Update ``messagingSenderId`` in ``public/firebase-messaging-sw.js``

#### Step 3

``` bash

# install dependencies
npm install || yarn install

# serve with hot reload at localhost:8080
npm run dev || yarn dev

# build for production with minification and to build Progressive Web Apps (output folder '../firebase/public')
npm run build || yarn build 

```
