import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class Auth with ChangeNotifier {

  Auth() {
    _auth.onAuthStateChanged.listen((event) {
      _user = event;
      if (_user != null ) {
        _metadataRef = FirebaseDatabase.instance.reference().child('/users/${_user.uid}');
        _metadataRef.onValue.listen((Event event) {
          _metadata = event.snapshot.value;
        });
      }
    });

    _auth.currentUser()
    .then((FirebaseUser user) {
      _user = user;
    })
    .catchError((e) {
      _user = null;
    });
  }

  DatabaseReference _metadataRef;
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

  void updateUserProfile() {
    notifyListeners();
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

  void signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
