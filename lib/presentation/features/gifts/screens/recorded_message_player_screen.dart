import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_text.dart';

class RecordedMessagePlayerScreen extends StatefulWidget {
  final XFile videoFile;
  const RecordedMessagePlayerScreen({super.key, required this.videoFile});

  @override
  State<RecordedMessagePlayerScreen> createState() =>
      _RecordedMessagePlayerScreenState();
}

class _RecordedMessagePlayerScreenState
    extends State<RecordedMessagePlayerScreen> {
  late VideoPlayerController _preparedVideoController;
  Future<VideoPlayerController> prepareController() async {
    final controller = VideoPlayerController.file(File(widget.videoFile.path));
    await controller.initialize();
    await controller.setLooping(true);
    await controller.play();
    return controller;
  }

  @override
  void dispose() {
    _preparedVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const AppText(
          text: 'Your message',
          size: AppSizes.body,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            navigatorKey.currentState!.pop();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<VideoPlayerController>(
          future: prepareController(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _preparedVideoController = snapshot.data!;
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  VideoPlayer(_preparedVideoController),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StatefulBuilder(builder: (context, setState) {
                        return TextButton(
                            style: TextButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.white),
                            onPressed: () async {
                              if (_preparedVideoController.value.isPlaying) {
                                await _preparedVideoController.pause();
                              } else {
                                await _preparedVideoController.play();
                              }
                              setState(() {});
                            },
                            child: Icon(
                              _preparedVideoController.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 40,
                            ));
                      }),
                      const Gap(20),
                    ],
                  )
                ],
              );
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
    );
  }
}
