import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/weblinks.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../webview/webview_screen.dart';

class GiftCardCheckoutScreen extends ConsumerStatefulWidget {
  const GiftCardCheckoutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GiftCardCheckoutScreenState();
}

class _GiftCardCheckoutScreenState
    extends ConsumerState<GiftCardCheckoutScreen> {
  late String _selectedSendMethod;

  final List<String> _giftSchedules = ['Send Now', 'Schedule'];
  late String _selectedSendSchedule;
  final List<String> _sendMethods = ['Message', 'Email'];
  final _webViewcontroller = WebViewControllerPlus();

  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSendSchedule = _giftSchedules.first;
    _selectedSendMethod = _sendMethods.first;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Checkout',
          size: AppSizes.bodySmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  const AppText(
                    text: 'When would you like to send it?',
                    size: AppSizes.heading6,
                    weight: FontWeight.w600,
                  ),
                  ChipsChoice<String>.single(
                    padding: EdgeInsets.zero,
                    value: _selectedSendSchedule,
                    onChanged: (value) {
                      setState(() {
                        _selectedSendSchedule = value;
                        if (value == 'Schedule') {
                          _selectedSendMethod == 'Email';
                        }
                      });
                    },
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: _giftSchedules,
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
                  if (_selectedSendSchedule == 'Schedule')
                    ListTile(
                      leading: const Icon(Icons.calendar_month_outlined),
                      title: const AppText(
                        text: 'Schedule',
                        weight: FontWeight.w600,
                      ),
                      subtitle: AppText(
                          text:
                              '${AppFunctions.formatDate(DateTime.now().toString(), format: 'l, M j, g:i A')}\nonly emails can be scheduled'),
                      trailing: AppButton2(text: 'Change', callback: () {}),
                    ),
                  const Gap(15),
                  const AppText(
                    text: 'How would you like to send it?',
                    size: AppSizes.heading6,
                    weight: FontWeight.w600,
                  ),
                  ChipsChoice<String>.single(
                    wrapped: false,
                    padding: EdgeInsets.zero,
                    value: _selectedSendMethod,
                    onChanged: (value) async {
                      setState(() {
                        _selectedSendMethod = value;
                        if (value == 'Message') {
                          _selectedSendSchedule = 'Send Now';
                        }
                      });

                      if (value == 'Record video') {}
                    },
                    choiceLeadingBuilder: (item, i) {
                      return Icon(
                          i == 0 ? Icons.speaker_notes_rounded : Icons.mail);
                    },
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: _sendMethods,
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
                  _selectedSendMethod == 'Message'
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 221, 237, 244),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 20,
                                  ),
                                  Gap(5),
                                  Icon(
                                    FontAwesomeIcons.facebookMessenger,
                                    size: 20,
                                  ),
                                  Gap(5),
                                  FaIcon(
                                    FontAwesomeIcons.telegram,
                                    size: 20,
                                  ),
                                  Gap(5),
                                  Iconify(
                                    Bx.bxs_message_rounded,
                                    size: 20,
                                  ),
                                  Gap(5),
                                  FaIcon(
                                    FontAwesomeIcons.instagram,
                                    size: 20,
                                  )
                                ],
                              ),
                              Gap(15),
                              AppText(
                                text:
                                    'You can choose the messaging app after payment',
                                size: AppSizes.bodySmall,
                              )
                            ],
                          ),
                        )
                      : AppTextFormField(
                          controller: _emailController,
                          suffixIcon: GestureDetector(
                            onTap: _emailController.clear,
                            child: const Icon(Icons.cancel),
                          ),
                          hintText: "Enter the recipient's email",
                        )
                ],
              ),
            ),
            const Gap(10),
            const Divider(
              thickness: 4,
            ),
            ListTile(
              leading: const Icon(
                Icons.flag_outlined,
                color: Colors.black,
              ),
              title: RichText(
                text: TextSpan(
                    text:
                        "The recipient will only be able to use this gift in the United States. ",
                    style: const TextStyle(
                      fontSize: AppSizes.bodySmaller,
                      color: AppColors.neutral500,
                    ),
                    children: [
                      TextSpan(
                        text: 'See all terms.',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                controller: _webViewcontroller,
                                link: Weblinks.uberOneTerms,
                              ),
                            ));
                          },
                      ),
                    ]),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.mail_outline,
                color: Colors.black,
              ),
              title: RichText(
                text: TextSpan(
                    text:
                        "Want to send a gift card by mail or schedule a gift card to send later? ",
                    style: const TextStyle(
                      fontSize: AppSizes.bodySmaller,
                      color: AppColors.neutral500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Visit our generic gift card store.',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                controller: _webViewcontroller,
                                link: Weblinks.uberOneTerms,
                              ),
                            ));
                          },
                      ),
                    ]),
              ),
            ),
            ListTile(
              leading: const Iconify(Mdi.briefcase_outline),
              title: RichText(
                text: TextSpan(
                    text: "Send large quantities of gift cards through our ",
                    style: const TextStyle(
                      fontSize: AppSizes.bodySmaller,
                      color: AppColors.neutral500,
                    ),
                    children: [
                      TextSpan(
                        text: 'corporate order portal.',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                controller: _webViewcontroller,
                                link: Weblinks.uberOneTerms,
                              ),
                            ));
                          },
                      ),
                    ]),
              ),
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: RichText(
                text: TextSpan(
                    text:
                        "Gift cards are redeemable in the Uber and uber Eats apps. Terms and conditions apply to gift cards. For details, visit: ",
                    style: const TextStyle(
                      fontSize: AppSizes.bodySmaller,
                      color: AppColors.neutral500,
                    ),
                    children: [
                      TextSpan(
                        text: 'www.uber.com/legal/gift.',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                controller: _webViewcontroller,
                                link: Weblinks.uberOneTerms,
                              ),
                            ));
                          },
                      ),
                      const TextSpan(
                        text:
                            ' Gift cards are issued by TBBK Card Services, Inc. Scheduled gift card may be delivered later than expected in some cases.',
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            ListTile(
              onTap: () {
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
                                onTap: () => navigatorKey.currentState!.pop(),
                                child: const Icon(Icons.clear)),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: AppText(
                              text: 'Payment Options',
                              weight: FontWeight.w600,
                              size: AppSizes.heading4,
                            ),
                          ),
                          const Divider(),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText(text: 'Payment Method'),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Image.asset(
                                    AssetNames.masterCardLogo,
                                    width: 30,
                                    fit: BoxFit.cover,
                                    height: 20,
                                  ),
                                  title: const AppText(
                                    text: 'Mastercard••••1320 ',
                                  ),
                                ),
                                AppTextButton(
                                  text: 'Add payment method',
                                  callback: () {},
                                  color: Colors.green,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              // contentPadding: EdgeInsets.symmetric(
              //     horizontal: AppSizes.horizontalPaddingSmall),
              title: const AppText(
                text: 'Select Payment',
                weight: FontWeight.w600,
                size: AppSizes.bodySmall,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            const Gap(10),
            AppButton(
              callback: _selectedSendMethod == 'Message' ||
                      (_selectedSendMethod == 'Email' &&
                          _emailController.text.isNotEmpty)
                  ? () {
                      // ref.read(bottomNavIndexProvider.notifier).updateIndex(3);
                      // navigatorKey.currentState!. pushAndRemoveUntil(
                      navigatorKey.currentState!.popUntil(
                          (route) => route.settings.name == '/giftCardScreen');
                    }
                  : null,
              text: 'Buy gift',
            ),
          ],
        )
      ],
    );
  }
}
