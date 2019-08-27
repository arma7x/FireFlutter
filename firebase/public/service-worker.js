"use strict";var precacheConfig=[["/firebase-app.js","1c39a7dbb47c8af72d5a1ae62a5c9367"],["/firebase-messaging-sw.js","571974697cb11cd71d0233aef3b829a3"],["/firebase-messaging.js","685fb3756ec04585490e17bc590fe833"],["/index.html","5537f543df1d9faa1a4abccfa5947ae0"],["/service-worker.js","6cfdbb23a7b57efb8436a4612d8a4fc7"],["/static/img/icons/android-chrome-192x192.png","2320d218cec5da0f8ccfded3419ab03e"],["/static/img/icons/android-chrome-512x512.png","3bdee070f7f9c230dd43a8466113f864"],["/static/img/icons/android-chrome-96x96.png","a77f96073946ed97f129f276e25270ae"],["/static/img/icons/apple-touch-icon-120x120.png","be85892a8069a9becadf309b4c3e879d"],["/static/img/icons/apple-touch-icon-152x152.png","b7146f588af7f47c3885eb0d49ba9af7"],["/static/img/icons/apple-touch-icon-180x180.png","c9fefc90ef88b89b3a2d2196f2a7433e"],["/static/img/icons/apple-touch-icon-60x60.png","9c011de6d5479352e557eac9ee87dcdf"],["/static/img/icons/apple-touch-icon-76x76.png","b5dc4ca763f8715902adad8c80e6573d"],["/static/img/icons/apple-touch-icon.png","95b8007efcc99719bcaedf7cb08047fd"],["/static/img/icons/favicon-16x16.png","f38f7105e32e9e4571a2b9b410fee66a"],["/static/img/icons/favicon-32x32.png","93f07e2e85413114a0747ee15efc5a88"],["/static/img/icons/msapplication-icon-144x144.png","1f837337ff946e43eaab41156ae92f3b"],["/static/img/icons/mstile-150x150.png","273ff966904dd0e513b8fe898c166dec"],["/static/img/icons/safari-pinned-tab.svg","f15058438168fe0777f2ca0cf2ca7221"],["/static/img/v.png","5e055714d2c647827907bbf144cf409f"],["/static/js/0.1361ee7cf9c13632924d.js","91ad75c94dc80f162b05ba2b10fb2f51"],["/static/js/1.9191428cec4a7c80612c.js","31954a2c9a8280494df88aa326df62ac"],["/static/js/2.5c604d87529e49ac1b80.js","02eff82dd2169fc1ac8738b6a0970875"],["/static/js/3.c631cb6573e94bd0424a.js","6f5e1c260a4c35de2284e2ce4bf6370d"],["/static/js/4.b76fcb9a5460e4d6595b.js","84fbaf927dea3e80ebbd79fbe3691345"],["/static/js/5.a5e5bef7d18517092f42.js","a2912dbbf5fea3f95c625bb9b578d1cf"],["/static/js/6.751895ddb1a5084004b5.js","addb65df4a8cba5aad202042475b708d"],["/static/js/7.1d7bfbca7368490bb047.js","8b58aeb46f65ede75e7df4b71e96f4f3"],["/static/js/8.55de69c19cb37d17b123.js","d0c752ac1d4a5bef7e135bf218f86fd9"],["/static/js/app.751a58e188c2b1742a9d.js","e6a4781ed2dd189a58daca62b113bcd1"],["/static/js/manifest.e09cada0771e70ef5761.js","0364d20ded78c1f50262e448f96d199f"],["/static/js/vendor.0dc1dec6080b2c6daf6e.js","dbc940ea5c7b98153b154088d0c8f7ee"]],cacheName="sw-precache-v3-my-vue-app-"+(self.registration?self.registration.scope:""),ignoreUrlParametersMatching=[/^utm_/],addDirectoryIndex=function(e,a){var t=new URL(e);return"/"===t.pathname.slice(-1)&&(t.pathname+=a),t.toString()},cleanResponse=function(e){return e.redirected?("body"in e?Promise.resolve(e.body):e.blob()).then(function(a){return new Response(a,{headers:e.headers,status:e.status,statusText:e.statusText})}):Promise.resolve(e)},createCacheKey=function(e,a,t,c){var n=new URL(e);return c&&n.pathname.match(c)||(n.search+=(n.search?"&":"")+encodeURIComponent(a)+"="+encodeURIComponent(t)),n.toString()},isPathWhitelisted=function(e,a){if(0===e.length)return!0;var t=new URL(a).pathname;return e.some(function(e){return t.match(e)})},stripIgnoredUrlParameters=function(e,a){var t=new URL(e);return t.hash="",t.search=t.search.slice(1).split("&").map(function(e){return e.split("=")}).filter(function(e){return a.every(function(a){return!a.test(e[0])})}).map(function(e){return e.join("=")}).join("&"),t.toString()},hashParamName="_sw-precache",urlsToCacheKeys=new Map(precacheConfig.map(function(e){var a=e[0],t=e[1],c=new URL(a,self.location),n=createCacheKey(c,hashParamName,t,!1);return[c.toString(),n]}));function setOfCachedUrls(e){return e.keys().then(function(e){return e.map(function(e){return e.url})}).then(function(e){return new Set(e)})}self.addEventListener("install",function(e){e.waitUntil(caches.open(cacheName).then(function(e){return setOfCachedUrls(e).then(function(a){return Promise.all(Array.from(urlsToCacheKeys.values()).map(function(t){if(!a.has(t)){var c=new Request(t,{credentials:"same-origin"});return fetch(c).then(function(a){if(!a.ok)throw new Error("Request for "+t+" returned a response with status "+a.status);return cleanResponse(a).then(function(a){return e.put(t,a)})})}}))})}).then(function(){return self.skipWaiting()}))}),self.addEventListener("activate",function(e){var a=new Set(urlsToCacheKeys.values());e.waitUntil(caches.open(cacheName).then(function(e){return e.keys().then(function(t){return Promise.all(t.map(function(t){if(!a.has(t.url))return e.delete(t)}))})}).then(function(){return self.clients.claim()}))}),self.addEventListener("fetch",function(e){if("GET"===e.request.method){var a,t=stripIgnoredUrlParameters(e.request.url,ignoreUrlParametersMatching);(a=urlsToCacheKeys.has(t))||(t=addDirectoryIndex(t,"index.html"),a=urlsToCacheKeys.has(t));0,a&&e.respondWith(caches.open(cacheName).then(function(e){return e.match(urlsToCacheKeys.get(t)).then(function(e){if(e)return e;throw Error("The cached response that was expected is missing.")})}).catch(function(a){return console.warn('Couldn\'t serve response for "%s" from cache: %O',e.request.url,a),fetch(e.request)}))}});