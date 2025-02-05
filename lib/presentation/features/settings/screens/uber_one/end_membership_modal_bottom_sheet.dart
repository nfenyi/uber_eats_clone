import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';

class EndMembershipModalBottomSheet extends StatefulWidget {
  const EndMembershipModalBottomSheet({super.key});

  @override
  State<EndMembershipModalBottomSheet> createState() =>
      _EndMembershipModalBottomSheetState();
}

class _EndMembershipModalBottomSheetState
    extends State<EndMembershipModalBottomSheet> {
  final _textEditingController = TextEditingController();
  final _reasons = <Reason>[
    Reason(
        reason: 'Fees are too high on my rides or orders',
        icon: const Iconify(Ph.money)),
    Reason(
        reason: 'Not saving enough',
        icon: const Iconify(Mdi.hand_coin_outline)),
    Reason(
        reason: 'Not satisfied with Uber One benefits',
        icon: const Iconify(AntDesign.gift_outlined)),
    Reason(
        reason: 'Want to take a break',
        icon: const Icon(Icons.watch_later_outlined)),
    Reason(reason: 'Something else', icon: const Icon(Icons.help_outline)),
  ];
  String? _selectedReason;

  bool _showTextField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              navigatorKey.currentState!.pop();
            },
            child: const Icon(Icons.close)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Why do you want to end your membership?',
                    weight: FontWeight.w600,
                    size: AppSizes.heading4,
                  ),
                  AppText(
                    text: "We'll use this to improve Uber One.",
                    size: AppSizes.bodySmall,
                  ),
                ],
              ),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _reasons.length,
                itemBuilder: (context, index) {
                  final reason = _reasons[index];
                  return RadioListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: reason.reason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value;
                        if (value == 'Something else') _showTextField = true;
                      });
                    },
                    groupValue: _selectedReason,
                    secondary: reason.icon,
                    title: AppText(
                      text: reason.reason,
                      size: AppSizes.bodySmall,
                    ),
                  );
                }),
            if (_showTextField)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      text: '${_textEditingController.text.length}/1200',
                      color: _textEditingController.text.length < 1200
                          ? AppColors.neutral500
                          : Colors.red.shade900,
                    ),
                    AppTextFormField(
                      minLines: 6,
                      maxLines: 40,
                      hintText: 'Tell us more(optional)',
                      controller: _textEditingController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    )
                  ],
                ),
              )
          ],
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            Column(
              children: [
                AppButton(
                  text: 'Continue',
                  callback: _selectedReason != null ? () {} : null,
                  isSecondary: true,
                ),
                const Gap(5),
                AppButton(
                  text: 'Keep Uber One',
                  callback: () {
                    navigatorKey.currentState!.pop();
                  },
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

class Reason {
  final String reason;
  final Widget icon;

  Reason({required this.reason, required this.icon});
}
