import 'dart:io';
import 'dart:core';
import 'package:firebase_core/firebase_core.dart';

class Api {

  static final FirebaseApp _instance = FirebaseApp.instance;
  static const String SELF_DESTRUCT_ACCOUNTURL = '/selfDestructAccount';
  static const String ENTER_QUEUEURL = '/enterQueue';
  static const String EXIT_QUEUEURL = '/exitQueue';
  static const String ADMIN_DELETE_QUEUEURL = 'adminDeleteQueue';
  static const String ADMIN_NOTIFY_CLIENTURL = '/adminNotifyClient';

  static Future<String> get baseUrl async {
    FirebaseOptions options = await _instance.options;
    return 'us-central1-${options.projectID}.cloudfunctions.net';
  }

  static Future selfDestructAccount(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, SELF_DESTRUCT_ACCOUNTURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future enterQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, ENTER_QUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future exitQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, EXIT_QUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminDeleteQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, ADMIN_DELETE_QUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminNotifyClient(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, ADMIN_NOTIFY_CLIENTURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }
}
