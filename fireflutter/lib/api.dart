import 'dart:io';
import 'dart:core';
import 'package:firebase_core/firebase_core.dart';

class Api {

  static final FirebaseApp _instance = FirebaseApp.instance;
  static const String SELF_DESTRUCT_ACCOUNT = '/selfDestructAccount';
  static const String ENTER_QUEUE = '/enterQueue';
  static const String EXIT_QUEUE = '/exitQueue';
  static const String NOTIFY_SUPERVISOR = '/notifySupervisor';
  static const String ADMIN_SUPERVISE_QUEUE = '/adminSuperviseQueue';
  static const String ADMIN_DELETE_QUEUE = 'adminDeleteQueue';
  static const String ADMIN_NOTIFY_CLIENT = '/adminNotifyClient';

  static Future<String> get baseUrl async {
    FirebaseOptions options = await _instance.options;
    return 'us-central1-${options.projectID}.cloudfunctions.net';
  }

  static Future selfDestructAccount(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, SELF_DESTRUCT_ACCOUNT, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future enterQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, ENTER_QUEUE, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future exitQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, EXIT_QUEUE, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future notifySupervisor(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, NOTIFY_SUPERVISOR, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminSuperviseQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, ADMIN_SUPERVISE_QUEUE, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminDeleteQueue(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, ADMIN_DELETE_QUEUE, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }

  static Future adminNotifyClient(Map<String, String> queryParameters) async {
    final url = Uri.https(await baseUrl, ADMIN_NOTIFY_CLIENT, queryParameters);
    final httpClient = HttpClient();
    return httpClient.getUrl(url);
  }
}
