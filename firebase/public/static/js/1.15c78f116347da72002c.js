webpackJsonp([1],{411:function(t,e,s){function r(t){s(469)}var i=s(417)(s(437),s(471),r,null,null);t.exports=i.exports},417:function(t,e){t.exports=function(t,e,s,r,i){var n,a=t=t||{},o=typeof t.default;"object"!==o&&"function"!==o||(n=t,a=t.default);var l="function"==typeof a?a.options:a;e&&(l.render=e.render,l.staticRenderFns=e.staticRenderFns),r&&(l._scopeId=r);var u;if(i?(u=function(t){t=t||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext,t||"undefined"==typeof __VUE_SSR_CONTEXT__||(t=__VUE_SSR_CONTEXT__),s&&s.call(this,t),t&&t._registeredComponents&&t._registeredComponents.add(i)},l._ssrRegister=u):s&&(u=s),u){var c=l.functional,d=c?l.render:l.beforeCreate;c?l.render=function(t,e){return u.call(e),d(t,e)}:l.beforeCreate=d?[].concat(d,u):[u]}return{esModule:n,exports:a,options:l}}},423:function(t,e){function s(t,e){var s=t[1]||"",i=t[3];if(!i)return s;if(e&&"function"==typeof btoa){var n=r(i);return[s].concat(i.sources.map(function(t){return"/*# sourceURL="+i.sourceRoot+t+" */"})).concat([n]).join("\n")}return[s].join("\n")}function r(t){return"/*# sourceMappingURL=data:application/json;charset=utf-8;base64,"+btoa(unescape(encodeURIComponent(JSON.stringify(t))))+" */"}t.exports=function(t){var e=[];return e.toString=function(){return this.map(function(e){var r=s(e,t);return e[2]?"@media "+e[2]+"{"+r+"}":r}).join("")},e.i=function(t,s){"string"==typeof t&&(t=[[null,t,""]]);for(var r={},i=0;i<this.length;i++){var n=this[i][0];"number"==typeof n&&(r[n]=!0)}for(i=0;i<t.length;i++){var a=t[i];"number"==typeof a[0]&&r[a[0]]||(s&&!a[2]?a[2]=s:s&&(a[2]="("+a[2]+") and ("+s+")"),e.push(a))}},e}},424:function(t,e,s){function r(t){for(var e=0;e<t.length;e++){var s=t[e],r=c[s.id];if(r){r.refs++;for(var i=0;i<r.parts.length;i++)r.parts[i](s.parts[i]);for(;i<s.parts.length;i++)r.parts.push(n(s.parts[i]));r.parts.length>s.parts.length&&(r.parts.length=s.parts.length)}else{for(var a=[],i=0;i<s.parts.length;i++)a.push(n(s.parts[i]));c[s.id]={id:s.id,refs:1,parts:a}}}}function i(){var t=document.createElement("style");return t.type="text/css",d.appendChild(t),t}function n(t){var e,s,r=document.querySelector("style["+_+'~="'+t.id+'"]');if(r){if(p)return f;r.parentNode.removeChild(r)}if(g){var n=h++;r=v||(v=i()),e=a.bind(null,r,n,!1),s=a.bind(null,r,n,!0)}else r=i(),e=o.bind(null,r),s=function(){r.parentNode.removeChild(r)};return e(t),function(r){if(r){if(r.css===t.css&&r.media===t.media&&r.sourceMap===t.sourceMap)return;e(t=r)}else s()}}function a(t,e,s,r){var i=s?"":r.css;if(t.styleSheet)t.styleSheet.cssText=y(e,i);else{var n=document.createTextNode(i),a=t.childNodes;a[e]&&t.removeChild(a[e]),a.length?t.insertBefore(n,a[e]):t.appendChild(n)}}function o(t,e){var s=e.css,r=e.media,i=e.sourceMap;if(r&&t.setAttribute("media",r),m.ssrId&&t.setAttribute(_,e.id),i&&(s+="\n/*# sourceURL="+i.sources[0]+" */",s+="\n/*# sourceMappingURL=data:application/json;base64,"+btoa(unescape(encodeURIComponent(JSON.stringify(i))))+" */"),t.styleSheet)t.styleSheet.cssText=s;else{for(;t.firstChild;)t.removeChild(t.firstChild);t.appendChild(document.createTextNode(s))}}var l="undefined"!=typeof document;if("undefined"!=typeof DEBUG&&DEBUG&&!l)throw new Error("vue-style-loader cannot be used in a non-browser environment. Use { target: 'node' } in your Webpack config to indicate a server-rendering environment.");var u=s(425),c={},d=l&&(document.head||document.getElementsByTagName("head")[0]),v=null,h=0,p=!1,f=function(){},m=null,_="data-vue-ssr-id",g="undefined"!=typeof navigator&&/msie [6-9]\b/.test(navigator.userAgent.toLowerCase());t.exports=function(t,e,s,i){p=s,m=i||{};var n=u(t,e);return r(n),function(e){for(var s=[],i=0;i<n.length;i++){var a=n[i],o=c[a.id];o.refs--,s.push(o)}e?(n=u(t,e),r(n)):n=[];for(var i=0;i<s.length;i++){var o=s[i];if(0===o.refs){for(var l=0;l<o.parts.length;l++)o.parts[l]();delete c[o.id]}}}};var y=function(){var t=[];return function(e,s){return t[e]=s,t.filter(Boolean).join("\n")}}()},425:function(t,e){t.exports=function(t,e){for(var s=[],r={},i=0;i<e.length;i++){var n=e[i],a=n[0],o=n[1],l=n[2],u=n[3],c={id:t+":"+i,css:o,media:l,sourceMap:u};r[a]?r[a].parts.push(c):s.push(r[a]={id:a,parts:[c]})}return s}},437:function(t,e,s){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var r=s(58),i=(s.n(r),s(161)),n=s.n(i);e.default={data:function(){return{autoGrow:!1,autofocus:!0,clearable:!1,counter:!0,filled:!1,flat:!1,hint:"",label:"",loading:!1,noResize:!1,outlined:!1,persistentHint:!1,placeholder:"",rounded:!1,rowHeight:24,rows:2,shaped:!1,singleLine:!1,solo:!1,item:"chat",topic:null,message:null,chat:null,uid:null,assigned_user:null,queue_user:null,queue_user_private:null,hidden:!1}},computed:{user:function(){return this.$store.getters.user},metadata:function(){return this.$store.getters.metadata},error:function(){return this.$store.getters.error}},mounted:function(){var t=this,e=r.database(),s=this.$route.query.id?this.$route.query.id:this.$store.getters.user.uid;this.uid=s,null==this.queue_user&&e.ref("users_public/"+this.uid).once("value",function(e){t.queue_user=e.val()}),e.ref("users/"+this.uid).on("value",function(e){t.queue_user_private=e.val()}),e.ref("chats/"+this.uid).on("value",function(s){s.val()?(t.chat=s.val(),s.val().assigned_user&&null==t.assigned_user&&e.ref("users_public/"+s.val().assigned_user).once("value",function(e){t.assigned_user=e.val()})):(t.chat=null,1===t.metadata.role&&t.$router.push({path:"queue"}))})},updated:function(){this.$refs.chat_scroller&&(this.$refs.chat_scroller.scrollTop=this.$refs.chat_scroller.scrollHeight)},methods:{toggleHidden:function(){this.hidden=!this.hidden},joinQueue:function(){var t=this;confirm("Are sure to enter chat queue list ?")&&(this.$store.commit("setLoading",!0),this.$store.commit("clearError"),r.auth().currentUser.getIdToken(!0).then(function(e){return n.a.get("https://us-central1-"+r.apps[0].options.projectId+".cloudfunctions.net/joinQueue",{params:{token:e,topic:t.topic}})}).then(function(e){t.$store.commit("setLoading",!1)}).catch(function(e){t.$store.commit("setLoading",!1),t.$store.commit("setError",e.response.data)}))},sendMessage:function(){var t=this;this.$store.commit("clearError");var e={user:this.$store.getters.user.uid,timestamp:r.database.ServerValue.TIMESTAMP,message:{mime:"text",data:this.message,caption:""}};r.database().ref("/chats/"+this.uid+"/logs").push(e).then(function(){t.message=null,t.$store.commit("clearError")}).catch(function(e){t.$store.commit("setError",e)})},deleteQueue:function(){var t=this;confirm("Are sure to exit from chat queue list ?")&&(this.$store.commit("setLoading",!0),r.auth().currentUser.getIdToken(!0).then(function(t){return n.a.get("https://us-central1-"+r.apps[0].options.projectId+".cloudfunctions.net/deleteQueue",{params:{token:t}})}).then(function(e){t.$store.commit("setLoading",!1),t.$store.commit("clearError"),t.hidden=!1}).catch(function(e){t.$store.commit("setLoading",!1),t.$store.commit("setError",e.response.data)}))},adminToggleStatus:function(){var t=this,e={status:0===this.chat.status?1:0};r.database().ref("chats/"+this.uid).update(e).then(function(){r.database().ref("queues/"+t.uid).update(e)}).catch(function(e){t.$store.commit("setError",e)})},adminNotifyClient:function(){var t=this;this.$store.commit("setLoading",!0),r.auth().currentUser.getIdToken(!0).then(function(e){return n.a.get("https://us-central1-"+r.apps[0].options.projectId+".cloudfunctions.net/adminNotifyClient",{params:{token:e,queue:t.uid}})}).then(function(e){t.$store.commit("setLoading",!1),t.$store.commit("clearError"),t.hidden=!1}).catch(function(e){t.$store.commit("setLoading",!1),t.$store.commit("setError",e.response.data)})},adminDeleteQueue:function(){var t=this;confirm("Are sure to delete this chat from queue list ?")&&(this.$store.commit("setLoading",!0),r.auth().currentUser.getIdToken(!0).then(function(e){return n.a.get("https://us-central1-"+r.apps[0].options.projectId+".cloudfunctions.net/adminDeleteQueue",{params:{token:e,queue:t.uid}})}).then(function(e){t.$store.commit("setLoading",!1),t.$store.commit("clearError"),t.hidden=!1,t.$router.go(-1)}).catch(function(e){t.$store.commit("setLoading",!1),t.$store.commit("setError",e.response.data)}))}}}},467:function(t,e,s){e=t.exports=s(423)(!0),e.push([t.i,".chat-box{max-width:140px!important}@media (min-width:768px){.chat-box{max-width:270px!important}}","",{version:3,sources:["/home/arma7x/Desktop/New/dart/fireflutter/web/src/components/User/Chat.vue"],names:[],mappings:"AACA,UACE,yBAA4B,CAC7B,AACD,yBACA,UACI,yBAA4B,CAC/B,CACA",file:"Chat.vue",sourcesContent:["\n.chat-box {\n  max-width: 140px !important;\n}\n@media (min-width: 768px) {\n.chat-box {\n    max-width: 270px !important;\n}\n}"],sourceRoot:""}])},469:function(t,e,s){var r=s(467);"string"==typeof r&&(r=[[t.i,r,""]]),r.locals&&(t.exports=r.locals);s(424)("ce90b112",r,!0,{})},471:function(t,e){t.exports={render:function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("v-container",{staticClass:"center-vertical"},[s("v-layout",{attrs:{column:""}},[null==t.chat?s("v-layout",{attrs:{row:""}},[s("v-flex",{attrs:{xs12:"",sm6:"","offset-sm3":""}},[s("v-card",{staticClass:"mb-2"},[s("v-card-text",[s("form",{staticStyle:{width:"100%"},on:{submit:function(e){return e.preventDefault(),t.joinQueue(e)}}},[s("v-layout",{attrs:{row:"",wrap:""}},[s("v-flex",{attrs:{xs12:""}},[s("v-text-field",{attrs:{name:"topic",label:"Topic of discussion or issue ?",id:"topic",type:"text",required:""},model:{value:t.topic,callback:function(e){t.topic=e},expression:"topic"}}),t._v(" "),s("v-btn",{staticClass:"primary",attrs:{block:""},on:{click:t.joinQueue}},[t._v("Join Queue")])],1)],1)],1)])],1)],1)],1):t._e(),t._v(" "),null!=t.chat?s("v-layout",{attrs:{row:""}},[s("v-flex",{attrs:{xs12:"",sm6:"","offset-sm3":""}},[null!=t.chat?s("div",[s("v-container",{ref:"chat_scroller",staticClass:"mx-0 my-0 px-0 py-0 scroll-y",staticStyle:{height:"68vh"}},[void 0!=t.chat.logs?s("v-layout",{staticClass:"mx-0 px-0",attrs:{column:""}},[s("ul",{staticStyle:{"list-style":"none"}},t._l(t.chat.logs,function(e,r){return s("li",{key:r},[s("v-layout",{staticClass:"mb-2 px-0",attrs:{row:""}},[e.user!=t.user.uid&&e.user==t.chat.assigned_user&&null!==t.assigned_user&&void 0!==t.assigned_user?s("v-list-tile-avatar",{attrs:{color:"grey",size:"40"}},[null!=t.assigned_user.photoUrl?s("img",{attrs:{src:t.assigned_user.photoUrl}}):t._e(),t._v(" "),null==t.assigned_user.photoUrl?s("v-icon",{attrs:{size:"50",color:"white"}},[t._v("account_circle")]):t._e()],1):t._e(),t._v(" "),e.user!=t.user.uid&&e.user==t.uid&&null!==t.queue_user&&void 0!==t.queue_user?s("v-list-tile-avatar",{attrs:{color:"grey",size:"40"}},[null!=t.queue_user.photoUrl?s("img",{attrs:{src:t.queue_user.photoUrl}}):t._e(),t._v(" "),null==t.queue_user.photoUrl?s("v-icon",{attrs:{size:"50",color:"white"}},[t._v("account_circle")]):t._e()],1):t._e(),t._v(" "),s("div",{class:{"col-auto ml-auto":e.user==t.user.uid}},[s("v-card",{staticClass:"chat-box"},[s("v-card-text",{staticClass:"mx-0 my-0"},[s("v-list-tile-content",[s("v-list-tile-sub-title",{staticClass:"black--text",staticStyle:{"white-space":"normal"},style:{textAlign:e.user==t.user.uid?"right":"left"}},[t._v(t._s(e.message.data))]),t._v(" "),s("v-list-tile-sub-title",{staticClass:"caption grey--text",style:{textAlign:e.user==t.user.uid?"right":"left"}},[t._v(t._s(new Date(e.timestamp).toLocaleString()))])],1)],1)],1)],1),t._v(" "),t.user&&e.user==t.user.uid?s("v-list-tile-avatar",{staticClass:"ml-3",attrs:{color:"grey",size:"40"}},[null!=t.user.photoUrl?s("img",{attrs:{src:t.user.photoUrl}}):t._e(),t._v(" "),null==t.user.photoUrl?s("v-icon",{attrs:{size:"50",color:"white"}},[t._v("account_circle")]):t._e()],1):t._e()],1)],1)}),0)]):t._e()],1),t._v(" "),s("form",{staticClass:"transparent",staticStyle:{width:"100%"},on:{submit:function(e){return e.preventDefault(),t.sendMessage(e)}}},[s("v-layout",{staticClass:"transparent",attrs:{row:"",wrap:"","align-center":""}},[s("v-flex",{staticStyle:{display:"flex","align-items":"center","justify-content":"center"},attrs:{xs2:""}},[s("v-btn",{attrs:{fab:"",small:"",color:"info"},on:{click:t.toggleHidden}},[s("v-icon",{attrs:{dark:""}},[t._v("announcement")])],1)],1),t._v(" "),s("v-flex",{staticClass:"transparent",attrs:{xs8:""}},[s("v-textarea",{attrs:{"auto-grow":t.autoGrow,clearable:t.clearable,counter:!!t.counter&&t.counter,filled:t.filled,flat:t.flat,hint:t.hint,label:t.label,loading:t.loading,"no-resize":t.noResize,outlined:t.outlined,"persistent-hint":t.persistentHint,placeholder:t.placeholder,rounded:t.rounded,"row-height":t.rowHeight,rows:t.rows,shaped:t.shaped,"single-line":t.singleLine,solo:t.solo},model:{value:t.message,callback:function(e){t.message=e},expression:"message"}})],1),t._v(" "),s("v-flex",{staticStyle:{display:"flex","align-items":"center","justify-content":"center"},attrs:{xs2:""}},[s("v-btn",{attrs:{fab:"",small:"",color:"primary"},on:{click:t.sendMessage}},[s("v-icon",{attrs:{dark:""}},[t._v("send")])],1)],1)],1)],1)],1):t._e()])],1):t._e()],1),t._v(" "),s("v-dialog",{attrs:{"max-width":"280px"},model:{value:t.hidden,callback:function(e){t.hidden=e},expression:"hidden"}},[s("v-card",[s("v-card-text",[s("div",{staticClass:"text-xl-center text-lg-center text-sm-center text-md-center text-xs-center"},[null!=t.chat?s("div",[s("v-list",{attrs:{subheader:""}},[s("v-list-tile",[s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"title"},[t._v("Topic")]),t._v(" "),s("v-list-tile-sub-title",{staticClass:"body-1"},[t._v(t._s(t.chat.topic))])],1)],1),t._v(" "),s("v-list-tile",{staticClass:"mt-1"},[s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2"},[t._v("Timestamp")]),t._v(" "),s("v-list-tile-sub-title",{staticClass:"body-1"},[t._v(t._s(new Date(t.chat.timestamp).toLocaleString()))])],1)],1),t._v(" "),s("v-list-tile",{staticClass:"mt-1"},[0!=t.chat.assigned_user&&null!=t.assigned_user&&void 0!=t.assigned_user?s("v-list-tile-avatar",{attrs:{size:"40",color:"grey"}},[null!=t.assigned_user.photoUrl?s("img",{attrs:{src:t.assigned_user.photoUrl}}):t._e(),t._v(" "),null==t.assigned_user.photoUrl?s("v-icon",{attrs:{size:"50",color:"white"}},[t._v("account_circle")]):t._e()],1):t._e(),t._v(" "),s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2"},[t._v("Supervisor")]),t._v(" "),s("v-list-tile-sub-title",{staticClass:"body-1"},[t._v(t._s(null!=t.assigned_user?t.assigned_user.name:"TBA"))])],1)],1),t._v(" "),s("v-list-tile",{staticClass:"mt-1"},[null!=t.queue_user&&void 0!=t.queue_user?s("v-list-tile-avatar",{attrs:{size:"40",color:"grey"}},[null!=t.queue_user.photoUrl?s("img",{attrs:{src:t.queue_user.photoUrl}}):t._e(),t._v(" "),null==t.queue_user.photoUrl?s("v-icon",{attrs:{size:"50",color:"white"}},[t._v("account_circle")]):t._e()],1):t._e(),t._v(" "),s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2"},[t._v("Client")]),t._v(" "),s("v-list-tile-sub-title",{staticClass:"body-1"},[t._v(t._s(null!=t.queue_user?t.queue_user.name:"-"))])],1)],1),t._v(" "),null!=t.queue_user_private&&1==t.metadata.role?s("v-list-tile",{staticClass:"mt-1"},[s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2"},[t._v("Client Status")]),t._v(" "),s("v-list-tile-sub-title",{staticClass:"body-1"},[t._v(t._s(1!=t.queue_user_private.online?"Last Seen "+new Date(t.queue_user_private.last_online).toLocaleString():"Online"))])],1)],1):t._e(),t._v(" "),s("v-layout",{staticClass:"mt-1",attrs:{row:""}},[1==t.metadata.role?s("v-list-tile",[s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2 pb-2"},[t._v(t._s(0==t.chat.status?"Unlocked":"Locked"))]),t._v(" "),s("v-list-tile-sub-title",{staticClass:"body-1"},[s("v-switch",{staticClass:"my-0 mx-2",on:{change:t.adminToggleStatus},model:{value:0!=t.chat.status,callback:function(e){t.$set(t.chat,"status == 0 ? false : true",e)},expression:"chat.status == 0 ? false : true"}})],1)],1)],1):t._e(),t._v(" "),1==t.metadata.role&&0==t.chat.status?s("v-spacer"):t._e(),t._v(" "),1==t.metadata.role&&0==t.chat.status?s("v-list-tile",[s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2"},[t._v("Delete Queue")]),t._v(" "),s("v-btn",{attrs:{color:"error"},on:{click:t.adminDeleteQueue}},[t._v("\n                        Delete\n                        "),s("v-icon",{attrs:{right:""}},[t._v("delete")])],1)],1)],1):t._e(),t._v(" "),t.user.uid==t.uid&&0==t.chat.status?s("v-spacer"):t._e(),t._v(" "),t.user.uid==t.uid&&0==t.chat.status?s("v-list-tile",[s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2"},[t._v("Delete Queue")]),t._v(" "),s("v-btn",{attrs:{color:"error"},on:{click:t.deleteQueue}},[t._v("\n                        Delete\n                        "),s("v-icon",{attrs:{right:""}},[t._v("delete")])],1)],1)],1):t._e()],1),t._v(" "),1==t.metadata.role?s("v-list-tile",[s("v-list-tile-content",[s("v-list-tile-title",{staticClass:"body-2"}),t._v(" "),s("v-btn",{staticClass:"py-2",attrs:{block:"",color:"success"},on:{click:t.adminNotifyClient}},[t._v("\n                      Notify Client\n                      "),s("v-icon",{attrs:{right:""}},[t._v("notification_important")])],1)],1)],1):t._e()],1)],1):t._e()])])],1)],1)],1)},staticRenderFns:[]}}});