import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                _EmailPasswordForm(loadingCb: _callback),
                _GoogleSignInSection(loadingCb: _callback),
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

  void _callback(bool loading) {
    setState(() { _loading = loading; });
  }
}

class _EmailPasswordForm extends StatefulWidget {

  final Function loadingCb;

  _EmailPasswordForm({Key key, this.loadingCb}) : super(key: key);

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
                      final String status = await _signInWithEmailAndPassword(context);
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

  Future _signInWithEmailAndPassword(BuildContext context) async {
    widget.loadingCb(true);
    try {
      await Provider.of<Auth>(context, listen: false).signUserIn(_emailController.text, _passwordController.text);
      //add active device
      Provider.of<Shared>(context, listen: false).removeActiveDevice(Provider.of<Auth>(context).user.uid);
      Navigator.of(context).pop();
      widget.loadingCb(false);
      return "Successfully signed in";
    } catch (e) {
      widget.loadingCb(false);
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

  final Function loadingCb;

  _GoogleSignInSection({Key key, this.loadingCb}) : super(key: key);

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
                  final String status = await _signInWithGoogle(context);
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

  Future _signInWithGoogle(BuildContext context) async {
    widget.loadingCb(true);
    try {
      await Provider.of<Auth>(context, listen: false).signUserInGoogle();
      //add active device
      Provider.of<Shared>(context, listen: false).removeActiveDevice(Provider.of<Auth>(context).user.uid);
      Navigator.of(context).pop();
      widget.loadingCb(false);
      return "Successfully signed in";
    } catch (e) {
      widget.loadingCb(false);
      return e.toString();
    }
  }
}
