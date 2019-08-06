import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.cb}) : super(key: key);

  final String title;
  final Function cb;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
        //title: Text(widget.title),
        //actions: <Widget>[
          //Builder(builder: (BuildContext context) {
            //return FlatButton(
              //child: const Text('Sign out'),
              //textColor: Theme.of(context).buttonColor,
              //onPressed: () async {
                //_callback(true, null);
                //final FirebaseUser user = await _auth.currentUser();
                //if (user == null) {
                  //Scaffold.of(context).showSnackBar(SnackBar(
                    //content: const Text('No one has signed in.'),
                  //));
                  //_callback(false, null);
                  //return;
                //}
                //_callback(false, null);
                //_signOut();
                //final String uid = user.uid;
                //Scaffold.of(context).showSnackBar(SnackBar(
                  //content: Text(uid + ' has successfully signed out.'),
                //));
              //},
            //);
          //})
        //],
      //),
      body:  IgnorePointer(
        ignoring: _loading,
        child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
          alignment: Alignment.center,
          child: new Center(
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                _EmailPasswordForm(callback: _callback, authCallback: widget.cb),
                _GoogleSignInSection(callback: _callback, authCallback: widget.cb),
                Container(
                  alignment: Alignment.center,
                  child: this._loading ? new LinearProgressIndicator() : SizedBox(height: 0, width: 0),
                ),
              ],
            )
          )
        )
      )
    );
  }

  //void _signOut() async {
    //await _auth.signOut();
    //await _googleSignIn.signOut();
    //widget.cb('login page logout');
  //}

  void _callback(bool loading) {
    setState(() { _loading = loading; });
  }
}

class _EmailPasswordForm extends StatefulWidget {

  Function callback;
  Function authCallback;

  _EmailPasswordForm({Key key, this.callback, this.authCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _secure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Enter Email'
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                suffixIcon: GestureDetector(
                  child: Icon(_secure ? Icons.visibility : Icons.visibility_off),
                  onTap: _toggleSecure
                ),
                labelText: 'Enter Password'
              ),
              obscureText: _secure,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 8) {
                  return 'Minimum 8 character';
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: SizedBox(
              width: double.infinity, // match_parent
              child: Builder(
                builder: (context) => RaisedButton(
                  child: Text('Sign In With Email'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final String status = await _signInWithEmailAndPassword();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(status),
                      ));
                    }
                  }
                ),
              )
            )
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _signInWithEmailAndPassword() async {
    widget.callback(true);
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      widget.callback(false);
      widget.authCallback('login page login');
      return "Successfully signed in";
    } catch (e) {
      widget.callback(false);
      return e.toString();
    }
  }

  void _toggleSecure() {
    setState(() {
      _secure = !_secure;
    });
  }
}

class _GoogleSignInSection extends StatefulWidget {

  Function callback;
  Function authCallback;

  _GoogleSignInSection({Key key, this.callback, this.authCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {

  bool _secure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          alignment: Alignment.center,
          child: SizedBox(
            width: double.infinity, // match_parent
            child: Builder(
              builder: (context) => RaisedButton(
                child: Text('Sign In with Google'),
                onPressed: () async {
                  final String status = await _signInWithGoogle();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(status),
                  ));
                }
              ),
            )
          )
        )
      ],
    );
  }

  Future _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    widget.callback(true);

    try {
      FirebaseUser user = await _auth.signInWithCredential(credential);
      widget.callback(false);
      widget.authCallback('login page login');
      return "Successfully signed in";
    } catch (e) {
      widget.callback(false);
      return e.toString();
    }
  }
}
