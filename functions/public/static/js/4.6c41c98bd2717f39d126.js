webpackJsonp([4],{412:function(t,e,r){var s=r(416)(r(419),r(428),null,null,null);t.exports=s.exports},416:function(t,e){t.exports=function(t,e,r,s,n){var a,i=t=t||{},o=typeof t.default;"object"!==o&&"function"!==o||(a=t,i=t.default);var l="function"==typeof i?i.options:i;e&&(l.render=e.render,l.staticRenderFns=e.staticRenderFns),s&&(l._scopeId=s);var c;if(n?(c=function(t){t=t||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext,t||"undefined"==typeof __VUE_SSR_CONTEXT__||(t=__VUE_SSR_CONTEXT__),r&&r.call(this,t),t&&t._registeredComponents&&t._registeredComponents.add(n)},l._ssrRegister=c):r&&(c=r),c){var u=l.functional,v=u?l.render:l.beforeCreate;u?l.render=function(t,e){return c.call(e),v(t,e)}:l.beforeCreate=v?[].concat(v,c):[c]}return{esModule:a,exports:i,options:l}}},419:function(t,e,r){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var s=r(74);r.n(s);e.default={data:function(){return{name:""}},computed:{user:function(){return this.name=this.$store.getters.user.name,this.$store.getters.user},error:function(){return this.$store.getters.error}},mounted:function(){s.database().ref("users/"+this.$store.getters.user.uid).once("value").then(function(t){}),document.querySelector("#avatar").addEventListener("change",this.updateUserAvatar)},methods:{clickFileUpload:function(){document.querySelector("#avatar").click()},updateUserAvatar:function(t){var e=this;if(t.target.files.length>0){this.$store.commit("setLoading",!0);var r=s.storage(),n="/user/"+this.$store.getters.user.uid+"/avatar/"+t.target.files[0].name;r.ref(n).put(t.target.files[0]).on("state_changed",function(t){},function(t){e.$store.commit("setError",t),e.$store.commit("setLoading",!1)},function(){r.ref(n).getDownloadURL().then(function(t){e.$store.commit("setLoading",!1),e.$store.dispatch("updateUserProfile",{photoURL:t})}).catch(function(t){e.$store.commit("setError",t),e.$store.commit("setLoading",!1)})})}},updateUserName:function(){this.$store.dispatch("updateUserProfile",{displayName:this.name})},selfDestructAccount:function(){confirm("Confirm to delete your account ?")&&(this.$store.dispatch("selfDestructAccount"),this.$router.push("/"))},onDismissed:function(){this.$store.dispatch("clearError")}}}},428:function(t,e){t.exports={render:function(){var t=this,e=t.$createElement,r=t._self._c||e;return r("v-container",{staticClass:"center-vertical"},[r("v-layout",{attrs:{column:""}},[t.error?r("v-layout",{attrs:{row:""}},[r("v-flex",{attrs:{xs12:"",sm4:"","offset-sm4":""}},[r("app-alert",{attrs:{text:t.error.message},on:{dismissed:t.onDismissed}})],1)],1):t._e(),t._v(" "),r("v-layout",{attrs:{row:""}},[r("v-flex",{attrs:{xs12:"",sm4:"","offset-sm4":""}},[r("v-card",[r("v-card-text",[r("div",{staticClass:"text-xl-center text-lg-center text-sm-center text-md-center text-xs-center"},[r("v-avatar",{attrs:{tile:!1,size:100,color:"grey lighten-4"}},[null!=t.user.photoUrl?r("img",{attrs:{src:t.user.photoUrl,alt:"avatar"}}):t._e(),t._v(" "),null==t.user.photoUrl?r("v-icon",{attrs:{size:"120"}},[t._v("account_circle")]):t._e()],1),t._v(" "),r("form",{staticStyle:{margin:"-45px -70px 0 -0"},on:{submit:function(e){return e.preventDefault(),t.updateUserAvatar(e)}}},[r("v-layout",{staticStyle:{display:"flex","align-items":"center","justify-content":"center"},attrs:{column:""}},[r("input",{staticStyle:{display:"none"},attrs:{id:"avatar",type:"file",accept:"image/*"}}),t._v(" "),r("v-btn",{attrs:{small:"",fab:"",color:"primary"},on:{click:function(e){return e.preventDefault(),t.clickFileUpload(e)}}},[r("v-icon",{attrs:{dark:""}},[t._v("camera_alt")])],1)],1)],1)],1),t._v(" "),r("v-list",{attrs:{"two-line":"",subheader:""}},[r("v-list-tile",{attrs:{avatar:""}},[r("v-list-tile-content",[r("v-list-tile-title",[t._v("UID")]),t._v(" "),r("v-list-tile-sub-title",[t._v(t._s(void 0!==t.user&&null!==t.user?t.user.uid:""))])],1)],1),t._v(" "),r("v-list-tile",{attrs:{avatar:""}},[r("v-list-tile-content",[r("v-list-tile-title",[t._v("Name")]),t._v(" "),r("v-list-tile-sub-title",[t._v(t._s(void 0!==t.user&&null!==t.user?t.user.name:""))]),t._v(" "),r("form",{staticStyle:{width:"100%"},on:{submit:function(e){return e.preventDefault(),t.updateUserName(e)}}},[r("v-layout",{attrs:{row:"",wrap:""}},[r("v-flex",{attrs:{xs12:""}},[r("v-text-field",{attrs:{name:"name",label:"Name",id:"name",type:"text",required:""},model:{value:t.name,callback:function(e){t.name=e},expression:"name"}})],1)],1)],1)],1)],1),t._v(" "),r("v-list-tile",{attrs:{avatar:""}},[r("v-list-tile-content",[r("v-list-tile-title",[t._v("Email")]),t._v(" "),r("v-list-tile-sub-title",[t._v(t._s(void 0!==t.user&&null!==t.user?t.user.email:""))])],1)],1),t._v(" "),r("v-list-tile",{attrs:{avatar:""}},[r("v-list-tile-content",[r("v-list-tile-title",[t._v("Admin")]),t._v(" "),r("v-list-tile-sub-title",[t._v(t._s(void 0!==t.user&&null!==t.user?t.user.admin?"TRUE":"FALSE":""))])],1)],1)],1),t._v(" "),r("v-btn",{staticClass:"info",attrs:{block:""},on:{click:t.updateUserName}},[t._v("Update Profile")]),t._v(" "),r("v-btn",{staticClass:"error",attrs:{block:""},on:{click:t.selfDestructAccount}},[t._v("self-Destruct Account")])],1)],1)],1)],1)],1)],1)},staticRenderFns:[]}}});