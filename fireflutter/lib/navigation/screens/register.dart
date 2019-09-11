import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _secure = true;
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
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      //suffixIcon: GestureDetector(
                        //child: Icon(_secure ? Icons.visibility : Icons.visibility_off),
                        //onTap: _toggleSecure
                      //),
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
                      if (value != _confirmPasswordController.text) {
                        return 'Password not match';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      suffixIcon: GestureDetector(
                        child: Icon(_secure ? Icons.visibility : Icons.visibility_off),
                        onTap: _toggleSecure
                      ),
                      labelText: 'Confirm Password'
                    ),
                    obscureText: _secure,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 8) {
                        return 'Minimum 8 character';
                      }
                      if (value != _passwordController.text) {
                        return 'Password not match';
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
                        child: Text('Submit Registration'),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            final String status = await _register();
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future _register() async {
    setState(() { _loading = true; });
    try {
      await Provider.of<Auth>(context, listen: false).signUserIn(_emailController.text, _passwordController.text);
      setState(() { _loading = false; });
      Navigator.of(context).pop();
      return "Successfully registered";
    } catch (e) {
      setState(() { _loading = false; });
      return e.toString();
    }
  }

  void _toggleSecure() {
    setState(() {
      _secure = !_secure;
    });
  }
}
