import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/widgets/queue_widgets.dart';
import 'package:fireflutter/api.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:fireflutter/navigation/screens.dart' show ChatPage;
import 'package:toast/toast.dart';

class QueuePage extends StatefulWidget {
  QueuePage({Key key, this.title, this.loadingCb}) : super(key: key);

  final String title;
  final Function loadingCb;

  @override
  _QueuePageState createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  Map<dynamic, dynamic> _usersMetadata;
  List<Widget> _queueWidgets;
  DatabaseReference _queueRef;
  DatabaseReference _userRef;

  @override
  void initState() {
    super.initState();

    _userRef = FirebaseDatabase.instance.reference().child('users_public');
    _userRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        var u = new Map<dynamic, dynamic>.from(event.snapshot.value);
        setState(() {
          _usersMetadata = u;
        });
      }
    });

    _queueRef = FirebaseDatabase.instance.reference().child('queues');
    _queueRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        List<Map<dynamic,dynamic>> tempQueueData = List();
        List<Widget> queueWidgets = List();
        event.snapshot.value.forEach((k,v) {
          var data = new Map<dynamic, dynamic>.from(v);
          tempQueueData.add(data);
          data['key'] = k;
        });
        tempQueueData.sort((m1, m2) {
          var r = m1["timestamp"].compareTo(m2["timestamp"]);
          if (r != 0)
            return r;
          return m1["timestamp"].compareTo(m2["timestamp"]);
        });
        for (var i in tempQueueData) {
          var queueData = new Map<dynamic, dynamic>.from(i);
          dynamic assignedUserMetadata = queueData['assigned_user'] != false ? _usersMetadata[queueData['assigned_user']] : null;
          queueWidgets.add(QueueItem(currentUser: _user, userMetadata: _usersMetadata[queueData['key']], assignedUserMetadata: assignedUserMetadata, queueData: queueData, joinChatCb: _joinChat, handleChatCb: _handleChat));
        };
        setState(() {
          _queueWidgets = queueWidgets;
        });
      }
    });
  }

  void _joinChat(String id) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) => new ChatPage(title:"Chat", any: id, loadingCb: widget.loadingCb))
    );
  }

  void _handleChat(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are sure to put this queue under your supervision ?"),
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
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  widget.loadingCb(true);
                  final Map<String, dynamic> updateData = { 'assigned_user': _user.uid, 'status': 1 };
                  await FirebaseDatabase.instance.reference().child('/queues/' + id).update(updateData);
                  await FirebaseDatabase.instance.reference().child('/chats/' + id).update(updateData);
                  _auth.currentUser()
                  .then((FirebaseUser u) => u.getIdToken(refresh: true))
                  .then((String token) => Api.adminNotifyClient(<String, String>{'token': token, 'queue': id}))
                  .then((request) => request.close());
                  widget.loadingCb(false);
                  _joinChat(id);
                } catch(e) {
                  widget.loadingCb(false);
                  Toast.show(e.toString(), context, duration: 5);
                }
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
    _userRef.onDisconnect().cancel();
    _queueRef.onDisconnect().cancel();
  }

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<Auth>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: _queueWidgets != null
        ? ListView(children: _queueWidgets)
        : Center(
          child: Text(
            'No user in queue list',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
