import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/business_choose_payment_screen.dart';

import '../../../../constants/app_sizes.dart';

class WhatsYourBusinessEmail extends StatefulWidget {
  const WhatsYourBusinessEmail({super.key});

  @override
  State<WhatsYourBusinessEmail> createState() => _WhatsYourBusinessEmailState();
}

class _WhatsYourBusinessEmailState extends State<WhatsYourBusinessEmail> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                AppTextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _emailController,
                )
              ],
            ),
            AppButton(
              text: 'Next',
              callback: _emailController.text.isEmpty
                  ? null
                  : () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) =>
                            const BusinessChoosePaymentScreen(),
                      ));
                    },
            )
          ],
        ),
      ),
    );
  }
}
