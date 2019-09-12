import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class Auth with ChangeNotifier {

  Auth();

  FirebaseUser _user;
  Map<dynamic, dynamic> _metadata;

  FirebaseUser get user => _user;
  Map<dynamic, dynamic> get metadata => _metadata;

  void setUser(user) {
    _user = user;
    notifyListeners();
  }

  void setMetadata(Map<dynamic, dynamic> metadata) {
    _metadata = metadata;
    notifyListeners();
  }

  Future<void> updateUserProfile(UserUpdateInfo userUpdateInfo) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      await user.updateProfile(userUpdateInfo);
      FirebaseUser updatedUser = await _auth.currentUser();
      FirebaseDatabase.instance.reference().child('/users_public/${updatedUser.providerData[0].uid}').set(<dynamic, dynamic>{
        'name': updatedUser.providerData[0].displayName != null ? updatedUser.providerData[0].displayName : 'Unknown',
        'photoUrl': updatedUser.providerData[0].photoUrl
      });
      setUser(updatedUser);
    } catch(e) {
      print(e);
    };
  }

  void selfDestructAccount() {
    notifyListeners();
  }

  Future<FirebaseUser> signUserUp(String email, String password) {
    Future<FirebaseUser> user = _auth.createUserWithEmailAndPassword(email: email, password: password);
    notifyListeners();
    return user;
  }

  Future<FirebaseUser> signUserIn(String email, String password) {
    Future<FirebaseUser> user = _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
    return user;
  }

  Future<FirebaseUser> signUserInGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    Future<FirebaseUser> user = _auth.signInWithCredential(credential);
    notifyListeners();
    return user;
  }

  void goOnline() {
    print("[AUTH::goOnline]${_user.uid}");
    try {
      DatabaseReference _onlineRef;
      _onlineRef = FirebaseDatabase.instance.reference().child('/users/${_user.uid}/online');
      _onlineRef.onDisconnect().set(false);
      _onlineRef.set(true);
    } catch(e) {
      print("[AUTH::goOnline]ONLINE ERROR::"+e.toString());
    }
    try {
      DatabaseReference _lastOnlineRef;
      _lastOnlineRef = FirebaseDatabase.instance.reference().child('/users/${_user.uid}/last_online');
      _lastOnlineRef.onDisconnect().set(<dynamic, dynamic>{
        '.sv': 'timestamp'
      });
      _lastOnlineRef.set(<dynamic, dynamic>{
        '.sv': 'timestamp'
      });
    } catch(e) {
      print("[AUTH::goOnline]LAST ONLINE ERROR::"+e.toString());
    }
    try {
      DatabaseReference _metadataRef;
      _metadataRef = FirebaseDatabase.instance.reference().child('/users/${_user.uid}');
      _metadataRef.onValue.listen((Event event) {
        setMetadata(event.snapshot.value);
      });
    } catch(e) {
      print("[AUTH::goOnline]METADATA::"+e.toString());
    }
  }

  void goOffline() {
    print("[AUTH::goOffnline]${_user.uid}");
    try {
      FirebaseDatabase.instance.reference().child('/users/${_user.uid}/online').set(false);
    } catch(e) {
      print("[SHARED::REMOVE]ONLINE ERROR::"+e.toString());
    }
    try {
      FirebaseDatabase.instance.reference().child('/users/${_user.uid}/last_online').set(<dynamic, dynamic>{
        '.sv': 'timestamp'
      });
    } catch(e) {
      print("[SHARED::REMOVE]LAST ONLINE ERROR::"+e.toString());
    }
  }

  void signOut() async {
    goOffline();
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
