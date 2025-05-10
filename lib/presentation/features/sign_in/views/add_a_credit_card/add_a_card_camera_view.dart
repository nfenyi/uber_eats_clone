import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:uber_eats_clone/main.dart';

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

class _AddACardCameraViewState extends State<AddACardCameraView>
    with WidgetsBindingObserver {
  final _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Future.delayed()
    _scanImage();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _textRecognizer.close();
    super.dispose();
  }

  @override
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = widget.controller;

    // App state changed before we got the chance to initialize.
    if (
        // cameraController == null ||
        !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (context.mounted) {
        navigatorKey.currentState!.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Transform.rotate(
                          angle: math.pi / 2,
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: widget.controller.buildPreview())),
                    ),
                  ],
                ),
                Container(
                  width: 350,
                  height: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5)),
                )
              ],
            ),
          ),
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

  Future<void> _scanImage() async {
    Timer.periodic(const Duration(seconds: 4), (timer) async {
      try {
        if (!mounted) {
          timer.cancel();
        } else {
          final pictureFile = await widget.controller.takePicture();
          final file = File(pictureFile.path);
          final inputImage = InputImage.fromFile(file);
          final recognizedText = await _textRecognizer.processImage(inputImage);
          final creditCardTextBlock = recognizedText.blocks.firstWhereOrNull(
            (element) => element.text.length >= 13,
          );
          if (creditCardTextBlock == null) {
            await file.delete();
          } else {
            if (context.mounted) {
              navigatorKey.currentState!.pop(creditCardTextBlock.text);
            }
          }
        }
      } catch (e) {
        // showInfoToast(e.toString(), context: navigatorKey.currentContext);
      }
    });
  }
}
