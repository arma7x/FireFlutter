import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/navigation/fragments.dart';
import 'package:fireflutter/navigation/screens.dart';
import 'package:fireflutter/state/provider_state.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => Counter()),
        ChangeNotifierProvider(builder: (_) => Auth()),
        ChangeNotifierProvider(builder: (_) => Shared()),
      ],
      child: Consumer<Counter>(
        builder: (context, counter, _) {
          return MaterialApp(
            title: "FireFlutter",
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(),
          );
        },
      ),
    );
  }

}

class DrawerItem {
  String title;
  IconData icon;
  Function body;
  bool requireAuth;
  DrawerItem(this.title, this.icon, this.body, this.requireAuth);
}

class MyHomePage extends StatefulWidget {

  final drawerFragments = [
    new DrawerItem("FireFlutter", Icons.home, () => new HomePage(title:"FireFlutter"), null),
  ];

  final drawerScreens = [
    new DrawerItem("Profile", Icons.person, () => new Profile(title:"Profile"), null),
    new DrawerItem("Sign In", Icons.exit_to_app, () => new LoginPage(title: 'Sign In'), false),
    new DrawerItem("Sign Up", Icons.person_add, () => new RegisterPage(title: 'Sign Up'), false),
    new DrawerItem("Reset Password", Icons.lock_open, () => new ForgotPassword(title: 'Forgot Password'), false),
  ];

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedDrawerFragmentIndex = 0;

  _MyHomePageState();

  _getDrawerFragmentWidgetIndex(int pos) {
    if (widget.drawerFragments[pos] != null) {
      return widget.drawerFragments[pos].body();
    } else {
      return new Text("Error");
    }
  }
  
  _onSelectFragment(int index) {
    setState(() => _selectedDrawerFragmentIndex = index);
    Navigator.of(context).pop();
  }
  
  _onSelectScreen(int index) {
    if (widget.drawerScreens[index] != null) {
      Navigator.of(context).pop(); // close drawer
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (BuildContext context) => widget.drawerScreens[index].body())
      );
    }
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33)+89;
    });
    return new String.fromCharCodes(codeUnits);
  }

  @override
  Widget build(BuildContext context) {

    _auth.onAuthStateChanged.listen((event) {
      Provider.of<Auth>(context, listen: false).setUser(event);
    });

    _auth.currentUser()
    .then((FirebaseUser user) {
      Provider.of<Auth>(context, listen: false).setUser(user);
    })
    .catchError((e) {
      Provider.of<Auth>(context, listen: false).setUser(null);
    });

    FirebaseUser _user = Provider.of<Auth>(context).user;

    List<Widget> drawerOptions = [];

    for (var i = 0; i < widget.drawerFragments.length; i++) {
      if (_user != null && widget.drawerFragments[i].requireAuth == false) {
        continue;
      }
      if (_user == null && widget.drawerFragments[i].requireAuth == true) {
        continue;
      }
      var d = widget.drawerFragments[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerFragmentIndex,
          onTap: () => _onSelectFragment(i),
        )
      );
    }

    for (var i = 0; i < widget.drawerScreens.length; i++) {
      if (_user != null && widget.drawerScreens[i].requireAuth == false) {
        continue;
      }
      if (_user == null && widget.drawerScreens[i].requireAuth == true) {
        continue;
      }
      var d = widget.drawerScreens[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          onTap: () => _onSelectScreen(i),
        )
      );
    }

    return new Scaffold(
      appBar: AppBar(
        title: new Text(widget.drawerFragments[_selectedDrawerFragmentIndex].title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () {
                if (_user == null) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text('No one has signed in'),
                  ));
                  return;
                }
                //remove active device
                Provider.of<Auth>(context, listen: false).signOut();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Successfully signed out'),
                ));
              },
            );
          })
        ],
      ),
      drawer: new SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        child: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(_user != null ? (_user?.displayName != null ? _user.displayName : "Unknown") : "Guest", style: TextStyle(fontSize: 16)),
                accountEmail: new Text(
                  _user != null ? _user.email : "Please sign in",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: _user?.photoUrl != null ?
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(_user.photoUrl))),
                  ) : Icon(Icons.person, size: 60.0),
                ),
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
      ),
      body: _getDrawerFragmentWidgetIndex(_selectedDrawerFragmentIndex),
    );
  }
}
