import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/navigation/fragments.dart';
import 'package:fireflutter/navigation/screens.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    new DrawerItem("Profile", Icons.person, () => new Profile(title:"Profile"), true),
    new DrawerItem("Sign In", Icons.exit_to_app, () => new LoginPage(title: 'Sign In'), false),
    new DrawerItem("Sign Up", Icons.person_add, () => new RegisterPage(title: 'Sign Up'), false),
    new DrawerItem("Reset Password", Icons.lock_open, () => new ForgotPassword(title: 'Reset Password'), false),
  ];

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _currentFragmentIndex = 0;
  DatabaseReference _metadataRef;
  DatabaseReference _offlineRef;
  FirebaseUser _user;

  _MyHomePageState();

  _getCurrentFragmentIndex(int pos) {
    if (widget.drawerFragments[pos] != null) {
      return widget.drawerFragments[pos].body();
    } else {
      return new Text("Error");
    }
  }
  
  _onSelectFragment(int index) {
    setState(() => _currentFragmentIndex = index);
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

  @override
  void initState() {
    super.initState();

    _auth.onAuthStateChanged.listen((user) {
      Provider.of<Auth>(context, listen: false).setUser(user);
      if (user != null ) {
        Provider.of<Auth>(context, listen: false).goOnline();
        _metadataRef = FirebaseDatabase.instance.reference().child('/users/${user.uid}');
        _metadataRef.onValue.listen((Event event) {
          Provider.of<Auth>(context, listen: false).setMetadata(event.snapshot.value);
        });
      }
    });

    _auth.currentUser()
    .then((FirebaseUser user) {
      Provider.of<Auth>(context, listen: false).setUser(user);
    })
    .catchError((e) {
      Provider.of<Auth>(context, listen: false).setUser(null);
    });

    _offlineRef = FirebaseDatabase.instance.reference().child('.info/connected');
    _offlineRef.onValue.listen((Event event) {
      if (event.snapshot.value == true) {
        if (_user != null) {
          Provider.of<Auth>(context, listen: false).goOnline();
        }
        Provider.of<Shared>(context, listen: false).setOffline(false);
      } else {
        Provider.of<Shared>(context, listen: false).setOffline(true);
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      //print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      //print("GET TOKEN :: $token");
      Provider.of<Shared>(context, listen: false).setFCM(token);
    });
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      //print("REFRESH TOKEN :: $token");
      Provider.of<Shared>(context, listen: false).setFCM(token);
    });
  }

  @override
  void dispose() {
    super.dispose();
    //_offlineRef.cancel();
  }

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<Auth>(context).user;

    //String _clientId = Provider.of<Shared>(context).clientId;
    //print('CLIENTID :: ${_clientId}');

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
          selected: i == _currentFragmentIndex,
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
        title: new Text(widget.drawerFragments[_currentFragmentIndex].title),
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
                Provider.of<Shared>(context, listen: false).removeActiveDevice(_user.uid);
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
                  backgroundImage: _user?.photoUrl != null ? CachedNetworkImageProvider(_user?.photoUrl) : null,
                  child: _user?.photoUrl == null ? Icon(Icons.person, size: 60.0) : null,
                ),
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
      ),
      body: _getCurrentFragmentIndex(_currentFragmentIndex),
    );
  }
}
