import 'dart:io';
import 'dart:core';
import 'package:fireflutter/config.dart';

class Api {

  static const String BASE_URL = 'us-central1-${Config.PROJECT_ID}.cloudfunctions.net';
  static const String SELFDESTRUCTACCOUNTURL = '/selfDestructAccount';
  static const String JOINQUEUEURL = '/joinQueue';
  static const String DELETEQUEUEURL = '/deleteQueue';
  static const String ADMINDELETEQUEUEURL = 'adminDeleteQueue';
  static const String ADMINNOTIFYCLIENTURL = '/adminNotifyClient';

  static Future selfDestructAccount(Map<String, String> queryParameters) {
    final url = Uri.https(BASE_URL, SELFDESTRUCTACCOUNTURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future joinQueue(Map<String, String> queryParameters) {
    final url = Uri.https(BASE_URL, JOINQUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future deleteQueue(Map<String, String> queryParameters) {
    final url = Uri.https(BASE_URL, DELETEQUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminDeleteQueue(Map<String, String> queryParameters) {
    final url = Uri.https(BASE_URL, ADMINDELETEQUEUEURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminNotifyClient(Map<String, String> queryParameters) {
    final url = Uri.https(BASE_URL, ADMINNOTIFYCLIENTURL, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }
}
