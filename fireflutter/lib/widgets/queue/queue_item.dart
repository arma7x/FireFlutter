import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QueueItem extends StatelessWidget {

  final FirebaseUser currentUser;
  final dynamic userMetadata;
  final dynamic assignedUserMetadata;
  final dynamic queueData;
  final Function joinChatCb;
  final Function handleChatCb;

  QueueItem({Key key, this.currentUser, this.userMetadata, this.assignedUserMetadata, this.queueData, this.joinChatCb, this.handleChatCb});

  @override
  Widget build(BuildContext context) {

    return new Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Card(
        child: Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Row(
            children: <Widget>[
              Container(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: userMetadata['photoUrl'] != null ? CachedNetworkImageProvider(userMetadata['photoUrl']) : null,
                  child: userMetadata['photoUrl'] == null ? Icon(Icons.person, size: 50.0) : null,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            queueData['status'] != 0 ? Icons.lock : Icons.lock_open,
                          ),
                          Text(
                            queueData['topic'].length > 35 ? queueData['topic'].substring(0, 35) + '...' : queueData['topic'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                        ]
                      ),
                      SizedBox(height: 10),
                      Text(
                        userMetadata['name'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(queueData['timestamp']).toLocal().toString(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                          ),
                          queueData['assigned_user'] != false && queueData['assigned_user'] != currentUser.uid ? Text(
                            assignedUserMetadata['name'],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                          ) : SizedBox(width: 0, height: 0),
                        ]
                      ),
                    ]
                  ),
                ),
              ),
              Container(
                child: queueData['assigned_user'] == currentUser.uid || queueData['assigned_user'] == false
                ? queueData['assigned_user'] == currentUser.uid
                  ? SizedBox(
                      width: 76.0,
                      height: 76.0,
                      child: Material(
                        elevation: 4.0,
                        shape: CircleBorder(),
                        child: InkWell(
                          onTap: () { joinChatCb(queueData['key']); },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.chat, size: 30.0, color: Colors.white),
                            ]
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : (queueData['assigned_user'] == false
                    ? SizedBox(
                      width: 76.0,
                      height: 76.0,
                      child: Material(
                        elevation: 4.0,
                        shape: CircleBorder(),
                        child: InkWell(
                          onTap: () { handleChatCb(queueData['key']); },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.supervisor_account, size: 30.0, color: Colors.white),
                            ]
                          ),
                        ),
                        color: Colors.orange,
                      ),
                    )
                    : Text('ERROR')
                  )
                : CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: assignedUserMetadata['photoUrl'] != null ? CachedNetworkImageProvider(assignedUserMetadata['photoUrl']) : null,
                  child: assignedUserMetadata['photoUrl'] == null ? Icon(Icons.person, size: 50.0) : null,
                )
              ),
            ]
          )
        ),
      ),
    );
  }
}
