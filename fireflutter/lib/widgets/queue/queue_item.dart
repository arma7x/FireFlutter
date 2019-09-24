import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fireflutter/widgets/misc_widgets.dart';

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

    double _pxRatio = MediaQuery.of(context).devicePixelRatio;

    return new Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Card(
        child: Container(
          margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    queueData['status'] != 0 ? Icons.lock : Icons.lock_open,
                    color: queueData['status'] != 0 ? Colors.red : Colors.green,
                    size: 13.0
                  ),
                  SizedBox(width: 2),
                  Expanded(child: Text(
                    queueData['topic'],
                    style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
                  )),
                ]
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Container(
                    child: CircleAvatarIcon(url: userMetadata['photoUrl'], radius: 13),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.keyboard_arrow_left,
                                color: Theme.of(context).primaryColor,
                                size: 13.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Client',
                                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    userMetadata['name'],
                                    style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal, color: Colors.grey),
                                  ),
                                ]
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              queueData['assigned_user'] != false && queueData['assigned_user'] != currentUser.uid ? 
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'Supervisor',
                                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    assignedUserMetadata['name'],
                                    style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.normal, color: Colors.grey),
                                  ),
                                ]
                              ) : SizedBox(width:0, height: 0),
                              queueData['assigned_user'] != false && queueData['assigned_user'] != currentUser.uid ? Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).primaryColor,
                                size: 13.0,
                              ) : SizedBox(width:0, height: 0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: queueData['assigned_user'] == currentUser.uid || queueData['assigned_user'] == false
                    ? queueData['assigned_user'] == currentUser.uid
                      ? SizedBox(
                          width: 26.0 * _pxRatio,
                          height: 26.0 * _pxRatio,
                          child: Material(
                            elevation: 1.0,
                            shape: CircleBorder(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular((26.0 * _pxRatio) / 2),
                              onTap: () { joinChatCb(queueData['key']); },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.chat, size: 12.0 * _pxRatio, color: Colors.white),
                                ]
                              ),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : (queueData['assigned_user'] == false
                        ? SizedBox(
                          width: 26.0 * _pxRatio,
                          height: 26.0 * _pxRatio,
                          child: Material(
                            elevation: 1.0,
                            shape: CircleBorder(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular((26.0 * _pxRatio) / 2),
                              onTap: () { handleChatCb(queueData['key']); },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.supervisor_account, size: 12.0 * _pxRatio, color: Colors.white),
                                ]
                              ),
                            ),
                            color: Colors.orange,
                          ),
                        )
                        : Text('ERROR')
                      )
                    : CircleAvatarIcon(url: assignedUserMetadata['photoUrl'], radius: 13)
                  ),
                ]
              ),
              SizedBox(height: 10),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.calendar_today, color: Theme.of(context).primaryColor, size: 9.0),
                        SizedBox(width: 5),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(queueData['timestamp']).toLocal().toString().substring(0, 19),
                          style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.normal, color: Colors.grey),
                        ),
                      ]
                    ),
                  ]
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}
