import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/cubit/image/image_cubit.dart';

class CameraCaptureWidget extends StatefulWidget {
  const CameraCaptureWidget({super.key});

  @override
  State<CameraCaptureWidget> createState() => _CameraCaptureWidgetState();
}

class _CameraCaptureWidgetState extends State<CameraCaptureWidget> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  Timer? _timer;
  int _countdown = 10;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
  _cameras = await availableCameras();

  final frontCamera = _cameras!.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
    orElse: () => _cameras!.first, 
  );

  _cameraController = CameraController(frontCamera, ResolutionPreset.medium);

  await _cameraController!.initialize();
  
await _cameraController!.setExposureMode(ExposureMode.auto);
await _cameraController!.setFocusMode(FocusMode.auto);


  if (!mounted) return;
  setState(() {});

  _startCountdown();
}

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          Navigator.pop(context);
        }
      });
    });
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;
    try {
      final XFile file = await _cameraController!.takePicture();
    
      context.read<ImageCubit>().selectImage(File(file.path));
      Navigator.pop(context); 
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title:  Text('Take a selfie',style: AppTextStyle.stylishfont(color: Colors.black),)),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_countdown',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  _takePicture();
                  _timer?.cancel();
                },
                icon: const Icon(Icons.camera_alt_rounded, size: 32, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
