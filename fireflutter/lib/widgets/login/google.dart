import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:toast/toast.dart';

class GoogleSignInSection extends StatefulWidget {

  final Function loadingCb;

  GoogleSignInSection({Key key, this.loadingCb}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GoogleSignInSectionState();
}

class GoogleSignInSectionState extends State<GoogleSignInSection> {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: double.infinity, // match_parent
            child: RaisedButton(
              child: Text(
                'Sign In with Google',
              ),
              onPressed: () async {
                final String status = await _signInWithGoogle();
                Toast.show(status, context, duration: 5);
              }
            ),
          )
        )
      ],
    );
  }

  Future _signInWithGoogle() async {
    widget.loadingCb(true);
    try {
      await Provider.of<Auth>(context, listen: false).signUserInGoogle();
      Provider.of<Shared>(context, listen: false).addActiveDevice(Provider.of<Auth>(context).user.uid);
      widget.loadingCb(false);
      Navigator.of(context).pop();
      return "Successfully signed in";
    } catch (e) {
      widget.loadingCb(false);
      return e.toString();
    }
  }
}
