import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title, this.uid, this.loadingCb}) : super(key: key);

  final String title;
  final String uid;
  final Function loadingCb;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  FirebaseUser _user;
  String uid;

  @override
  Widget build(BuildContext context) {

    final counter = Provider.of<Counter>(context);
    _user = Provider.of<Auth>(context).user;
    uid = widget.uid != null ? widget.uid : _user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              uid,
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
      floatingActionButton: FloatingActionButton(
        heroTag: "chat_fab",
        onPressed: () {
          Provider.of<Counter>(context, listen: false).increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
