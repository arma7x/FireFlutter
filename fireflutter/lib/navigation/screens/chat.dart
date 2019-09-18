import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fireflutter/api.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fireflutter/widgets/misc_widgets.dart';

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
  Map<dynamic, dynamic> _metadata;
  String _uid;
  List<Widget> chat_log;
  Map<dynamic, dynamic> chat;
  Map<dynamic, dynamic> _assignedUserMetadata;
  Map<dynamic, dynamic> _queueUserMetadata;
  Map<dynamic, dynamic> _queueUserMetadataPrivate;

  DatabaseReference _queueUserMetadataRef;
  DatabaseReference _queueUserMetadataPrivateRef;
  DatabaseReference _chatRef;

  final GlobalKey<FormState> _topicFormKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();

  final GlobalKey<FormState> _messageFormKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _uid = widget.any;
    _init();
  }

  void _init() {
    if (_queueUserMetadata == null) {
      _queueUserMetadataRef = FirebaseDatabase.instance.reference().child('users_public/' + _uid);
      _queueUserMetadataRef.onValue.listen((Event event) {
        if (event.snapshot.value != null) {
          var u = new Map<dynamic, dynamic>.from(event.snapshot.value);
          setState(() { _queueUserMetadata = u; });
        }
      });
    }

    _queueUserMetadataPrivateRef = FirebaseDatabase.instance.reference().child('users/' + _uid);
    _queueUserMetadataPrivateRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        var u = new Map<dynamic, dynamic>.from(event.snapshot.value);
        setState(() { _queueUserMetadataPrivate = u; });
      }
    });

    _chatRef = FirebaseDatabase.instance.reference().child('chats/' + _uid);
    _chatRef.onValue.listen((Event event) async {
      if (event.snapshot.value != null) {
        var c = new Map<dynamic, dynamic>.from(event.snapshot.value);
        setState(() { chat = c; });
        if (event.snapshot.value['assigned_user'] != false && _assignedUserMetadata == null) {
          FirebaseDatabase.instance.reference().child('users_public/' + event.snapshot.value['assigned_user'])
          .onValue.listen((Event event) {
            if (event.snapshot.value != null) {
              var u = new Map<dynamic, dynamic>.from(event.snapshot.value);
              setState(() { _assignedUserMetadata = u; });
            }
          });
        }
        if (event.snapshot.value['logs'] != null) {
          List<Map<dynamic,dynamic>> tempLogData = List();
          List<Widget> tempLogWidget = List();
          event.snapshot.value['logs'].forEach((k,v) {
            var data = new Map<dynamic, dynamic>.from(v);
            tempLogData.add(data);
            data['key'] = k;
          });
          tempLogData.sort((m1, m2) {
            var r = m1["timestamp"].compareTo(m2["timestamp"]);
            if (r != 0)
              return r;
            return m1["timestamp"].compareTo(m2["timestamp"]);
          });
          for (var i in tempLogData) {
            List<Widget> dataWidget = List();
            var data = new Map<dynamic, dynamic>.from(i);
            if (data['user'] != _user.uid && data['user'] == chat['assigned_user']) {
              dataWidget.add(CircleAvatarIcon(url: _assignedUserMetadata == null ? null : _assignedUserMetadata['photoUrl'], radius: 20));
            }
            if (data['user'] != _user.uid && data['user'] == _uid) {
              dataWidget.add(CircleAvatarIcon(url: _queueUserMetadata == null ? null : _queueUserMetadata['photoUrl'], radius: 20));
            }
            dataWidget.add(
              Container(
                margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                child: Card(
                  child: Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: MediaQuery.of(context).size.width * 0.60),
                    margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: data['user'] == _user.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data['message']['data'] != null ? data['message']['data'] : "-",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal)
                        ),
                        SizedBox(height: 10, width: 0),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(data['timestamp']).toLocal().toString().substring(0, 19),
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.normal, color: Colors.grey),
                        )
                      ]
                    )
                  )
                )
              )
            );
            if (data['user'] == _user.uid){
              dataWidget.add(CircleAvatarIcon(url: _user.photoUrl, radius: 20));
            }
            tempLogWidget.add(
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                child: Row(
                  mainAxisAlignment: data['user'] == _user.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: dataWidget
                )
              )
            );
          }
          setState(() {
            chat_log = tempLogWidget;
          });
          Timer(Duration(milliseconds: 500), () {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });
        }
      } else {
        setState(() { chat = null; });
        FirebaseUser u = await _auth.currentUser();
        if (u.uid != _uid) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageFormKey.currentState.validate()) {
      Map<String, dynamic> data = {
        'user': _user.uid,
        'timestamp': ServerValue.timestamp,
        'message': {
          'mime': 'text',
          'data': _messageController.text,
          'caption': ''
        }
      };
      try {
        await _chatRef.child('/logs').push().set(data);
        _messageFormKey.currentState.reset();
        _messageController.clear();
      } catch(e) {
        print(e);
      }
    }
  }

  void _enterQueue() {
    if (_topicFormKey.currentState.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext _) {
          return AlertDialog(
            title: new Text("Are sure to enter queue list ?"),
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
                  .then((String token) => Api.enterQueue(<String, String>{ 'token': token, 'topic': _topicController.text }))
                  .then((request) => request.close())
                  .then((response) async {
                    widget.loadingCb(false);
                    final responseBody = await response.cast<List<int>>().transform(utf8.decoder).join();
                    final Map<String, dynamic> parsedBody = json.decode(responseBody);
                    Toast.show(parsedBody['message'], context, duration: 5);
                    _topicFormKey.currentState.reset();
                    _topicController.clear();
                  })
                  .catchError((e) {
                    print(e);
                    widget.loadingCb(false);
                    Toast.show(e.toString(), context, duration: 5);
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _exitQueue() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: new Text("Are sure to exit from queue list ?"),
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
                .then((String token) => Api.exitQueue(<String, String>{ 'token': token }))
                .then((request) => request.close())
                .then((response) async {
                  widget.loadingCb(false);
                  final responseBody = await response.cast<List<int>>().transform(utf8.decoder).join();
                  final Map<String, dynamic> parsedBody = json.decode(responseBody);
                  Toast.show(parsedBody['message'], context, duration: 5);
                })
                .catchError((e) {
                  print(e);
                  widget.loadingCb(false);
                  Toast.show(e.toString(), context, duration: 5);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _adminToggleStatus(bool _) async {
    try {
      Map<String, dynamic> status = { 'status': (chat['status'] == 0 ? 1 : 0) };
      await _chatRef.update(status);
      await FirebaseDatabase.instance.reference().child('queues/' + _uid).update(status);
    } catch(e) {
      print(e);
    }
  }

  void _adminNotifyClient() {
    Navigator.of(context).pop();
    widget.loadingCb(true);
    _auth.currentUser()
    .then((FirebaseUser u) => u.getIdToken(refresh: true))
    .then((String token) => Api.adminNotifyClient(<String, String>{ 'token': token, 'queue': _uid }))
    .then((request) => request.close())
    .then((response) async {
      widget.loadingCb(false);
      final responseBody = await response.cast<List<int>>().transform(utf8.decoder).join();
      final Map<String, dynamic> parsedBody = json.decode(responseBody);
      Toast.show(parsedBody['message'], context, duration: 5);
    })
    .catchError((e) {
      print(e);
      widget.loadingCb(false);
      Toast.show(e.toString(), context, duration: 5);
    });
  }

  void _adminDeleteQueue() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: new Text("Are sure to remove this chat from queue list ?"),
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
                .then((String token) => Api.adminDeleteQueue(<String, String>{ 'token': token, 'queue': _uid }))
                .then((request) => request.close())
                .then((response) async {
                  widget.loadingCb(false);
                  final responseBody = await response.cast<List<int>>().transform(utf8.decoder).join();
                  final Map<String, dynamic> parsedBody = json.decode(responseBody);
                  Toast.show(parsedBody['message'], context, duration: 5);
                })
                .catchError((e) {
                  print(e);
                  widget.loadingCb(false);
                  Toast.show(e.toString(), context, duration: 5);
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
    _queueUserMetadataRef.onDisconnect().cancel();
    _queueUserMetadataPrivateRef.onDisconnect().cancel();
    _chatRef.onDisconnect().cancel();
  }

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<Auth>(context).user;
    _metadata = Provider.of<Auth>(context).metadata;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          const Text(''),
        ],
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
                        onPressed: _enterQueue
                      ),
                    )
                  ),
                ],
              )
            )
          ),
        )
      : Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            chat_log != null
            ? Expanded(
              child: ListView(
                controller: _scrollController,
                children: chat_log,
              ),
            ) : Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Be nice to each others',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                ],
              )
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                              Icon(Icons.announcement, size: 18.0, color: Colors.grey),
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
                            hintText: 'Please enter your message here'
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
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: Material(
                        child: InkWell(
                          onTap: _sendMessage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.send, size: 18.0, color: Colors.grey),
                            ]
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ]
              )
            )
          ]
        ),
      ),
      endDrawer: chat != null ? new SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        child: new Drawer(
          child: new Container(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: <Widget>[
                  ListViewChild(
                    title: 'Topic',
                    subtitle: chat['topic'] == null ? "" : chat['topic'],
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  ),
                  ListViewChild(
                    title: 'Timestamp',
                    subtitle: chat['timestamp'] == null ? "" : DateTime.fromMillisecondsSinceEpoch(chat['timestamp']).toLocal().toString().substring(0, 19),
                    margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                  ),
                  _assignedUserMetadata != null ? ListViewWidget(
                    margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    widget: Row(
                      children: <Widget>[
                        CircleAvatarIcon(url: _assignedUserMetadata['photoUrl'], radius: 20),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Supervisor',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)
                            ),
                            SizedBox(height: 5),
                            Text(
                              _assignedUserMetadata['name'] == null ? "" : _assignedUserMetadata['name'],
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey)
                            ),
                          ]
                        ),
                      ]
                    )
                  ) : SizedBox(height: 0, width: 0),
                  _queueUserMetadata != null ? ListViewWidget(
                    margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    widget: Row(
                      children: <Widget>[
                        CircleAvatarIcon(url: _queueUserMetadata['photoUrl'], radius: 20),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Client',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)
                            ),
                            SizedBox(height: 5),
                            Text(
                              _queueUserMetadata['name'] == null ? "" : _queueUserMetadata['name'],
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey)
                            ),
                          ]
                        ),
                      ]
                    )
                  ) : SizedBox(height: 0, width: 0),
                  _metadata['role'] == 1 ? ListViewWidget(
                    margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                    widget: Column(
                      children: <Widget>[
                        _queueUserMetadataPrivate != null
                        ? ListViewChild(
                          title: 'Client Status',
                          subtitle: _queueUserMetadataPrivate['online'] != true ? 'Last seen ' + DateTime.fromMillisecondsSinceEpoch(_queueUserMetadataPrivate['last_online']).toLocal().toString().substring(0, 19) : 'Online',
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 00.0, 0.0),
                        ) : SizedBox(height: 0, width: 0),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Status',
                                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal)
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        chat['status'] != 0 ? Icons.lock : Icons.lock_open,
                                        color: chat['status'] != 0 ? Colors.red : Colors.green,
                                        size: 12.0,
                                      ),
                                    ]
                                  ),
                                  SizedBox(height: 0),
                                  Switch(
                                    value: (chat['status'] == 0 ? false : true),
                                    activeColor: Theme.of(context).primaryColor,
                                    activeTrackColor: Colors.blue[100],
                                    onChanged: _adminToggleStatus
                                  ),
                                ]
                              ),
                              chat['status'] == 0
                              ? Container(
                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: RaisedButton(
                                  onPressed: _adminDeleteQueue,
                                  color: Colors.redAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.delete, size: 12.0, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        "Delete Queue",
                                        style: TextStyle(color: Colors.white, fontSize: 12.0,),
                                      ),
                                    ]
                                  )
                                ),
                              ) : SizedBox(height: 0, width: 0)
                            ]
                          )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                          child: RaisedButton(
                            onPressed: _adminNotifyClient,
                            color: Colors.green,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.notification_important, size: 12.0, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "Notify Client",
                                  style: TextStyle(color: Colors.white, fontSize: 12.0,),
                                ),
                              ]
                            )
                          )
                        ),
                      ]
                    )
                  ) : SizedBox(height: 0, width: 0), //admin
                  _user.uid == _uid && chat['status'] == 0
                  ? ListViewWidget(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    widget: RaisedButton(
                      onPressed: _exitQueue,
                      color: Colors.redAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.delete, size: 12.0, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Delete Queue",
                            style: TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                        ]
                      )
                    )
                  ) : SizedBox(height: 0, width: 0), //client
                ]
              )
            ),
          ),
        ),
      ) : null
    );
  }
}
