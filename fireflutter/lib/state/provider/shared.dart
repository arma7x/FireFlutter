import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';

class Shared with ChangeNotifier {

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  bool _offline =  false;
  String _clientId;
  String _fcm;
  bool _loading = false;

  bool get offline => _offline;
  String get clientId => _clientId;
  String get fcm => _fcm;
  bool get loading => _loading;

  void setOffline(bool offline) {
    _offline = offline;
    notifyListeners();
  }

  void setClientID(String id) {
    _clientId = id;
    notifyListeners();
  }

  void setFCM(String fcm) {
    _fcm = fcm;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void addActiveDevice (String uid) async {
    String model = 'Unknown';
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        model = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        model = iosInfo.utsname.machine;
      }
    } on PlatformException {
      model = 'Unknown';
    }

    await FirebaseDatabase.instance.reference().child('/users/' + uid + '/devices').set(<String, dynamic>{
      _clientId: <String, dynamic>{
        'client': model,
        'datetime': new DateTime.now().millisecondsSinceEpoch,
        'fcm': _fcm
      }
    });
    await FirebaseDatabase.instance.reference().child('/users/' + uid + '/online').set(true);
    await FirebaseDatabase.instance.reference().child('/users/' + uid + '/last_online').set(ServerValue);
  }

  void removeActiveDevice(String uid) async {
    await FirebaseDatabase.instance.reference().child('/users/' + uid + '/devices/' + _clientId).remove();
    await FirebaseDatabase.instance.reference().child('/users/' + uid + '/online').set(true);
    await FirebaseDatabase.instance.reference().child('/users/' + uid + '/last_online').set(ServerValue);
  }
}
