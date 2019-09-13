import 'dart:io';
import 'dart:core';
import 'package:fireflutter/config.dart';
import 'package:firebase_core/firebase_core.dart';

class Api {

  static final FirebaseApp _instance = FirebaseApp.instance;
  static const String SELFDESTRUCTACCOUNTURL = '/selfDestructAccount';
  static const String JOINQUEUEURL = '/joinQueue';
  static const String DELETEQUEUEURL = '/deleteQueue';
  static const String ADMINDELETEQUEUEURL = 'adminDeleteQueue';
  static const String ADMINNOTIFYCLIENTURL = '/adminNotifyClient';

  static Future<String> get BASE_URL async {
    FirebaseOptions options = await _instance.options;
    return 'us-central1-${options.projectID}.cloudfunctions.net';
  }

  static Future selfDestructAccount(Map<String, String> queryParameters) async {
    final url = Uri.https(await BASE_URL, SELFDESTRUCTACCOUNTURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future joinQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await BASE_URL, JOINQUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future deleteQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await BASE_URL, DELETEQUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminDeleteQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await BASE_URL, ADMINDELETEQUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminNotifyClient(Map<String, String> queryParameters) async {
    final url = Uri.https(await BASE_URL, ADMINNOTIFYCLIENTURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }
}
