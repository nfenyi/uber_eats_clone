import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_text.dart';

class AddACardCameraView extends StatefulWidget {
  const AddACardCameraView({
    super.key,
  });

  @override
  State<AddACardCameraView> createState() => _AddACardCameraViewState();
}

class _AddACardCameraViewState extends State<AddACardCameraView> {
  final _controller = ScannerWidgetController();
  late final Timer _timer;

  void _onListenCard(CardInfo? value) {
    if (value != null) {
      Navigator.of(context).pop(value);
    }
  }

  void _onError(ScannerException exception) {
    showAppInfoDialog(
      context,
      description: 'Error: ${exception.message}',
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(minutes: 7),
      () async {
        showInfoToast('Closing camera soon...', context: context);
        await Future.delayed(
          const Duration(seconds: 20),
          () {
            navigatorKey.currentState!.pop();
          },
        );
      },
    );
    _controller
      ..setCardListener(_onListenCard)
      ..setErrorListener(_onError);
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }

    _controller
      ..removeCardListeners(_onListenCard)
      ..removeErrorListener(_onError)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
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
                      child: ScannerWidget(
                        // cameraPreviewBuilder: (context, preview, previewSize) {
                        //   return SizedBox(
                        //       height: double.infinity, child: preview);
                        // },
                        overlayTextBuilder: (context) =>
                            const SizedBox.shrink(),
                        controller: _controller,
                        scannerDelay: 800,
                        overlayOrientation: CardOrientation.landscape,
                        cameraResolution: CameraResolution.max,
                        oneShotScanning: true,
                      ),

                      //  AspectRatio(
                      //     aspectRatio: 1,
                      //     child: widget.controller.buildPreview()),
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
}
