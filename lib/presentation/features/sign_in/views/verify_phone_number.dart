import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/email_address_screen.dart';

import '../../../../main.dart';
import '../../../core/app_colors.dart';

class VerifyPhoneNumber extends ConsumerStatefulWidget {
  const VerifyPhoneNumber({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends ConsumerState<VerifyPhoneNumber> {
  final TextEditingController _pinController = TextEditingController();
  final _defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.neutral300,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
  final _followingPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: Colors.black12.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  late final _focusedPinTheme = _defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary));

  bool _hasTimedOut = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

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
                const AppText(
                  size: AppSizes.heading5,
                  text: 'Enter the 4-digit code sent to you at (929) 924-7938.',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                const AppText(
                  size: AppSizes.body,
                  text: 'Changes your mobile number?',
                  decoration: TextDecoration.underline,
                ),
                const Gap(30),
                Pinput(
                  length: 4,
                  followingPinTheme: _followingPinTheme,
                  defaultPinTheme: _defaultPinTheme,
                  focusedPinTheme: _focusedPinTheme,
                  submittedPinTheme: _followingPinTheme,
                  controller: _pinController,
                  onCompleted: (value) {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const EmailAddressScreen(),
                    ));
                  },
                ),
                const Gap(50),
                InkWell(
                  onTap: _hasTimedOut ? () {} : null,
                  child: Ink(
                    child: Container(
                      padding: const EdgeInsets.all(
                          AppSizes.horizontalPaddingSmallest),
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            text: 'Resend code via SMS  ',
                            size: 15,
                            color: _hasTimedOut
                                ? Colors.black
                                : AppColors.neutral500,
                          ),
                          if (!_hasTimedOut) const Text('('),
                          if (!_hasTimedOut)
                            TimerCountdown(
                              spacerWidth: 0,
                              enableDescriptions: false,
                              timeTextStyle:
                                  const TextStyle(color: AppColors.neutral500),
                              format: CountDownTimerFormat.minutesSeconds,
                              endTime: DateTime.now().add(
                                const Duration(
                                  minutes: 2,
                                ),
                              ),
                              onEnd: () {
                                setState(() {
                                  _hasTimedOut = true;
                                });
                              },
                            ),
                          if (!_hasTimedOut) const Text(')'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => navigatorKey.currentState!.pop(),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: const BoxDecoration(
                              color: AppColors.neutral200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const Icon(
                            FontAwesomeIcons.arrowLeft,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(10)
              ],
            )
          ],
        ),
      ),
    );
  }
}
