import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../constants/weblinks.dart';
import 'thank_you_modal.dart';

class INeedHelpUpdatingAccountScreen extends StatefulWidget {
  const INeedHelpUpdatingAccountScreen({super.key});

  @override
  State<INeedHelpUpdatingAccountScreen> createState() =>
      _INeedHelpUpdatingAccountScreenState();
}

class _INeedHelpUpdatingAccountScreenState
    extends State<INeedHelpUpdatingAccountScreen> {
  final _deleteReasons = [
    'Bad experience on a ride',
    'Bad experience with an order',
    "It's too expensive",
    "No longer need account",
    'No longer support company',
    "Prefer not to say",
  ];
  final List<String> _selectedReasons = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPaddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'I need help deleting my account',
            size: AppSizes.heading6,
          ),
          const Gap(20),
          const AppText(
              text:
                  'Before contacting our Support team, try deleting your account through the link below.'),
          const Gap(20),
          const AppText(
            text:
                'If you have a rider account with the same details, this will delete both accounts.',
            weight: FontWeight.bold,
          ),
          const Gap(20),
          InkWell(
            onTap: () {},
            child: Ink(
              child: const AppText(
                text: 'Delete my account',
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const Gap(20),
          const AppText(
            text: 'Verify your account',
            weight: FontWeight.bold,
            size: AppSizes.heading4,
          ),
          const Gap(20),
          const AppText(
              text:
                  "Before you can delete your account, you'll need to verify your identity using a temporary verification code. This may require you to have a phone number attached to your account."),
          const Gap(10),
          RichText(
            text: TextSpan(
                text:
                    "If you can't add a phone number in your account settings, ",
                style: const TextStyle(
                  fontSize: AppSizes.bodySmaller,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'contact us.',
                    style: const TextStyle(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await launchUrl(Uri.parse(Weblinks.uberEatsHelp));
                      },
                  ),
                ]),
          ),
          const Gap(20),
          const AppText(
            text: 'Clear any outstanding payments',
            weight: FontWeight.bold,
            size: AppSizes.heading4,
          ),
          const Gap(20),
          const AppText(
              text:
                  "Before you can delete your account, you'll need to verify your identity using a temporary verification code. This may require you to have a phone number attached to your account."),
          const Gap(20),
          const AppText(
            text: 'Still need help deleting your account?',
            weight: FontWeight.bold,
            size: AppSizes.heading4,
          ),
          const Gap(20),
          const AppText(text: "Let us know below."),
          const Gap(10),
          RichText(
            text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "A few things to note:",
                    style: TextStyle(
                      fontSize: AppSizes.bodySmaller,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        "* Your account will be immediately deactivated, and after 30 days it is permanently deleted. Any unused credits, promotions, or rewards are removed as well.* Uber may retain certain information after account deletion as required or permitted by law.* If you change your mind and want to keep your account, sign in within 30 days to restore it.",
                    style: TextStyle(),
                  ),
                ]),
          ),
          const Gap(20),
          const AppText(
            text: 'Why do you wish to delete your account?',
            weight: FontWeight.bold,
            size: AppSizes.heading4,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _deleteReasons.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final reason = _deleteReasons[index];
              return SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: AppText(
                  text: reason,
                  size: AppSizes.bodySmall,
                ),
                value: _selectedReasons.contains(reason),
                onChanged: (value) {
                  setState(() {
                    if (_selectedReasons.contains(reason)) {
                      _selectedReasons.removeWhere(
                        (element) => element == reason,
                      );
                    } else {
                      _selectedReasons.add(reason);
                    }
                  });
                },
              );
            },
          ),
          const Gap(20),
          AppButton(
            text: 'SUBMIT',
            callback: (_selectedReasons.isNotEmpty)
                ? () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
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
                            child: const ThankYouModal());
                      },
                    );
                  }
                : null,
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
