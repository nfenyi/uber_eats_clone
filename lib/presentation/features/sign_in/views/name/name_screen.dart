import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../../utils/result.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../terms_and_privacy_notice/terms_and_privacy_notice_screen.dart';
import 'name_view_model.dart';

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Timer? _debounce;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    size: AppSizes.heading6,
                    text: "What's your name?",
                    weight: FontWeight.w600,
                  ),
                  const Gap(10),
                  const AppText(
                    size: AppSizes.bodySmall,
                    text: 'Let us know how to properly address you',
                  ),
                  const Gap(30),
                  const RequiredText('First name'),
                  const Gap(10),
                  AppTextFormField(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Provide your first name')
                    ]),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        setState(() {});
                      });
                    },
                    hintText: 'Enter your first name',
                    keyboardType: TextInputType.emailAddress,
                    controller: _firstNameController,
                  ),
                  const Gap(15),
                  const RequiredText('Last name'),
                  const Gap(10),
                  AppTextFormField(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Please provide your last/surname')
                    ]),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        setState(() {});
                      });
                    },
                    hintText: 'Enter your last name',
                    keyboardType: TextInputType.emailAddress,
                    controller: _lastNameController,
                  )
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (navigatorKey.currentState!.canPop())
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
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await ref.read(nameProvider.notifier).updateName(
                              '${_firstNameController.text} ${_lastNameController.text}');
                          final nameProviderState = ref.read(nameProvider);
                          if (nameProviderState.result is RError) {
                            await showAppInfoDialog(
                                description:
                                    (nameProviderState.result as RError)
                                        .errorMessage
                                        .toString(),
                                navigatorKey.currentContext!);
                          } else {
                            await navigatorKey.currentState!
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const TermsNPrivacyNoticeScreen(),
                            ));
                          }
                        }
                      },
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.bodySmallest),
                          decoration: BoxDecoration(
                              color: _firstNameController.text.isEmpty ||
                                      _lastNameController.text.isEmpty
                                  ? AppColors.neutral200
                                  : Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: [
                              AppText(
                                text: 'Next',
                                color: _firstNameController.text.isEmpty ||
                                        _lastNameController.text.isEmpty
                                    ? null
                                    : Colors.white,
                              ),
                              const Gap(5),
                              Icon(
                                FontAwesomeIcons.arrowRight,
                                color: _firstNameController.text.isEmpty ||
                                        _lastNameController.text.isEmpty
                                    ? null
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
