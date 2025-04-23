import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/weblinks.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/webview/webview_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../main.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';

class TermsNPrivacyNoticeScreen extends ConsumerStatefulWidget {
  const TermsNPrivacyNoticeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsNPrivacyNoticeScreenState();
}

class _TermsNPrivacyNoticeScreenState
    extends ConsumerState<TermsNPrivacyNoticeScreen> {
  final _webViewcontroller = WebViewControllerPlus();

  bool? _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AssetNames.clipBoardCross,
                          width: 60,
                        ),
                        const Gap(20),
                        const Expanded(
                          child: AppText(
                            size: AppSizes.heading6,
                            text: "Accept Uber's Terms & Review Privacy Notice",
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(40),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: AppSizes.bodySmaller,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Use',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    controller: _webViewcontroller,
                                    link: Weblinks.termsOfUse,
                                  ),
                                ));
                              },
                          ),
                          const TextSpan(
                              text: ' and acknowledge the ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: 'Privacy Notice',
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
                              style: const TextStyle(color: Colors.blue)),
                          const TextSpan(
                              text: '. I am at least 18 years of age.',
                              style: TextStyle(color: Colors.black))
                        ],
                        text:
                            'By selecting "I Agree" below, I have reviewed and agree to the ',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CheckboxListTile.adaptive(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      title: const AppText(
                        text: 'I Agree',
                        size: AppSizes.bodySmaller,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          onTap: () => navigatorKey.currentState!.pop(),
                          child: Ink(
                            child: Container(
                              padding:
                                  const EdgeInsets.all(AppSizes.bodySmallest),
                              decoration: const BoxDecoration(
                                color: AppColors.neutral200,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          onTap: _isChecked == true
                              ? () => navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => const AddressesScreen(
                                      newLabel: 'Home',
                                    ),
                                  ))
                              : () => showInfoToast(
                                    'Please agree to the terms to proceed',
                                    context: context,
                                  ),
                          child: Ink(
                            child: Container(
                              padding:
                                  const EdgeInsets.all(AppSizes.bodySmallest),
                              decoration: BoxDecoration(
                                  color: _isChecked == true
                                      ? Colors.black
                                      : AppColors.neutral200,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                children: [
                                  AppText(
                                    text: 'Next',
                                    color: _isChecked == true
                                        ? Colors.white
                                        : null,
                                  ),
                                  const Gap(5),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    color: _isChecked == true
                                        ? Colors.white
                                        : null,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10)
                  ],
                )
              ]),
        ));
  }
}
