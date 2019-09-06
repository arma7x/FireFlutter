import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: IgnorePointer(
        ignoring: _loading,
        child: Form(
          key: _formKey,
          child: new Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
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
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity, // match_parent
                    child: Builder(
                      builder: (context) => RaisedButton(
                        child: Text('Send Reset Link'),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            final String status = await _forgotPassword();
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(status),
                            ));
                          }
                        }
                      ),
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                  alignment: Alignment.center,
                  child: this._loading ? new LinearProgressIndicator() : SizedBox(height: 0, width: 0),
                ),
              ],
            )
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _forgotPassword() async {
    setState(() { _loading = true; });
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      setState(() { _loading = false; });
      return "Check e-mail inbox";
    } catch(e) {
      setState(() { _loading = false; });
      return e.toString();
    };
  }
}
