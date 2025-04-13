import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<void> sendCallNotification({
  required String receiverToken,
  required String callerName,
  required String callID,
}) async {
  final url = Uri.parse('http://10.0.2.2:3000/send-notification'); 

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'receiverToken': receiverToken,
      'callerName': callerName,
      'callID': callID,
    }),
  );

  if (response.statusCode == 200) {
    print('Notification sent!');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}


Future<String?> getFCMToken() async {
  return await FirebaseMessaging.instance.getToken();
}