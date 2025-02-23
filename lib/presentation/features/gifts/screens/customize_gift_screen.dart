import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_checkout_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/weblinks.dart';
import '../../webview/webview_screen.dart';

class CustomizeGiftScreen extends StatefulWidget {
  final String initiallySelectedCard;
  const CustomizeGiftScreen({super.key, required this.initiallySelectedCard});

  @override
  State<CustomizeGiftScreen> createState() => _CustomizeGiftScreenState();
}

class _CustomizeGiftScreenState extends State<CustomizeGiftScreen> {
  late String _selectedCard;

  final List<String> _giftAmounts = ['25', '50', '100', '200'];
  late String _selectedGiftAmount;
  final _fromTextEditingController = TextEditingController();
  final _toTextEditingController = TextEditingController();
  final _textMessageController = TextEditingController();

  String? _selectedMessageOption;

  final _webViewcontroller = WebViewControllerPlus();

  bool? _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _selectedCard = widget.initiallySelectedCard;
    _selectedGiftAmount = _giftAmounts.first;
    _fromTextEditingController.text = 'Nana';
  }

  @override
  void dispose() {
    _fromTextEditingController.dispose();
    _toTextEditingController.dispose();
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Customize your gift',
          weight: FontWeight.w600,
          size: AppSizes.heading6,
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
                    Image.asset(
                      _selectedCard,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black45,
                      width: double.infinity,
                      height: 200,
                    ),
                    AppButton(
                      callback: () {},
                      borderRadius: 50,
                      text: 'Change',
                      buttonColor: Colors.white70,
                      textColor: Colors.black,
                      iconFirst: true,
                      width: 100,
                      height: 35,
                      icon: const Icon(
                        Icons.edit,
                        size: 15,
                      ),
                    )
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
                  // TODO: apply debounce
                  setState(() {});
                },
                controller: _toTextEditingController,
                suffixIcon: GestureDetector(
                    onTap: _toTextEditingController.clear,
                    child: const Icon(Icons.cancel)),
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
              ChipsChoice<String>.single(
                wrapped: false,
                padding: EdgeInsets.zero,
                value: _selectedMessageOption,
                onChanged: (value) async {
                  setState(() {
                    _selectedMessageOption = value;
                  });
                  logger.d(value);
                  if (value == 'Record video') {
                    // await ImagePicker().pickVideo(
                    //   source: ImageSource.camera,
                    // );
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
                  child: AppTextFormField(
                    controller: _textMessageController,
                    hintText: 'Congratulations! You must be Uber the moon!',
                  )),
              const Gap(15),
              Visibility(
                visible: _selectedMessageOption == null,
                child: const AppText(
                  text: 'You can add either a video or a text message',
                  size: AppSizes.bodySmallest,
                ),
              ),
              Visibility(
                visible: false,
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
                    title: const AppText(
                      text: '0:09 seconds',
                      // size: AppSizes.bodySmaller,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
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
                        const Gap(5),
                        InkWell(
                          child: Ink(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColors.neutral100,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 15,
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
                    subtitle: const LinearProgressIndicator(
                      value: 0.1,
                    ),
                    title: const AppText(
                      text: 'Uploading video',
                      // size: AppSizes.bodySmaller,
                    ),
                    trailing: InkWell(
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
                                      link: Weblinks.uberOneTerms,
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
                  : () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.neutral300,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.neutral100,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Center(
                                                child: AppText(
                                                    text:
                                                        "${_toTextEditingController.text} will see this:"),
                                              ),
                                            ),
                                            const Gap(20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.asset(
                                                          _selectedCard,
                                                          width:
                                                              double.infinity,
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
                                                                    .circular(
                                                                        15),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
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
                                                    size: AppSizes.heading2,
                                                  ),
                                                  const Gap(30),
                                                  AppText(
                                                      weight: FontWeight.w600,
                                                      size: AppSizes.heading6,
                                                      text:
                                                          "${_toTextEditingController.text}, here's an Uber gift from Nana!"),
                                                  const Gap(10),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 20),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.neutral100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: const Row(
                                                      children: [
                                                        Icon(Icons
                                                            .videocam_sharp),
                                                        Gap(10),
                                                        AppText(
                                                            text:
                                                                'You got a video from Joshua!')
                                                      ],
                                                    ),
                                                  ),
                                                  const Gap(15),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: const AppText(
                                                      text: 'Terms apply',
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color:
                                                          AppColors.neutral500,
                                                    ),
                                                  ),
                                                  const Gap(10)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
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
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const GiftCardCheckoutScreen(),
                      ));
                    },
              text: 'Go to checkout',
            ),
          ],
        ),
      ],
    );
  }
}
