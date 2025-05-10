import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/models/credit_card_details/credit_card_details_model.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/payment_options/payment_options_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/schedule_delivery_screen.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../../models/gift_card/gift_card_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/weblinks.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../sign_in/views/add_a_credit_card/add_a_credit_card_screen.dart';

class GiftCardCheckoutScreen extends ConsumerStatefulWidget {
  final GiftCard giftCard;
  const GiftCardCheckoutScreen(this.giftCard, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GiftCardCheckoutScreenState();
}

class _GiftCardCheckoutScreenState
    extends ConsumerState<GiftCardCheckoutScreen> {
  late String _selectedSendMethod;
  Timer? _debounce;
  final List<String> _giftSchedules = ['Send Now', 'Schedule'];
  late String _selectedSendSchedule;
  final List<String> _sendMethods = ['Message', 'Email'];
  CreditCardDetails? _selectedPaymentMethod;

  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedSendSchedule = _giftSchedules.first;
    _selectedSendMethod = _sendMethods.first;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? scheduleProviderValue =
        ref.watch(deliveryScheduleProviderForRecipient);
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
                          _selectedSendMethod = 'Email';
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
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month_outlined),
                      title: const AppText(
                        text: 'Schedule',
                        weight: FontWeight.w600,
                      ),
                      subtitle: AppText(
                          text:
                              '${AppFunctions.formatDate((scheduleProviderValue ?? DateTime.now()).toString(), format: 'l, M j, g:i A')}\nonly emails can be scheduled'),
                      trailing: AppButton2(
                          text: 'Change',
                          callback: () {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  const ScheduleDeliveryScreen(
                                      isFromGiftScreen: true),
                            ));
                          }),
                    ),
                  const Gap(15),
                  const AppText(
                    text: 'How would you like to send it?',
                    size: AppSizes.heading6,
                    weight: FontWeight.w600,
                  ),
                  ChipsChoice<String>.single(
                    choiceLabelBuilder: (item, i) {
                      if (i == 0) {
                        return AppText(
                          text: item.label,
                          color: _selectedSendSchedule == 'Schedule'
                              ? AppColors.neutral500
                              : null,
                        );
                      } else {
                        return AppText(
                          text: item.label,
                        );
                      }
                    },
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
                      if (i == 0) {
                        return Icon(
                          Icons.speaker_notes_rounded,
                          color: _selectedSendSchedule == 'Schedule'
                              ? AppColors.neutral500
                              : null,
                        );
                      } else {
                        return const Icon(Icons.mail);
                      }
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
                            color: const Color.fromARGB(255, 241, 244, 255),
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
                                overflow: TextOverflow.clip,
                                text:
                                    'You can choose the messaging app after payment',
                              )
                            ],
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: AppTextFormField(
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                setState(() {});
                              });
                            },
                            controller: _emailController,
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.email()]),
                            keyboardType: TextInputType.emailAddress,
                            suffixIcon: _emailController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _emailController.clear();
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.cancel),
                                  )
                                : null,
                            hintText: "Enter the recipient's email",
                          ),
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
                          ..onTap = () async {
                            await launchUrl(Uri.parse(Weblinks.giftTerms));
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
                          ..onTap = () async {
                            await launchUrl(
                                Uri.parse(Weblinks.genericGiftCardStore));
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
                          ..onTap = () async {
                            await launchUrl(
                                Uri.parse(Weblinks.corporatePortal));
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
                          ..onTap = () async {
                            await launchUrl(Uri.parse(Weblinks.giftTerms));
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
              contentPadding: EdgeInsets.zero,
              dense: true,
              onTap: () async {
                final result = await showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return const PaymentOptionsScreen(
                      showOnlyPaymentMethods: true,
                    );
                  },
                );
                if (result != null) {
                  setState(() {
                    _selectedPaymentMethod = result;
                  });
                }
              },
              leading: _selectedPaymentMethod == null
                  ? null
                  : CreditCardLogo(
                      types: detectCCType(_selectedPaymentMethod!.cardNumber)),
              // contentPadding: EdgeInsets.symmetric(
              //     horizontal: AppSizes.horizontalPaddingSmall),
              title: AppText(
                text: _selectedPaymentMethod == null
                    ? 'Select Payment'
                    : '${AppFunctions.getCreditCardName(detectCCType(_selectedPaymentMethod!.cardNumber))}••••${_selectedPaymentMethod!.cardNumber.substring(6)}',
                weight: FontWeight.w600,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            const Gap(10),
            AppButton(
              isLoading: _isLoading,
              callback: _selectedPaymentMethod != null
                  ? () async {
                      if ((_selectedSendMethod == 'Email' &&
                          !_formKey.currentState!.validate())) {
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      final dynamicLinkParams = DynamicLinkParameters(
                        link: Uri.parse(
                            "https://uber-eats-clone-d792a.firebaseapp.com/gift-card?id=${widget.giftCard.id}"),
                        uriPrefix: "https://ubereatsclone.page.link",
                        androidParameters: const AndroidParameters(
                          packageName: 'com.example.uber_eats_clone',
                        ),
                        iosParameters: const IOSParameters(
                          bundleId: 'com.example.uberEatsClone',
                        ),
                      );

                      final dynamicLink = await FirebaseDynamicLinks.instance
                          .buildLink(dynamicLinkParams);
                      if (_selectedSendMethod == 'Message') {
                        //
                        await FirebaseFirestore.instance
                            .collection(FirestoreCollections.giftCardsAnkasa)
                            .doc(widget.giftCard.id)
                            .set(widget.giftCard.toJson());
                        
                        final shareResult =
                        await Share.share(dynamicLink.toString(),
                            subject:
                                '${FirebaseAuth.instance.currentUser!.displayName} sent you a gift card!');
                        if (shareResult.status == ShareResultStatus.success) {
                        navigatorKey.currentState!.popUntil((route) =>
                            route.settings.name == '/giftCardScreen');
                        }
                      } else {
                        final giftCardWithEmailProperties = widget.giftCard
                            .copyWith(
                                deliverySchedule:
                                    _selectedSendSchedule == 'Send Now' ||
                                            scheduleProviderValue == null
                                        ? DateTime.now()
                                            .add(const Duration(minutes: 5))
                                        : scheduleProviderValue,
                                recipientAddress: _emailController.text.trim(),
                                sent: false,
                                dynamicLink: dynamicLink.toString());
                        await FirebaseFirestore.instance
                            .collection(FirestoreCollections.giftCardsAnkasa)
                            .doc(giftCardWithEmailProperties.id)
                            .set(giftCardWithEmailProperties.toJson())
                            .then(
                              (value) => navigatorKey.currentState!.popUntil(
                                  (route) =>
                                      route.settings.name == '/giftCardScreen'),
                            );
                        showInfoToast('Email will be delivered',
                            context: navigatorKey.currentContext);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  : null,
              text: 'Buy gift',
            ),
          ],
        )
      ],
    );
  }

  Future<bool> sendEmail(String recipient, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipient,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      return await launchUrl(emailUri);
    } else {
      showInfoToast('Could not launch $emailUri',
          context: navigatorKey.currentContext);
      return false;
    }
  }
}
