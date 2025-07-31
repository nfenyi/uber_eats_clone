import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import 'email_sent_screen.dart';

class WhatsYourEmailScreen extends ConsumerStatefulWidget {
  const WhatsYourEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WhatsYourEmailScreenState();
}

class _WhatsYourEmailScreenState extends ConsumerState<WhatsYourEmailScreen> {
  final _emailController = TextEditingController();
  Timer? _debounce;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _debounce?.cancel();
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
          children: [
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        size: AppSizes.heading6,
                        text: 'What\'s your email address',
                        weight: FontWeight.w600,
                      ),
                      const Gap(30),
                      const RequiredText('Email'),
                      const Gap(10),
                      AppTextFormField(
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(seconds: 1), () {
                            setState(() {});
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.email(
                              errorText: 'Provide a valid email')
                        ]),
                        hintText: 'name@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      )
                    ],
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
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      onTap: () => navigatorKey.currentState!.pop(),
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: const BoxDecoration(
                            color: AppColors.neutral200,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Iconify(
                            Ph.arrow_left,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _emailController.text.isEmpty
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await FirebaseAuth.instance
                                    .sendSignInLinkToEmail(
                                        email: _emailController.text,
                                        actionCodeSettings: ActionCodeSettings(
                                            // URL you want to redirect back to. The domain (www.example.com) for this
                                            // URL must be whitelisted in the Firebase Console.
                                            url:
                                                'https://ubereatsclone.page.link/email-link-login',
                                            // This must be true
                                            handleCodeInApp: true,
                                            iOSBundleId:
                                                'com.example.uberEatsClone',
                                            androidPackageName:
                                                'com.example.uber_eats_clone',
                                            // installIfNotAvailable
                                            androidInstallApp: true,
                                            // minimumVersion
                                            androidMinimumVersion: '12'))
                                    .then((value) async {
                                  await Hive.box(AppBoxes.appState).put(
                                      'email', _emailController.text.trim());

                                  await navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => EmailSentScreen(
                                      email: _emailController.text,
                                    ),
                                  ));
                                },
                                        onError: (onError) => showAppInfoDialog(
                                            description:
                                                'Error sending email verification $onError',
                                            navigatorKey.currentContext!));
                              }
                            },
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: BoxDecoration(
                              color: _emailController.text.isEmpty
                                  ? AppColors.neutral200
                                  : Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: [
                              AppText(
                                text: 'Next',
                                color: _emailController.text.isEmpty
                                    ? AppColors.neutral500
                                    : Colors.white,
                              ),
                              const Gap(5),
                              Iconify(
                                Ph.arrow_right,
                                color: _emailController.text.isEmpty
                                    ? AppColors.neutral500
                                    : Colors.white,
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
          ],
        ),
      ),
    );
  }
}
