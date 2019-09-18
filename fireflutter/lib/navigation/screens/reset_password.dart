import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key, this.title, this.loadingCb}) : super(key: key);

  final String title;
  final Function loadingCb;

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  double _pxRatio;

  @override
  Widget build(BuildContext context) {

    _pxRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
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
                  style: TextStyle(fontSize: 8.0 * _pxRatio,),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, size: 10.0 * _pxRatio,),
                    labelText: 'Enter Email',
                    labelStyle: TextStyle(fontSize: 8.0 * _pxRatio,),
                    contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
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
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Send Reset Link',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final String status = await _forgotPassword();
                        Toast.show(status, context, duration: 5);
                      }
                    }
                  ),
                )
              ),
            ],
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _forgotPassword() async {
    widget.loadingCb(true);
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      widget.loadingCb(false);
      Navigator.of(context).pop();
      return "Check e-mail inbox";
    } catch(e) {
      widget.loadingCb(false);
      return e.toString();
    }
  }
}
