import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/config.dart';
import 'package:fireflutter/navigation/fragments.dart';
import 'package:fireflutter/navigation/screens.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';

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
            title: Config.APP_NAME,
            theme: ThemeData(
              primaryColor: Config.THEME_COLOR,
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
    new DrawerItem("FireFlutter", Icons.home, (Function loadingCb) => new HomePage(title:"FireFlutter", loadingCb: loadingCb), null),
  ];

  final drawerScreens = [
    new DrawerItem("Profile", Icons.person, (Function loadingCb) => new Profile(title:"Profile", loadingCb: loadingCb), true),
    new DrawerItem("Sign In", Icons.exit_to_app, (Function loadingCb) => new LoginPage(title: 'Sign In', loadingCb: loadingCb), false),
    new DrawerItem("Sign Up", Icons.person_add, (Function loadingCb) => new RegisterPage(title: 'Sign Up', loadingCb: loadingCb), false),
    new DrawerItem("Reset Password", Icons.lock_open, (Function loadingCb) => new ResetPassword(title: 'Reset Password', loadingCb: loadingCb), false),
  ];

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _currentFragmentIndex = 0;
  DatabaseReference _offlineRef;
  FirebaseUser _user;
  bool _offline;

  _MyHomePageState();

  _getCurrentFragmentIndex(int pos) {
    if (widget.drawerFragments[pos] != null) {
      return widget.drawerFragments[pos].body(_loadingDialog);
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
        CupertinoPageRoute(builder: (BuildContext context) => widget.drawerScreens[index].body(_loadingDialog))
      );
    }
  }

  void _loadingDialog(bool show) {
    if (show == true) {
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
  }

  @override
  void initState() {
    super.initState();

    _auth.onAuthStateChanged.listen((user) {
      Provider.of<Auth>(context, listen: false).setUser(user);
      if (user != null ) {
        Provider.of<Auth>(context, listen: false).goOnline();
      }
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
    //_offlineRef.onDisconnect().cancel();
  }

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<Auth>(context).user;
    _offline = Provider.of<Shared>(context).offline;

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
        title: Row(
          children: <Widget>[
            new Text(widget.drawerFragments[_currentFragmentIndex].title),
            SizedBox(width: _offline ? 10 : 0),
            _offline ? Icon(Icons.signal_wifi_off) : SizedBox(width: 0),
          ]
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Sign out'),
            textColor: Theme.of(context).buttonColor,
            onPressed: () {
              if (_user == null) {
                Toast.show('No one has signed in', context, duration: 5);
                return;
              }
              //remove active device
              Provider.of<Shared>(context, listen: false).removeActiveDevice(_user.uid);
              Provider.of<Auth>(context, listen: false).goOffline();
              Provider.of<Auth>(context, listen: false).signOut();
              Toast.show('Successfully signed out', context, duration: 5);
            },
          ),
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
