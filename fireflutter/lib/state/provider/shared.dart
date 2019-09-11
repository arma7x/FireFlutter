import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared with ChangeNotifier {

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Shared(){
    _init();
  }

  bool _offline =  false;
  bool _loading = false;
  String _clientId;
  String _fcm;
  String _model = 'Unknown';

  bool get offline => _offline;
  bool get loading => _loading;
  String get clientId => _clientId;
  String get fcm => _fcm;
  String get model => _model;

  String _randomString(int length) {
    Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  void _init() async {
    final SharedPreferences prefs = await _prefs;
    try {
      this._clientId = prefs.getString('clientID');
      if (this._clientId == null) {
        this._clientId = _randomString(22);
        await prefs.setString('clientID', this._clientId);
      }
    } catch(e) {
      this._clientId = _randomString(22);
      await prefs.setString('clientID', this._clientId);
    }
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        _model = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        _model = iosInfo.utsname.machine;
      }
    } on PlatformException {
      _model = 'Unknown';
    }
  }

  void setOffline(bool offline) {
    _offline = offline;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _loading = loading;
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

  void setModel(String model) {
    _model = model;
    notifyListeners();
  }

  void addActiveDevice (String uid) {
    try {
      FirebaseDatabase.instance.reference().child('/users/' + uid + '/devices').set(<dynamic, dynamic>{
        _clientId: <dynamic, dynamic>{
          'client': _model,
          'datetime': new DateTime.now().millisecondsSinceEpoch,
          'fcm': _fcm
        }
      });
    } catch(e) {
      print("[SHARED::ADD]ACTIVE DEVICE ERROR::"+e.toString());
    }
  }

  void removeActiveDevice(String uid) {
    try {
      FirebaseDatabase.instance.reference().child('/users/' + uid + '/devices/' + _clientId).remove();
    } catch(e) {
      print("[SHARED::REMOVE]ACTIVE DEVICE ERROR::"+e.toString());
    }
  }
}
