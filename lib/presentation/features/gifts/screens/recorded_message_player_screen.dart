import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_text.dart';

class RecordedMessagePlayerScreen extends StatefulWidget {
  final XFile? videoFile;
  final String? videoUrl;
  const RecordedMessagePlayerScreen({super.key, this.videoFile, this.videoUrl});

  @override
  State<RecordedMessagePlayerScreen> createState() =>
      _RecordedMessagePlayerScreenState();
}

class _RecordedMessagePlayerScreenState
    extends State<RecordedMessagePlayerScreen> {
  late VideoPlayerController _preparedVideoController;
  Future<void> _prepareController() async {
    if (widget.videoFile != null) {
      _preparedVideoController =
          VideoPlayerController.file(File(widget.videoFile!.path));
    } else {
      _preparedVideoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    }

    await _preparedVideoController.initialize();
    await _preparedVideoController.setLooping(true);
    await _preparedVideoController.play();
  }

  @override
  void dispose() {
    _preparedVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FutureBuilder(
          future: _prepareController(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
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
                            size: 35,
                          ));
                    }),
                    const Gap(40),
                  ],
                )
              ],
            );
          }),
    );
  }
}
