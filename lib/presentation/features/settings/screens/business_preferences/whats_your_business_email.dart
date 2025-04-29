import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/business_profile/business_profile_model.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/business_choose_payment_screen.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../constants/app_sizes.dart';

class WhatsYourBusinessEmail extends StatefulWidget {
  const WhatsYourBusinessEmail({super.key});

  @override
  State<WhatsYourBusinessEmail> createState() => _WhatsYourBusinessEmailState();
}

class _WhatsYourBusinessEmailState extends State<WhatsYourBusinessEmail> {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: "What's your business email?",
                  size: AppSizes.heading4,
                  weight: FontWeight.bold,
                ),
                const Gap(30),
                const AppText(text: 'Business email'),
                const Gap(10),
                Form(
                  key: _formKey,
                  child: AppTextFormField(
                    validator: FormBuilderValidators.email(),
                    controller: _emailController,
                  ),
                )
              ],
            ),
            Consumer(builder: (context, ref, child) {
              return AppButton(
                text: 'Next',
                callback: () async {
                  if (_formKey.currentState!.validate()) {
                    ref.read(businessFormProiver.notifier).state =
                        BusinessProfile(
                            id: const Uuid().v4(),
                            email: _emailController.text);
                    await navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const BusinessChoosePaymentScreen(),
                    ));
                  }
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
