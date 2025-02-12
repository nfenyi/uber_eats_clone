import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/name_screen.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

class EmailAddressScreen extends ConsumerStatefulWidget {
  const EmailAddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailAddressScreenState();
}

class _EmailAddressScreenState extends ConsumerState<EmailAddressScreen> {
  final _emailController = TextEditingController();
  Timer? _debounce;
  final _formKey = GlobalKey<FormState>();
  final _emailLoginLink = 'https://ubereatsclone.page.link/email-link-login';

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
                        text: 'Enter your email address',
                        weight: FontWeight.w600,
                      ),
                      const Gap(10),
                      const AppText(
                        // size: AppSizes.bodySmall,
                        text: 'Add your email to aid in account recovery',
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
                          child: const Icon(
                            FontAwesomeIcons.arrowLeft,
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
                                try {
                                  await FirebaseAuth.instance
                                      .sendSignInLinkToEmail(
                                          email: _emailController.text,
                                          actionCodeSettings:
                                              ActionCodeSettings(
                                                  // URL you want to redirect back to. The domain (www.example.com) for this
                                                  // URL must be whitelisted in the Firebase Console.
                                                  url: _emailLoginLink,
                                                  // This must be true
                                                  handleCodeInApp: true,
                                                  iOSBundleId:
                                                      'com.example.ios',
                                                  androidPackageName:
                                                      'com.example.android',
                                                  // installIfNotAvailable
                                                  androidInstallApp: true,
                                                  // minimumVersion
                                                  androidMinimumVersion: '12'))
                                      .catchError((onError) => showInfoToast(
                                          'Error sending email verification $onError',
                                          context: navigatorKey.currentContext))
                                      .then((value) async {
                                    await Hive.box(AppBoxes.appState)
                                        .put('email', _emailController.text);
                                    await Hive.box(AppBoxes.appState)
                                        .put('emailLoginLink', _emailLoginLink);
                                  });
                                } on Exception catch (e) {
                                  showInfoToast(e.toString(),
                                      context: navigatorKey.currentContext,
                                      seconds: 60);
                                }
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
                              Icon(
                                FontAwesomeIcons.arrowRight,
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
