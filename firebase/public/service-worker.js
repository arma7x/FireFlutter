"use strict";var precacheConfig=[["/firebase-app.js","1c39a7dbb47c8af72d5a1ae62a5c9367"],["/firebase-messaging-sw.js","ab3d740395e3b978654bc3640b3823b4"],["/firebase-messaging.js","685fb3756ec04585490e17bc590fe833"],["/index.html","9a354fb83402045eeed7174a821d3835"],["/service-worker.js","6cfdbb23a7b57efb8436a4612d8a4fc7"],["/static/img/icons/android-chrome-192x192.png","2320d218cec5da0f8ccfded3419ab03e"],["/static/img/icons/android-chrome-512x512.png","3bdee070f7f9c230dd43a8466113f864"],["/static/img/icons/android-chrome-96x96.png","a77f96073946ed97f129f276e25270ae"],["/static/img/icons/apple-touch-icon-120x120.png","be85892a8069a9becadf309b4c3e879d"],["/static/img/icons/apple-touch-icon-152x152.png","b7146f588af7f47c3885eb0d49ba9af7"],["/static/img/icons/apple-touch-icon-180x180.png","c9fefc90ef88b89b3a2d2196f2a7433e"],["/static/img/icons/apple-touch-icon-60x60.png","9c011de6d5479352e557eac9ee87dcdf"],["/static/img/icons/apple-touch-icon-76x76.png","b5dc4ca763f8715902adad8c80e6573d"],["/static/img/icons/apple-touch-icon.png","95b8007efcc99719bcaedf7cb08047fd"],["/static/img/icons/favicon-16x16.png","f38f7105e32e9e4571a2b9b410fee66a"],["/static/img/icons/favicon-32x32.png","93f07e2e85413114a0747ee15efc5a88"],["/static/img/icons/msapplication-icon-144x144.png","1f837337ff946e43eaab41156ae92f3b"],["/static/img/icons/mstile-150x150.png","273ff966904dd0e513b8fe898c166dec"],["/static/img/icons/safari-pinned-tab.svg","f15058438168fe0777f2ca0cf2ca7221"],["/static/img/v.png","5e055714d2c647827907bbf144cf409f"],["/static/js/0.1c9ce333950e825471c9.js","d560129cb61362d41f305d4ed3e707c4"],["/static/js/1.2296455ead0f9316d5e5.js","7a8a975ae34119efd236431003e3bace"],["/static/js/2.e00c9eb33ba5c82eef7f.js","af68ad444323f5ae8b7ab4a1b4bbe7c2"],["/static/js/3.e840b3d28e9ac2af7b9d.js","ef7a3d8bbb5adbf4970e9c7cdc4acb7f"],["/static/js/4.05dc6df5efff911681db.js","77c27a130f87053006e74b0eb256a669"],["/static/js/5.13fdc7afba7ac1dd3c70.js","993f271daed5bca656feba99cccaccec"],["/static/js/6.868afe6366a9ed42a7d6.js","17ba782b6b3e62d14b70dd544efdc825"],["/static/js/7.e3c67730d96d23437ffd.js","1c993f2bd5d1bd5ccc38707dc67421fc"],["/static/js/8.4372404f1453c689be60.js","df59763c1379d09136490f9770b882ea"],["/static/js/app.6042077e260078799fb7.js","fe84f4ec16979ae026ee7ee0d0ab6668"],["/static/js/manifest.43e2837e162ff1cce6a1.js","1e6142242f9e900935eae98864cac376"],["/static/js/vendor.270e4cc95bc641497a6d.js","2b071c14f6e70c43f39730f9412b63b9"]],cacheName="sw-precache-v3-my-vue-app-"+(self.registration?self.registration.scope:""),ignoreUrlParametersMatching=[/^utm_/],addDirectoryIndex=function(e,t){var a=new URL(e);return"/"===a.pathname.slice(-1)&&(a.pathname+=t),a.toString()},cleanResponse=function(e){return e.redirected?("body"in e?Promise.resolve(e.body):e.blob()).then(function(t){return new Response(t,{headers:e.headers,status:e.status,statusText:e.statusText})}):Promise.resolve(e)},createCacheKey=function(e,t,a,c){var n=new URL(e);return c&&n.pathname.match(c)||(n.search+=(n.search?"&":"")+encodeURIComponent(t)+"="+encodeURIComponent(a)),n.toString()},isPathWhitelisted=function(e,t){if(0===e.length)return!0;var a=new URL(t).pathname;return e.some(function(e){return a.match(e)})},stripIgnoredUrlParameters=function(e,t){var a=new URL(e);return a.hash="",a.search=a.search.slice(1).split("&").map(function(e){return e.split("=")}).filter(function(e){return t.every(function(t){return!t.test(e[0])})}).map(function(e){return e.join("=")}).join("&"),a.toString()},hashParamName="_sw-precache",urlsToCacheKeys=new Map(precacheConfig.map(function(e){var t=e[0],a=e[1],c=new URL(t,self.location),n=createCacheKey(c,hashParamName,a,!1);return[c.toString(),n]}));function setOfCachedUrls(e){return e.keys().then(function(e){return e.map(function(e){return e.url})}).then(function(e){return new Set(e)})}self.addEventListener("install",function(e){e.waitUntil(caches.open(cacheName).then(function(e){return setOfCachedUrls(e).then(function(t){return Promise.all(Array.from(urlsToCacheKeys.values()).map(function(a){if(!t.has(a)){var c=new Request(a,{credentials:"same-origin"});return fetch(c).then(function(t){if(!t.ok)throw new Error("Request for "+a+" returned a response with status "+t.status);return cleanResponse(t).then(function(t){return e.put(a,t)})})}}))})}).then(function(){return self.skipWaiting()}))}),self.addEventListener("activate",function(e){var t=new Set(urlsToCacheKeys.values());e.waitUntil(caches.open(cacheName).then(function(e){return e.keys().then(function(a){return Promise.all(a.map(function(a){if(!t.has(a.url))return e.delete(a)}))})}).then(function(){return self.clients.claim()}))}),self.addEventListener("fetch",function(e){if("GET"===e.request.method){if(["https://fonts.googleapis.com","https://fonts.gstatic.com","https://firebasestorage.googleapis.com/v0/b/fireflutter-f1304.appspot.com"].some(t=>e.request.url.startsWith(t))){const t="CROSS_ORIGIN";e.respondWith(async function(){const a=await caches.open(t),c=await a.match(e.request);if(c)return c;const n=e.request.clone(),s=await fetch(n,{}),i=s.clone();return e.waitUntil(async function(){const a=await caches.open(t);await a.put(e.request,i)}()),s}())}var t,a=stripIgnoredUrlParameters(e.request.url,ignoreUrlParametersMatching);(t=urlsToCacheKeys.has(a))||(a=addDirectoryIndex(a,"index.html"),t=urlsToCacheKeys.has(a));0,t&&e.respondWith(caches.open(cacheName).then(function(e){return e.match(urlsToCacheKeys.get(a)).then(function(e){if(e)return e;throw Error("The cached response that was expected is missing.")})}).catch(function(t){return console.warn('Couldn\'t serve response for "%s" from cache: %O',e.request.url,t),fetch(e.request)}))}});