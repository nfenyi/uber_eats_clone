import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_checkout_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../../models/gift_card/gift_card_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/weblinks.dart';
import '../../webview/webview_screen.dart';
import 'record_message_screen.dart';
import 'recorded_message_player_screen.dart';

class CustomizeGiftScreen extends StatefulWidget {
  final String initiallySelectedCard;
  const CustomizeGiftScreen({super.key, required this.initiallySelectedCard});

  @override
  State<CustomizeGiftScreen> createState() => _CustomizeGiftScreenState();
}

class _CustomizeGiftScreenState extends State<CustomizeGiftScreen> {
  late String _selectedCardUrl;

  final List<String> _giftAmounts = ['25', '50', '100', '200'];
  late String _selectedGiftAmount;
  final _fromTextEditingController = TextEditingController();
  final _toTextEditingController = TextEditingController();
  final _textMessageController = TextEditingController();
  final _progress = ValueNotifier<double>(0);
  Timer? _debounce;

  String? _selectedMessageOption;

  final _webViewcontroller = WebViewControllerPlus();
  late final String _userDisplayName;

  bool? _agreedToTerms = false;

  String _videoLength = '';

  XFile? _videoFile;

  UploadTask? _uploadTask;

  String? _downloadUrl;

  final _textMessageKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedCardUrl = widget.initiallySelectedCard;
    _selectedGiftAmount = _giftAmounts.first;
    _userDisplayName =
        Hive.box(AppBoxes.appState).get(BoxKeys.userInfo)['displayName'];
    _fromTextEditingController.text = _userDisplayName;
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _fromTextEditingController.dispose();
    _toTextEditingController.dispose();
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              if (_downloadUrl != null) {
                final ref = FirebaseStorage.instance.refFromURL(_downloadUrl!);
                ref.delete();
              }
            },
            child: Ink(child: const Icon(Icons.arrow_back))),
        title: const AppText(
          text: 'Customize your gift',
          size: AppSizes.body,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AppFunctions.displayNetworkImage(_selectedCardUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholderAssetImage: AssetNames.giftCardPlaceholder),
                    // Container(
                    //   color: Colors.black45,
                    //   width: double.infinity,
                    //   height: 200,
                    // ),
                    // TextButton(
                    //   onPressed: () {
                    //     // navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ,))
                    //   },
                    //   style: TextButton.styleFrom(
                    //       backgroundColor: Colors.white70,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(50))),
                    //   child: const Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(Icons.edit, size: 15),
                    //       Gap(15),
                    //       AppText(text: 'Change')
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              const Gap(30),
              const AppText(
                text: 'Gift Amount',
                color: AppColors.neutral500,
              ),
              const Gap(5),
              AppText(
                text: '\$$_selectedGiftAmount USD',
                weight: FontWeight.w600,
                size: AppSizes.heading2,
              ),
              ChipsChoice<String>.single(
                wrapped: false,
                padding: EdgeInsets.zero,
                value: _selectedGiftAmount,
                onChanged: (value) {
                  setState(() {
                    _selectedGiftAmount = value;
                  });
                },
                choiceItems: C2Choice.listFrom<String, String>(
                  source: _giftAmounts,
                  value: (i, v) => v,
                  label: (i, v) => '\$ $v',
                ),
                choiceStyle: C2ChipStyle.filled(
                  selectedStyle: const C2ChipStyle(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  height: 30,
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.neutral200,
                ),
              ),
              const Gap(10),
              const AppText(text: "Who's this gift card from?"),
              const Gap(5),
              AppTextFormField(
                controller: _fromTextEditingController,
                enabled: false,
              ),
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(text: "Who's this gift for?"),
                  AppText(
                    text: '${_toTextEditingController.text.length}/30',
                    color: _toTextEditingController.text.length < 31
                        ? Colors.black
                        : Colors.red.shade800,
                  )
                ],
              ),
              const Gap(5),
              AppTextFormField(
                hintText: 'Enter their name or nickname',
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    setState(() {});
                  });
                },
                controller: _toTextEditingController,
                suffixIcon: GestureDetector(
                    onTap: _toTextEditingController.clear,
                    child: Visibility(
                      visible: _toTextEditingController.text.isNotEmpty,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _toTextEditingController.clear();
                            });
                          },
                          child: const Icon(Icons.cancel)),
                    )),
              ),
              const Gap(5),
              Visibility(
                visible: _toTextEditingController.text.isNotEmpty,
                child: const AppText(
                  text: "Input recipient's name",
                  size: AppSizes.bodySmallest,
                ),
              ),
              const Gap(20),
              const AppText(text: 'Add a message (optional)'),

              Visibility(
                visible: _selectedMessageOption == null &&
                    (_uploadTask == null ||
                        _textMessageController.text.trim().isEmpty),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(5),
                    AppText(
                      text: 'You can add either a video or a text message',
                      size: AppSizes.bodySmallest,
                    ),
                  ],
                ),
              ),
              const Gap(10),
              ChipsChoice<String>.single(
                wrapped: false,
                padding: EdgeInsets.zero,
                value: _selectedMessageOption,
                onChanged: (value) async {
                  if (_selectedMessageOption == value) {
                    setState(() {
                      _selectedMessageOption = null;
                    });
                    return;
                  } else {
                    setState(() {
                      _selectedMessageOption = value;
                    });

                    if (value == 'Record video' && _uploadTask == null) {
                      List<CameraDescription> cameras =
                          await availableCameras();

                      // logger.d(cameras);
                      final cameraController =
                          CameraController(cameras.first, ResolutionPreset.max);
                      await cameraController.initialize().then((_) async {
                        await cameraController.lockCaptureOrientation(
                            DeviceOrientation.portraitUp);
                        //the following is needed for iOS
                        await cameraController.prepareForVideoRecording();
                        //TODO: complete camera capture
                        if (context.mounted) {
                          final listResult = await showModalBottomSheet(
                            barrierColor: Colors.transparent,
                            context: context,
                            isDismissible: false,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (context) => RecordMessageScreen(
                              availableCameras: cameras,
                              cameraController: cameraController,
                            ),
                          );
                          // logger.d(listResult);
                          if (listResult != null) {
                            _videoFile = listResult[0];
                            final storageRef = FirebaseStorage.instance.ref().child(
                                'user media/${FirebaseAuth.instance.currentUser!.uid}/recorded messages/${DateTime.now().millisecondsSinceEpoch}.mp4');
                            setState(() {
                              _uploadTask =
                                  storageRef.putFile(File(_videoFile!.path));
                              _videoLength = listResult[1];
                            });
                            _uploadTask!.snapshotEvents.listen(
                              (snapshot) {
                                // if(snapshot.state != TaskState.canceled && snapshot.state != TaskState.error) {
                                _progress.value = snapshot.bytesTransferred /
                                    snapshot.totalBytes;
                                if (snapshot.state == TaskState.success) {
                                  setState(() {});
                                }
                                // }else{

                                // }
                              },
                            );
                            final snapshot = await _uploadTask;
                            _downloadUrl = await snapshot!.ref.getDownloadURL();
                          } else {
                            setState(() {
                              if (_videoLength.isEmpty) {
                                _selectedMessageOption = null;
                              }
                            });
                          }
                        } else {
                          await cameraController.dispose();
                        }
                      });
                    }
                  }
                },
                choiceLeadingBuilder: (item, i) {
                  return Icon(i == 0
                      ? Icons.videocam_rounded
                      : Icons.speaker_notes_rounded);
                },
                choiceItems: C2Choice.listFrom<String, String>(
                  source: ['Record video', 'Write text'],
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                choiceStyle: C2ChipStyle.filled(
                  selectedStyle: const C2ChipStyle(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  height: 30,
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.neutral200,
                ),
              ),
              const Gap(15),
              Visibility(
                  visible: _selectedMessageOption == 'Write text',
                  child: Form(
                    key: _textMessageKey,
                    child: AppTextFormField(
                      validator: FormBuilderValidators.required(
                          errorText:
                              'Please provide your message or turn off \'Write text\''),
                      controller: _textMessageController,
                      hintText: 'Congratulations! You must be Uber the moon!',
                    ),
                  )),
              // const Gap(15),

              if (_uploadTask != null &&
                  _selectedMessageOption == 'Record video')
                Visibility(
                  visible: _progress.value != 1.toDouble(),
                  replacement: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.neutral300)),
                    child: ListTile(
                      leading: const Icon(Icons.videocam_rounded),
                      subtitle: const AppText(
                        text: 'Upload successful',
                        color: Colors.green,
                      ),
                      title: AppText(
                        text: _videoLength,
                        // size: AppSizes.bodySmaller,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              try {
                                if (_downloadUrl != null) {
                                  final ref = FirebaseStorage.instance
                                      .refFromURL(_downloadUrl!);

                                  await ref.delete().then(
                                        (value) => showInfoToast(
                                            'Video deleted',
                                            context:
                                                navigatorKey.currentContext),
                                      );
                                  setState(() {
                                    _uploadTask = null;
                                    _selectedMessageOption = null;
                                  });
                                }
                              } catch (e) {
                                showInfoToast(e.toString(),
                                    context: navigatorKey.currentContext);
                              }
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.neutral100,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                              ),
                            ),
                          ),
                          const Gap(5),
                          InkWell(
                            onTap: () async {
                              if (context.mounted) {
                                await navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      RecordedMessagePlayerScreen(
                                    videoFile: _videoFile!,
                                  ),
                                ));
                              }
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.neutral100,
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.neutral300)),
                    child: ListTile(
                      leading: const Icon(Icons.videocam_rounded),
                      subtitle: ValueListenableBuilder<double>(
                          valueListenable: _progress,
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                            );
                          }),
                      title: const AppText(
                        text: 'Uploading video',
                        // size: AppSizes.bodySmaller,
                      ),
                      trailing: InkWell(
                        onTap: () async {
                          await _uploadTask!.cancel();
                          _selectedMessageOption == null;
                          _uploadTask == null;
                          _videoLength = '';
                        },
                        child: Ink(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.delete,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                          text:
                              "I have read and agree to the User Generated Content Terms and Uber Privacy Notice. ",
                          style: const TextStyle(
                            fontSize: AppSizes.bodySmallest,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'See User Generated Content Terms. ',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                      controller: _webViewcontroller,
                                      link: Weblinks.userGeneratedContent,
                                    ),
                                  ));
                                },
                            ),
                            TextSpan(
                              text: 'See Uber Privacy Notice.',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                      controller: _webViewcontroller,
                                      link: Weblinks.policyNotice,
                                    ),
                                  ));
                                },
                            ),
                          ]),
                    ),
                  ),
                  const Gap(10),
                  Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value;
                        });
                      })
                ],
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            AppButton(
              callback: _toTextEditingController.text.isEmpty
                  ? null
                  : () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
                          final webViewcontroller = WebViewControllerPlus();
                          return Container(
                            height: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppBar(
                                  leading: GestureDetector(
                                      onTap: () =>
                                          navigatorKey.currentState!.pop(),
                                      child: const Icon(Icons.clear)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.neutral300,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              color: AppColors.neutral100,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: AppText(
                                                text:
                                                    "${_toTextEditingController.text} will see this:"),
                                          ),
                                        ),
                                        const Gap(20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: AppFunctions
                                                        .displayNetworkImage(
                                                      placeholderAssetImage:
                                                          AssetNames
                                                              .giftCardPlaceholder,
                                                      _selectedCardUrl,
                                                      width: double.infinity,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withAlpha(
                                                                    180))),
                                                  ),
                                                ],
                                              ),
                                              const Gap(20),
                                              AppText(
                                                text:
                                                    '\$$_selectedGiftAmount USD',
                                                weight: FontWeight.w600,
                                                size: AppSizes.heading4,
                                              ),
                                              const Gap(30),
                                              AppText(
                                                  weight: FontWeight.w600,
                                                  size: AppSizes.heading6,
                                                  text:
                                                      "${_toTextEditingController.text}, here's an Uber gift from ${_fromTextEditingController.text}!"),
                                              const Gap(10),
                                              if (_selectedMessageOption ==
                                                      'Record video' &&
                                                  _downloadUrl != null)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 20),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.neutral100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.videocam_sharp),
                                                      const Gap(10),
                                                      AppText(
                                                          text:
                                                              'You got a video from ${_fromTextEditingController.text}!')
                                                    ],
                                                  ),
                                                ),
                                              if (_selectedMessageOption ==
                                                  'Write text')
                                                AppText(
                                                  text: _textMessageController
                                                          .text
                                                          .trim()
                                                          .isEmpty
                                                      ? 'Optional message not added yet!'
                                                      : _textMessageController
                                                          .text,
                                                  color: _textMessageController
                                                          .text
                                                          .trim()
                                                          .isEmpty
                                                      ? AppColors.neutral500
                                                      : null,
                                                ),
                                              const Gap(15),
                                              GestureDetector(
                                                onTap: () {
                                                  navigatorKey.currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        WebViewScreen(
                                                      controller:
                                                          webViewcontroller,
                                                      link: Weblinks
                                                          .uberGiftCardTerms,
                                                    ),
                                                  ));
                                                },
                                                child: const AppText(
                                                  text: 'Terms apply',
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: AppColors.neutral500,
                                                ),
                                              ),
                                              const Gap(10)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
              text: 'Preview gift',
              isSecondary: true,
            ),
            const Gap(10),
            AppButton(
              callback: _toTextEditingController.text.isEmpty ||
                      _agreedToTerms == false
                  ? null
                  : () {
                      if (_selectedMessageOption == null ||
                          _selectedMessageOption == 'Record video' ||
                          (_selectedMessageOption == 'Write text' &&
                              _textMessageKey.currentState!.validate())) {
                        final giftCard = GiftCard(
                            optionalVideoUrl:
                                _selectedMessageOption == 'Record video'
                                    ? _downloadUrl
                                    : null,
                            id: const Uuid().v4(),
                            giftAmount: int.parse(_selectedGiftAmount),
                            imageUrl: _selectedCardUrl,
                            receiverName: _toTextEditingController.text.trim(),
                            senderName:
                                _fromTextEditingController.text.toString(),
                            senderUid: FirebaseAuth.instance.currentUser!.uid,
                            optionalMessage:
                                _selectedMessageOption == 'Write text'
                                    ? _textMessageController.text
                                    : null);
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) =>
                              GiftCardCheckoutScreen(giftCard),
                        ));
                      }
                    },
              text: 'Go to checkout',
            ),
            const Gap(5),
          ],
        ),
      ],
    );
  }
}
