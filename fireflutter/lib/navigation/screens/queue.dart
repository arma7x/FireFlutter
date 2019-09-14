import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/widgets/queue_widgets.dart';

class QueuePage extends StatefulWidget {
  QueuePage({Key key, this.title, this.loadingCb}) : super(key: key);

  final String title;
  final Function loadingCb;

  @override
  _QueuePageState createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {

  FirebaseUser _user;
  Map<dynamic, dynamic> _usersMetadata;
  List<Map<dynamic, dynamic>> _queue;
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
    _queueRef.orderByChild('timestamp').onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        List<Widget> queueWidgets = List();
        List<Map<dynamic, dynamic>> queue = List();
        event.snapshot.value.forEach((k,v) {
          var queue_data = new Map<dynamic, dynamic>.from(v);
          queue_data['key'] = k;
          queue.add(queue_data);
          queueWidgets.add(QueueItem(current_user: _user, user_metadata: _usersMetadata[k], queue_data: queue_data));
        });
        queue.sort((a, b) => (a['timestamp'] > b['timestamp']) ? 1 : -1);
        setState(() {
          _queue = queue;
          _queueWidgets = queueWidgets;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userRef.onDisconnect().cancel();
    _queueRef.onDisconnect().cancel();
  }

  @override
  Widget build(BuildContext context) {

    final counter = Provider.of<Counter>(context);
    _user = Provider.of<Auth>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _queueWidgets == null ? <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.display1,
            ),
          ] : _queueWidgets,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<Counter>(context, listen: false).increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
