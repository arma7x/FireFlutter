import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:fireflutter/widgets/profile_widgets.dart';
import 'package:fireflutter/widgets/misc_widgets.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.title, this.loadingCb}) : super(key: key);

  final String title;
  final Function loadingCb;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  static final FirebaseStorage storage = FirebaseStorage();

  FirebaseUser _user;
  Map<dynamic, dynamic> _metadata;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  double _pxRatio;

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

  Future<void> _uploadFile(File blob, String name) async {
    final StorageReference ref = storage.ref().child('/user/${_user.uid}/avatar').child(name);
    final StorageUploadTask uploadTask = ref.putFile(blob);
    uploadTask.events.listen((StorageTaskEvent event) {
      if (event.type == StorageTaskEventType.progress) {
        Toast.show('Uploading', context, duration: 3);
      } else if (event.type == StorageTaskEventType.success) {
        Toast.show('Successfully uploaded', context, duration: 3);
      } if (event.type == StorageTaskEventType.failure) {
        Toast.show('Fail during uploading', context, duration: 3);
      }
    });
    uploadTask.onComplete
    .then((StorageTaskSnapshot data) async {
      UserUpdateInfo payload = UserUpdateInfo();
      payload.photoUrl = await data.ref.getDownloadURL();
      widget.loadingCb(true);
      await Provider.of<Auth>(context).updateUserProfile(payload);
      widget.loadingCb(false);
    })
    .catchError((error) async {
      print(error);
      Navigator.of(context).pop();
    });
  }

  void _updateDisplayName(String name) async {
    UserUpdateInfo payload = UserUpdateInfo();
    payload.displayName = name;
    widget.loadingCb(true);
    await Provider.of<Auth>(context).updateUserProfile(payload);
    widget.loadingCb(false);
  }

  void _selectImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Select source:",
            style: TextStyle(fontSize: 16.0),
          ),
          content: Container(
            height: 110,
            child: new Column(
            children: <Widget>[
              DialogButton(text: "Open Gallery", icon: Icons.photo_library, fn: () {
                _onImageButtonPressed(ImageSource.gallery);
                Navigator.of(context).pop();
              }),
              SizedBox(height: 4),
              DialogButton(text: "Lauch Camera", icon: Icons.camera_alt, fn: () {
                _onImageButtonPressed(ImageSource.camera);
                Navigator.of(context).pop();
              }),
            ]
          )),
        );
      },
    );
  }

  void _deleteAccount() async {
    Navigator.of(context).pop();
    widget.loadingCb(true);
    final Map<String, dynamic> status = await Provider.of<Auth>(context).selfDestructAccount();
    Toast.show(status['message'], context, duration: 5);
    print(status);
    widget.loadingCb(false);
    if (status['statusCode'] == 200) {
      Provider.of<Auth>(context, listen: false).signOut();
      Navigator.of(context).pop();
    }
  }

  void _confirmDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Confirm to delete your account ?",
            style: TextStyle(fontSize: 16.0),
          ),
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
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    _user = Provider.of<Auth>(context).user;
    _nameController.text = _user?.displayName != null ? _user.displayName : "Unknown";
    _metadata = Provider.of<Auth>(context).metadata;
    _pxRatio = MediaQuery.of(context).devicePixelRatio;

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
                margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                width: (MediaQuery.of(context).size.width - 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 80 * _pxRatio,
                      child:Stack(
                        children: <Widget>[
                          Center(
                            child: CircleAvatarIcon(url: _user?.photoUrl, radius: 28.0),
                          ),
                          Positioned(
                            right: 6 * _pxRatio,
                            bottom: 0.0,
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: Theme.of(context).primaryColor,
                              onPressed: _selectImageSourceDialog,
                              child: Icon(Icons.camera_alt, size: 8.0 * _pxRatio),
                            )
                          ),
                        ]
                      )
                    ),
                    ListViewChild(
                      title: 'UID',
                      subtitle: _user?.uid == null ? "" : _user.uid,
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    ),
                    ListViewWidget(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                      widget: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 11.0),
                          decoration: InputDecoration(
                            labelText: 'NAME',
                            labelStyle: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        )
                      )
                    ),
                    ListViewChild(
                      title: 'Email',
                      subtitle: _user?.email == null ? "" : _user.email,
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    ),
                    ListViewChild(
                      title: 'Admin',
                      subtitle: _metadata != null ? (_metadata['role'] == 1 ? 'TRUE' : 'FALSE') : 'FALSE',
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    ),
                    ListViewWidget(
                      margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                      widget: RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _updateDisplayName(_nameController.text);
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ),
                    ListViewWidget(
                      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                      widget: RaisedButton(
                        onPressed: _confirmDeleteAccountDialog,
                        color: Colors.redAccent,
                        child: Text(
                          "Self-Destruct Account",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ),
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
