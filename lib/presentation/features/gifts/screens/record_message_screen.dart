import 'dart:io';

import 'package:camera/camera.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:video_player/video_player.dart';

class RecordMessageScreen extends StatefulWidget {
  final CameraController cameraController;
  final List<CameraDescription> availableCameras;
  const RecordMessageScreen(
      {super.key,
      required this.cameraController,
      required this.availableCameras});

  @override
  State<RecordMessageScreen> createState() => _RecordMessageScreenState();
}

class _RecordMessageScreenState extends State<RecordMessageScreen>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late CustomTimerController _timerController;
  late CameraController _cameraController;
  VideoPlayerController? _preparedVideoController;

  XFile? _videoFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black38,
      ));
    });
    _timerController = CustomTimerController(
        vsync: this,
        begin: const Duration(),
        end: const Duration(minutes: 30),
        initialState: CustomTimerState.reset,
        interval: CustomTimerInterval.milliseconds);
    _cameraController = widget.cameraController;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    if (_preparedVideoController != null) {
      _preparedVideoController!.dispose();
    }
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const AppText(
          text: 'Record your message',
          color: Colors.white,
          size: AppSizes.body,
        ),
        leading: GestureDetector(
          onTap: navigatorKey.currentState!.pop,
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          (_videoFile == null)
              ? _cameraController.buildPreview()
              : FutureBuilder<VideoPlayerController>(
                  future: _prepareController(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _preparedVideoController = snapshot.data!;
                      return VideoPlayer(_preparedVideoController!);
                    } else if (snapshot.hasError) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppText(
                              text: snapshot.error.toString(),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppText(
                              text: 'Loading your video...',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    }
                  }),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_videoFile == null)
                  CustomTimer(
                      controller: _timerController,
                      builder: (state, time) {
                        if (time.minutes == '20') {
                          _cameraController.stopVideoRecording();
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          padding: const EdgeInsets.all(8),
                          child: AppText(
                            text: "${time.minutes}:${time.seconds}",
                          ),
                        );
                      }),
                const Gap(25),
                (_videoFile == null)
                    //center widget because of stop button
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: _isRecording
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (!_isRecording)
                            StatefulBuilder(builder: (context, setState) {
                              return InkWell(
                                  onTap: () async {
                                    await _cameraController.setFlashMode(
                                        _cameraController.value.flashMode ==
                                                FlashMode.off
                                            ? FlashMode.torch
                                            : FlashMode.off);

                                    setState(() {});
                                  },
                                  child: Ink(
                                      child: Icon(
                                          size: 25,
                                          color: Colors.white,
                                          _cameraController.value.flashMode ==
                                                  FlashMode.torch
                                              ? Icons.flash_off
                                              : Icons.flash_on)));
                            }),
                          TextButton(
                              onPressed: () async {
                                if (_isRecording) {
                                  _timerController.pause();
                                  _videoFile = await _cameraController
                                      .stopVideoRecording();
                                } else {
                                  _timerController.start();
                                  await _cameraController.startVideoRecording();
                                }
                                setState(() {
                                  _isRecording = _timerController.state.value ==
                                      CustomTimerState.counting;
                                });
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: _isRecording
                                      ? Colors.red
                                      : Colors.transparent,
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                        color: Colors.white, width: 2),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  size: 20,
                                  _isRecording ? Icons.square : Icons.circle,
                                  color: Colors.white,
                                ),
                              )),
                          if (!_isRecording)
                            InkWell(
                              onTap: () async {
                                CameraDescription temp;
                                if (_cameraController
                                        .description.lensDirection ==
                                    CameraLensDirection.back) {
                                  temp = widget.availableCameras.firstWhere(
                                    (element) =>
                                        element.lensDirection ==
                                        CameraLensDirection.front,
                                  );
                                } else {
                                  temp = widget.availableCameras.firstWhere(
                                    (element) =>
                                        element.lensDirection ==
                                        CameraLensDirection.back,
                                  );
                                }
                                await _cameraController.dispose();
                                _cameraController = CameraController(
                                    temp, ResolutionPreset.max);
                                await _cameraController.initialize();
                                await _cameraController
                                    .prepareForVideoRecording();
                                setState(() {});
                              },
                              child: Ink(
                                child: const Icon(
                                  Icons.loop,
                                  weight: 80,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            TextButton(
                                onPressed: () async {
                                  await _preparedVideoController!.dispose();
                                  setState(() {
                                    _timerController.reset();
                                    _videoFile = null;
                                  });
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.arrowRotateLeft,
                                      color: Colors.white,
                                    ),
                                    Gap(10),
                                    AppText(
                                      text: 'Retake',
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () {
                                  navigatorKey.currentState!.pop([
                                    _videoFile,
                                    '${_timerController.remaining.value.minutes}:${_timerController.remaining.value.seconds}'
                                  ]);
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      text: 'Use video',
                                    ),
                                    Gap(10),
                                    Icon(
                                      Icons.check,
                                    ),
                                  ],
                                )),
                          ]),
                const Gap(40)
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<VideoPlayerController> _prepareController() async {
    final controller = VideoPlayerController.file(File(_videoFile!.path));
    await controller.initialize();
    await controller.setLooping(true);
    await controller.play();
    return controller;
  }
}
