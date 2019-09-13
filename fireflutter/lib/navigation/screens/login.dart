import 'package:flutter/material.dart';
import 'package:fireflutter/widgets/login_widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.loadingCb}) : super(key: key);

  final String title;
  final Function loadingCb;

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
                EmailPasswordForm(loadingCb: widget.loadingCb),
                GoogleSignInSection(loadingCb: widget.loadingCb),
              ],
            )
          )
        )
      )
    );
  }
}
