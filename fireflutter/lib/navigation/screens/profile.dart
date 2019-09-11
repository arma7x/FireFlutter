import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  FirebaseUser _user;
  Map<dynamic, dynamic> _metadata;

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<Auth>(context).user;
    _metadata = Provider.of<Auth>(context).metadata;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
          child: Container(
            height: 650,
            width: (MediaQuery.of(context).size.width - 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: _user?.photoUrl != null ? CachedNetworkImageProvider(_user?.photoUrl) : null,
                        child: _user?.photoUrl == null ? Icon(Icons.person, size: 150.0) : null,
                      ),
                      Positioned(
                        right: 5.0,
                        bottom: 0.0,
                        child: FloatingActionButton(
                          backgroundColor: Colors.blueAccent,
                          onPressed: () => {},
                          child: Icon(Icons.camera_alt),
                        )
                      ),
                    ]
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'UID',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
                      ),
                      Text(
                        _user.uid,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey)
                      ),
                    ]
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Name',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
                      ),
                      Text(
                        _user?.displayName != null ? _user.displayName : "Unknown",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                    ]
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Email',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
                      ),
                      Text(
                        _user?.email,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                    ]
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Admin',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
                      ),
                      Text(
                        _metadata['role'] == 1 ? 'TRUE' : 'FALSE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                    ]
                  ),
                ),
                Container(width: double.infinity,
                  margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.save, size: 25, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "UPDATE PROFILE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ]
                    )
                  ),
                ),
                Container(width: double.infinity,
                  margin: EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 0.0),
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.redAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.delete, size: 25, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "SELF-DESTRUCT ACCOUNT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ]
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
