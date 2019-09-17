import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/widgets/misc_widgets.dart';
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
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: CircleAvatarIcon(url: userMetadata['photoUrl'], radius: 35),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                queueData['status'] != 0 ? Icons.lock : Icons.lock_open,
                                color: queueData['status'] != 0 ? Colors.red : Colors.green,
                                size: 20.0
                              ),
                              SizedBox(width: 5),
                              Expanded(child: Text(
                                queueData['topic'],
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                              )),
                            ]
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(Icons.calendar_today, color: Theme.of(context).primaryColor, size: 20.0),
                              SizedBox(width: 5),
                              Expanded(child: Text(
                                DateTime.fromMillisecondsSinceEpoch(queueData['timestamp']).toLocal().toString().substring(0, 19),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
                              )),
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
                          width: 70.0,
                          height: 70.0,
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
                          width: 70.0,
                          height: 70.0,
                          child: Material(
                            elevation: 2.0,
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
                    : CircleAvatarIcon(url: assignedUserMetadata['photoUrl'], radius: 35)
                  ),
                ]
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userMetadata['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    queueData['assigned_user'] != false && queueData['assigned_user'] != currentUser.uid ? Text(
                      assignedUserMetadata['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    ) : SizedBox(width:0, height: 0),
                  ]
                ),
              )
            ]
          )
        ),
      ),
    );
  }
}
