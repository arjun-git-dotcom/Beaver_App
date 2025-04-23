import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media/constants.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final String userID = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String callID = 'test_channel'; 

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

 Future<void> requestPermissions() async {
  
  var cameraStatus = await Permission.camera.status;
  var micStatus = await Permission.microphone.status;
  
  if (cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
    await openAppSettings();
    return;
  }
  

  await [Permission.camera, Permission.microphone].request();

  cameraStatus = await Permission.camera.status;
  micStatus = await Permission.microphone.status;
  
  if (!cameraStatus.isGranted || !micStatus.isGranted) {
   
    toast("Camera or microphone permission not granted",duration: Toast.LENGTH_SHORT);
    
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: int.parse(dotenv.env['APP_ID']!), 
        appSign: dotenv.env['APP_SIGN']!, 
        userID: userID,
        userName: 'User_$userID',
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
