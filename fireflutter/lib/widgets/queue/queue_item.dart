import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QueueItem extends StatelessWidget {

  final FirebaseUser current_user;
  final dynamic user_metadata;
  final dynamic queue_data;

  QueueItem({Key key, this.current_user, this.user_metadata, this.queue_data}) {
    print(user_metadata.runtimeType);
    print(queue_data.runtimeType);
  }

  @override
  Widget build(BuildContext context) {

    return new Container(
      width: double.infinity,
      child: Text('123123'),
    );
  }
}
