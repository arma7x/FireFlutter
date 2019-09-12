import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:toast/toast.dart';
import 'package:fireflutter/widgets/login_widgets.dart';

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
                EmailPasswordForm(loadingCb: _callback),
                GoogleSignInSection(loadingCb: _callback),
                //Container(
                  //alignment: Alignment.center,
                  //child: this._loading ? new LinearProgressIndicator() : SizedBox(height: 0, width: 0),
                //),
              ],
            )
          )
        )
      )
    );
  }

  void _callback(bool loading) {
    if (loading) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: new LinearProgressIndicator()
            ),
          );
        },
      );
    } else {
      Navigator.of(context).pop();
    }
    setState(() { _loading = loading; });
  }
}
