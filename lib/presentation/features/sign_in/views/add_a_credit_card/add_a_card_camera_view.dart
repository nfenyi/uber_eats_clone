import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_text.dart';

class AddACardCameraView extends StatefulWidget {
  final CameraController controller;
  const AddACardCameraView(
    this.controller, {
    super.key,
  });

  @override
  State<AddACardCameraView> createState() => _AddACardCameraViewState();
}

class _AddACardCameraViewState extends State<AddACardCameraView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

//   @override
// void didChangeAppLifecycleState(AppLifecycleState state) {
//   final CameraController? cameraController = controller;

//   // App state changed before we got the chance to initialize.
//   if (cameraController == null || !cameraController.value.isInitialized) {
//     return;
//   }

//   if (state == AppLifecycleState.inactive) {
//     cameraController.dispose();
//   } else if (state == AppLifecycleState.resumed) {
//     _initializeCameraController(cameraController.description);
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(child: widget.controller.buildPreview()),
          Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.white,
              child: const Column(children: [
                AppText(
                  text: 'Scan your card',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
                Gap(10),
                AppText(
                  text: 'Ensure the card number is visible',
                  size: AppSizes.bodySmall,
                )
              ]))
        ],
      ),
    );
  }
}
