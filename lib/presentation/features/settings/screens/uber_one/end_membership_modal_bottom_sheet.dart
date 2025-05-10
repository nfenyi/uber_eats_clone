import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ant_design.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/uber_one_status/uber_one_status_model.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../../app_functions.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../../services/sign_in_view_model.dart';

class EndMembershipModalBottomSheet extends StatefulWidget {
  final UberOneStatus uberOneStatus;
  const EndMembershipModalBottomSheet(this.uberOneStatus, {super.key});

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

  bool _isLoading = false;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
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
                        size: AppSizes.heading5,
                      ),
                      AppText(
                        text: "We'll use this to improve Uber One.",
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
                            if (value == 'Something else') {
                              _showTextField = true;
                            } else {
                              if (_showTextField == true) {
                                _showTextField = false;
                              }
                            }
                          });
                        },
                        groupValue: _selectedReason,
                        secondary: reason.icon,
                        title: AppText(
                          text: reason.reason,
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
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                Column(
                  children: [
                    AppButton(
                      isLoading: _isLoading,
                      text: 'Continue',
                      callback: _selectedReason == null
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                final oldUberOneStatus = widget.uberOneStatus;
                                final newUberOneStatus =
                                    oldUberOneStatus.copyWith(
                                  expirationDate: null,
                                  hasUberOne: false,
                                  plan: null,
                                );
                                await FirebaseFirestore.instance
                                    .collection(FirestoreCollections.users)
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  'uberOneStatus': newUberOneStatus.toJson(),
                                });
                                showInfoToast('Subscription ended',
                                    context: navigatorKey.currentContext);

                                await AppFunctions.getOnlineUserInfo();
                                navigatorKey.currentState!.pop();
                                navigatorKey.currentState!.pop();
                              } on Exception catch (e) {
                                await showAppInfoDialog(
                                    description: e.toString(),
                                    navigatorKey.currentContext!);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      isSecondary: true,
                    ),
                    const Gap(10),
                    AppButton(
                      text: 'Keep Uber One',
                      callback: () {
                        navigatorKey.currentState!.pop();
                      },
                    ),
                    const Gap(10),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Reason {
  final String reason;
  final Widget icon;

  Reason({required this.reason, required this.icon});
}
