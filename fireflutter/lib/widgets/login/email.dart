import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:toast/toast.dart';

class EmailPasswordForm extends StatefulWidget {

  final Function loadingCb;

  EmailPasswordForm({Key key, this.loadingCb}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EmailPasswordFormState();
}

class EmailPasswordFormState extends State<EmailPasswordForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _secure = true;
  double _pxRatio;

  @override
  Widget build(BuildContext context) {

    _pxRatio = MediaQuery.of(context).devicePixelRatio;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
            alignment: Alignment.center,
            child: TextFormField(
              controller: _passwordController,
              style: TextStyle(fontSize: 8.0 * _pxRatio,),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key, size: 10.0 * _pxRatio,),
                suffixIcon: GestureDetector(
                  child: Icon(_secure ? Icons.visibility : Icons.visibility_off, size: 10.0 * _pxRatio,),
                  onTap: _toggleSecure
                ),
                labelText: 'Enter Password',
                labelStyle: TextStyle(fontSize: 8.0 * _pxRatio,),
                contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
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
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Sign In With Email',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final String status = await _signInWithEmailAndPassword();
                    Toast.show(status, context, duration: 5);
                  }
                }
              ),
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
    widget.loadingCb(true);
    try {
      await Provider.of<Auth>(context, listen: false).signUserIn(_emailController.text, _passwordController.text);
      Provider.of<Shared>(context, listen: false).addActiveDevice(Provider.of<Auth>(context).user.uid);
      widget.loadingCb(false);
      Navigator.of(context).pop();
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
