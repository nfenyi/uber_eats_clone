import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../core/app_text.dart';
import '../../../sign_in/views/email_sent_screen.dart';

class EmailEditScreen extends ConsumerStatefulWidget {
  const EmailEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailEditScreenState();
}

class _EmailEditScreenState extends ConsumerState<EmailEditScreen> {
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
                        text: 'Enter your new email',
                        weight: FontWeight.w600,
                      ),
                      const Gap(30),
                      AppTextFormField(
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) {
                            _debounce?.cancel();
                          }
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
                AppButton(
                  text: 'Next',
                  callback: _emailController.text.isEmpty
                      ? null
                      : () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              await FirebaseAuth.instance.currentUser!
                                  .verifyBeforeUpdateEmail(
                                      _emailController.text,
                                      ActionCodeSettings(
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
                          } on Exception catch (e) {
                            await showAppInfoDialog(
                                description: e.toString(),
                                navigatorKey.currentContext!);
                          }
                        },
                ),
                const Gap(20),
              ],
            )
          ],
        ),
      ),
    );
  }
}
