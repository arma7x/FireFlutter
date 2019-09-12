import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

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

  static final FirebaseStorage storage = FirebaseStorage();

  FirebaseUser _user;
  Map<dynamic, dynamic> _metadata;

  void _onImageButtonPressed(ImageSource source) async {
    try {
      final uuid = DateTime.now().millisecondsSinceEpoch.toString();
      final File photo = await ImagePicker.pickImage(source: source);
      await _uploadFile(photo, uuid + "_" + photo.path.split("/").last);
      print(uuid+"_"+photo.path.split("/").last);
    } catch (e) {
      Toast.show(e.toString(), context, duration: 5);
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select source:"),
          content: Container(
            height: 130,
            child: new Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: RaisedButton(
                  elevation: 0,
                  highlightElevation: 0,
                  padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.photo_library, size: 25, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        "Open Gallery",
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal)
                      ),
                    ]
                  )
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: RaisedButton(
                  elevation: 0,
                  highlightElevation: 0,
                  padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.camera_alt, size: 25, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        "Lauch Camera",
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal)
                      ),
                    ]
                  )
                ),
              )
            ]
          )),
        );
      },
    );
  }

  Future<void> _uploadFile(File blob, String name) async {
    final StorageReference ref = storage.ref().child('/user/${_user.uid}/avatar').child(name);
    final StorageUploadTask uploadTask = ref.putFile(blob);
    uploadTask.events.listen((StorageTaskEvent event) {
      if (event.type == StorageTaskEventType.progress) {
        print("ON PROGRESS");
      } else if (event.type == StorageTaskEventType.success) {
        print("SUCCESS");
      } if (event.type == StorageTaskEventType.failure) {
        print("FAILURE");
      }
    });
    uploadTask.onComplete
    .then((StorageTaskSnapshot data) async {
      print(await data.ref.getDownloadURL());
    })
    .catchError((error) async {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {

    _user = Provider.of<Auth>(context).user;
    _metadata = Provider.of<Auth>(context).metadata;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Center(
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
                              onPressed: _showDialog,
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
                    Container(
                      width: double.infinity,
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
                    Container(
                      width: double.infinity,
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
        ]
      ),
    );
  }
}
