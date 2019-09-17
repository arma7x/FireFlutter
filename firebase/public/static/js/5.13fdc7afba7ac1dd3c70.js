webpackJsonp([5],{475:function(t,e,s){var r=s(479)(s(487),s(506),null,null,null);t.exports=r.exports},479:function(t,e){t.exports=function(t,e,s,r,n){var a,o=t=t||{},u=typeof t.default;"object"!==u&&"function"!==u||(a=t,o=t.default);var i="function"==typeof o?o.options:o;e&&(i.render=e.render,i.staticRenderFns=e.staticRenderFns),r&&(i._scopeId=r);var c;if(n?(c=function(t){t=t||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext,t||"undefined"==typeof __VUE_SSR_CONTEXT__||(t=__VUE_SSR_CONTEXT__),s&&s.call(this,t),t&&t._registeredComponents&&t._registeredComponents.add(n)},i._ssrRegister=c):s&&(c=s),c){var l=i.functional,_=l?i.render:i.beforeCreate;l?i.render=function(t,e){return c.call(e),_(t,e)}:i.beforeCreate=_?[].concat(_,c):[c]}return{esModule:a,exports:o,options:i}}},487:function(t,e,s){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var r=s(68),n=(s.n(r),s(190));e.default={data:function(){return{users:{},queues:null}},computed:{user:function(){return this.$store.getters.user},error:function(){return this.$store.getters.error}},mounted:function(){var t=this,e=r.database();e.ref("queues").orderByChild("timestamp").on("value",function(e){var s=[];for(var r in e.val()){var n=e.val()[r];n.key=r,s.push(n)}s.sort(function(t,e){return t.timestamp>e.timestamp?1:-1}),t.queues=s}),e.ref("users_public").on("value",function(e){t.users=e.val()})},methods:{joinChat:function(t){this.$router.push({path:"chat",query:{id:t}})},handleChat:function(t){var e=this;if(confirm("Are sure to put this queue under your supervision ?")){var s={assigned_user:this.user.uid,status:1};r.database().ref("queues/"+t).update(s).then(function(){return r.database().ref("chats/"+t).update(s)}).then(function(){r.auth().currentUser.getIdToken(!0).then(function(e){n.a.adminNotifyClient({token:e,queue:t})}),e.joinChat(t)}).catch(function(t){e.$store.commit("setError",t)})}}}}},506:function(t,e){t.exports={render:function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("v-container",{staticClass:"no-center-vertical"},[s("v-layout",{attrs:{column:""}},[s("v-layout",{attrs:{row:""}},[s("v-flex",{attrs:{xs12:"",sm6:"","offset-sm3":""}},[null!=t.queues?s("div",{staticClass:"py-0"},t._l(t.queues,function(e,r){return s("v-card",{key:r,staticClass:"mb-2",attrs:{avatar:""}},[s("v-layout",{attrs:{column:""}},[s("v-card-text",[s("v-layout",{attrs:{row:""}},[t.users[e.key]?s("v-avatar",{attrs:{size:"40",color:"grey"}},[null!=t.users[e.key].photoUrl?s("img",{attrs:{src:t.users[e.key].photoUrl}}):t._e(),t._v(" "),null==t.users[e.key].photoUrl?s("v-icon",{attrs:{size:"50",color:"white"}},[t._v("account_circle")]):t._e()],1):t._e(),t._v(" "),t.users[e.key]?s("v-layout",{staticClass:"mx-2",staticStyle:{"line-height":"normal"},attrs:{column:""}},[s("v-layout",{staticClass:"mx-1 body-2",attrs:{"align-start":""}},[0!=e.status?s("v-icon",{staticClass:"mr-1 body-2",attrs:{color:"info"}},[t._v("lock")]):t._e(),t._v(" "),0==e.status?s("v-icon",{staticClass:"mr-1 body-2",attrs:{color:"warning"}},[t._v("lock_open")]):t._e(),t._v("\n                      "+t._s(e.topic)+"\n                    ")],1),t._v(" "),s("v-layout",{staticClass:"mt-2 mx-1 caption",attrs:{"align-start":""}},[s("v-icon",{staticClass:"mr-1 caption",attrs:{color:"primary"}},[t._v("calendar_today")]),t._v("\n                      "+t._s(new Date(e.timestamp).toLocaleString())+"\n                    ")],1)],1):t._e(),t._v(" "),e.assigned_user==t.user.uid||0==e.assigned_user?s("v-layout",{attrs:{"align-start":"","justify-end":""}},[e.assigned_user==t.user.uid?s("v-btn",{staticClass:"px-0 py-0 mx-0 my-0",attrs:{fab:"",small:"",color:"primary"},on:{click:function(s){return t.joinChat(e.key)}}},[s("v-icon",[t._v("chat")])],1):t._e(),t._v(" "),0==e.assigned_user?s("v-btn",{staticClass:"px-0 py-0 mx-0 my-0",attrs:{fab:"",small:"",color:"warning"},on:{click:function(s){return t.handleChat(e.key)}}},[s("v-icon",[t._v("supervisor_account")])],1):t._e()],1):t._e(),t._v(" "),0!=e.assigned_user&&e.assigned_user!=t.user.uid&&null!==t.users[e.assigned_user]&&void 0!==t.users[e.assigned_user]?s("v-avatar",{attrs:{size:"40",color:"grey"}},[null!=t.users[e.assigned_user].photoUrl?s("img",{attrs:{src:t.users[e.assigned_user].photoUrl}}):t._e(),t._v(" "),null==t.users[e.assigned_user].photoUrl?s("v-icon",{attrs:{size:"50",color:"white"}},[t._v("account_circle")]):t._e()],1):t._e()],1),t._v(" "),s("v-layout",{attrs:{row:""}},[t._v("\n                  "+t._s(t.users[e.key].name)+"\n                  "),0!=e.assigned_user&&e.assigned_user!=t.user.uid?s("v-spacer"):t._e(),t._v(" "),0!=e.assigned_user&&e.assigned_user!=t.user.uid?s("span",[t._v(t._s(t.users[e.assigned_user].name))]):t._e()],1)],1)],1)],1)}),1):t._e()])],1)],1)],1)},staticRenderFns:[]}}});