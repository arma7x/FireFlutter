import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fireflutter/api.dart';
import 'package:toast/toast.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title, this.any, this.loadingCb}) : super(key: key);

  final String title;
  final dynamic any;
  final Function loadingCb;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _user;
  String _uid;
  String _topic;
  Map<dynamic, dynamic> chat;
  Map<dynamic, dynamic> assigned_user;
  Map<dynamic, dynamic> queue_user;
  Map<dynamic, dynamic> queue_user_private;

  DatabaseReference _queueUserRef;
  DatabaseReference _queueUserPrivateRef;
  DatabaseReference _chatRef;

  final GlobalKey<FormState> _topicFormKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();

  final GlobalKey<FormState> _messageFormKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {

    super.initState();
    _uid = widget.any;

    if (queue_user == null) {
      _queueUserRef = FirebaseDatabase.instance.reference().child('users_public/' + _uid);
      _queueUserRef.onValue.listen((Event event) {
        if (event.snapshot.value != null) {
          var u = new Map<dynamic, dynamic>.from(event.snapshot.value);
          setState(() { queue_user = u; });
        }
      });
    }

    _queueUserPrivateRef = FirebaseDatabase.instance.reference().child('users/' + _uid);
    _queueUserPrivateRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        var u = new Map<dynamic, dynamic>.from(event.snapshot.value);
        setState(() { queue_user_private = u; });
      }
    });

    _chatRef = FirebaseDatabase.instance.reference().child('chats/' + _uid);
    _chatRef.onValue.listen((Event event) async {
      if (event.snapshot.value != null) {
        var c = new Map<dynamic, dynamic>.from(event.snapshot.value);
        setState(() { chat = c; });
        if (event.snapshot.value['assigned_user'] && assigned_user == null) {
          FirebaseDatabase.instance.reference().child('users_public/' + event.snapshot.value['assigned_user'])
          .onValue.listen((Event event) {
            if (event.snapshot.value != null) {
              var u = new Map<dynamic, dynamic>.from(event.snapshot.value);
              setState(() { assigned_user = u; });
            }
          });
        }
      } else {
        setState(() { chat = null; });
        FirebaseUser u = await _auth.currentUser();
        if (u.uid != _uid) {
          //Navigator.of(context).pop();
        }
      }
    });

  }

  joinQueue (BuildContext ctx) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are sure to enter chat queue list ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.redAccent)
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.loadingCb(true);
                _auth.currentUser()
                .then((FirebaseUser u) => u.getIdToken(refresh: true))
                .then((String token) => Api.joinQueue(<String, String>{ 'token': token, 'topic': _topicController.text }))
                .then((request) => request.close())
                .then((response) async {
                  widget.loadingCb(false);
                  final responseBody = await response.cast<List<int>>().transform(utf8.decoder).join();
                  final Map<String, dynamic> parsedBody = json.decode(responseBody);
                  Toast.show(parsedBody['message'], ctx, duration: 5);
                })
                .catchError((e) {
                  print(e);
                  widget.loadingCb(false);
                  Toast.show(e.toString(), ctx, duration: 5);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _queueUserRef.onDisconnect().cancel();
    _queueUserPrivateRef.onDisconnect().cancel();
    _chatRef.onDisconnect().cancel();
  }

  @override
  Widget build(BuildContext context) {

    final counter = Provider.of<Counter>(context);
    _user = Provider.of<Auth>(context).user;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: chat == null
      ? Center(
          child: Form(
            key: _topicFormKey,
            child: new Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: _topicController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Topic of discussion or issue ?'
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
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity, // match_parent
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Join Queue',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_topicFormKey.currentState.validate()) {
                            joinQueue(context);
                          }
                        }
                      ),
                    )
                  ),
                ],
              )
            )
          ),
        )
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _uid,
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: chat != null ? Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 0.0),
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: Material(
                  child: InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.announcement, size: 25, color: Colors.grey),
                      ]
                    ),
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
            Expanded(
              child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Form(
                  key: _messageFormKey,
                  child: TextFormField(
                    maxLines: null,
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter enter text here'
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  )
                ),
              )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: Material(
                  child: InkWell(
                    onTap: () {print("tapped");},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.send, size: 25, color: Colors.grey),
                      ]
                    ),
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
          ]
        )
      ) : SizedBox(width: 0.0, height: 0.0,),
      endDrawer: new SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        child: new Drawer(
          child: new Container(
            padding: const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Text('Tapis Carian', style: TextStyle(color: Colors.black, fontSize: 25)),
                ]
              )
            ),
          ),
        ),
      )
    );
  }
}
