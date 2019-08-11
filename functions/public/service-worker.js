"use strict";var precacheConfig=[["/firebase-app.js","1c39a7dbb47c8af72d5a1ae62a5c9367"],["/firebase-messaging-sw.js","571974697cb11cd71d0233aef3b829a3"],["/firebase-messaging.js","685fb3756ec04585490e17bc590fe833"],["/index.html","c1d667712ec629186f30a7f6ff9a166f"],["/service-worker.js","6cfdbb23a7b57efb8436a4612d8a4fc7"],["/static/img/icons/android-chrome-192x192.png","2320d218cec5da0f8ccfded3419ab03e"],["/static/img/icons/android-chrome-512x512.png","3bdee070f7f9c230dd43a8466113f864"],["/static/img/icons/android-chrome-96x96.png","a77f96073946ed97f129f276e25270ae"],["/static/img/icons/apple-touch-icon-120x120.png","be85892a8069a9becadf309b4c3e879d"],["/static/img/icons/apple-touch-icon-152x152.png","b7146f588af7f47c3885eb0d49ba9af7"],["/static/img/icons/apple-touch-icon-180x180.png","c9fefc90ef88b89b3a2d2196f2a7433e"],["/static/img/icons/apple-touch-icon-60x60.png","9c011de6d5479352e557eac9ee87dcdf"],["/static/img/icons/apple-touch-icon-76x76.png","b5dc4ca763f8715902adad8c80e6573d"],["/static/img/icons/apple-touch-icon.png","95b8007efcc99719bcaedf7cb08047fd"],["/static/img/icons/favicon-16x16.png","f38f7105e32e9e4571a2b9b410fee66a"],["/static/img/icons/favicon-32x32.png","93f07e2e85413114a0747ee15efc5a88"],["/static/img/icons/msapplication-icon-144x144.png","1f837337ff946e43eaab41156ae92f3b"],["/static/img/icons/mstile-150x150.png","273ff966904dd0e513b8fe898c166dec"],["/static/img/icons/safari-pinned-tab.svg","f15058438168fe0777f2ca0cf2ca7221"],["/static/img/v.png","5e055714d2c647827907bbf144cf409f"],["/static/js/0.af6b45f324680225f1ad.js","cfd08e076e1e8c573f48ad4b3a2a180c"],["/static/js/1.db7c64a5edb5a9a02086.js","2f4d7f4acda9602c2b9054658ad6fea4"],["/static/js/2.b791959f506e51dba4c0.js","bae4ceb99186fe6d2673bdb1a78280f6"],["/static/js/3.b7b04221b9826026ea23.js","d5edc57410ed713d5f0a15d02b4184f2"],["/static/js/4.645d10b4389aac3d5872.js","c74cc3c3103d5db4820a377fddfe7ed3"],["/static/js/5.e3a1a9051859bddf6778.js","5a34aa3bf24daf8a2be7fba11570328b"],["/static/js/6.1452310e019294cffa4f.js","7adcee8702e6ebd74ba96f1b16dcb2d6"],["/static/js/app.43ff061da0f60c8b7657.js","f95a53af0290af332ab98c0c945bcaf8"],["/static/js/manifest.d8e88ad710fc85a37e3f.js","8588a062ed72b2a2ea963c4b5efd359d"],["/static/js/vendor.a615c10a66d7d4ac60a5.js","cdfa9bb0e94b3497c51492fa6255e0d6"]],cacheName="sw-precache-v3-my-vue-app-"+(self.registration?self.registration.scope:""),ignoreUrlParametersMatching=[/^utm_/],addDirectoryIndex=function(e,a){var t=new URL(e);return"/"===t.pathname.slice(-1)&&(t.pathname+=a),t.toString()},cleanResponse=function(e){return e.redirected?("body"in e?Promise.resolve(e.body):e.blob()).then(function(a){return new Response(a,{headers:e.headers,status:e.status,statusText:e.statusText})}):Promise.resolve(e)},createCacheKey=function(e,a,t,n){var c=new URL(e);return n&&c.pathname.match(n)||(c.search+=(c.search?"&":"")+encodeURIComponent(a)+"="+encodeURIComponent(t)),c.toString()},isPathWhitelisted=function(e,a){if(0===e.length)return!0;var t=new URL(a).pathname;return e.some(function(e){return t.match(e)})},stripIgnoredUrlParameters=function(e,a){var t=new URL(e);return t.hash="",t.search=t.search.slice(1).split("&").map(function(e){return e.split("=")}).filter(function(e){return a.every(function(a){return!a.test(e[0])})}).map(function(e){return e.join("=")}).join("&"),t.toString()},hashParamName="_sw-precache",urlsToCacheKeys=new Map(precacheConfig.map(function(e){var a=e[0],t=e[1],n=new URL(a,self.location),c=createCacheKey(n,hashParamName,t,!1);return[n.toString(),c]}));function setOfCachedUrls(e){return e.keys().then(function(e){return e.map(function(e){return e.url})}).then(function(e){return new Set(e)})}self.addEventListener("install",function(e){e.waitUntil(caches.open(cacheName).then(function(e){return setOfCachedUrls(e).then(function(a){return Promise.all(Array.from(urlsToCacheKeys.values()).map(function(t){if(!a.has(t)){var n=new Request(t,{credentials:"same-origin"});return fetch(n).then(function(a){if(!a.ok)throw new Error("Request for "+t+" returned a response with status "+a.status);return cleanResponse(a).then(function(a){return e.put(t,a)})})}}))})}).then(function(){return self.skipWaiting()}))}),self.addEventListener("activate",function(e){var a=new Set(urlsToCacheKeys.values());e.waitUntil(caches.open(cacheName).then(function(e){return e.keys().then(function(t){return Promise.all(t.map(function(t){if(!a.has(t.url))return e.delete(t)}))})}).then(function(){return self.clients.claim()}))}),self.addEventListener("fetch",function(e){if("GET"===e.request.method){var a,t=stripIgnoredUrlParameters(e.request.url,ignoreUrlParametersMatching);(a=urlsToCacheKeys.has(t))||(t=addDirectoryIndex(t,"index.html"),a=urlsToCacheKeys.has(t));0,a&&e.respondWith(caches.open(cacheName).then(function(e){return e.match(urlsToCacheKeys.get(t)).then(function(e){if(e)return e;throw Error("The cached response that was expected is missing.")})}).catch(function(a){return console.warn('Couldn\'t serve response for "%s" from cache: %O',e.request.url,a),fetch(e.request)}))}});