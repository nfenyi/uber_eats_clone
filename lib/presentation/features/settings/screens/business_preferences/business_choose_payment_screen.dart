import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/business_preferences/link_an_expense_program_screen.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';

import '../../../../../app_functions.dart';
import '../../../../../models/credit_card_details/credit_card_details_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../sign_in/views/add_a_credit_card/add_a_credit_card_screen.dart';
import '../../../sign_in/views/payment_method_screen.dart';

class BusinessChoosePaymentScreen extends ConsumerStatefulWidget {
  const BusinessChoosePaymentScreen({super.key});

  @override
  ConsumerState<BusinessChoosePaymentScreen> createState() =>
      _BusinessChoosePaymentScreenState();
}

class _BusinessChoosePaymentScreenState
    extends ConsumerState<BusinessChoosePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Choose payment',
              weight: FontWeight.bold,
              size: AppSizes.heading4,
            ),
            const Gap(30),
            const AppText(
                text: 'You can always switch to a different payment method'),
            const Gap(30),
            FutureBuilder<List<CreditCardDetails>>(
                future: AppFunctions.getCreditCards(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final creditCard = snapshot.data![index];

                        final types = detectCCType(creditCard.cardNumber);
                        final cardNumberToShow =
                            '${AppFunctions.getCreditCardName(types)}••••${creditCard.cardNumber.substring(6)}';
                        return ListTile(
                          onTap: () async {
                            ref.read(businessFormProiver.notifier).state = ref
                                .read(businessFormProiver.notifier)
                                .state!
                                .copyWith(creditCardNumber: cardNumberToShow);

                            await navigatorKey.currentState!
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const LinkAnExpenseProgramScreen(),
                            ));
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: CreditCardLogo(types: types),
                          title: AppText(
                            text: cardNumberToShow,
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return AppText(text: snapshot.error.toString());
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
            const Gap(20),
            GestureDetector(
                onTap: () async => await navigatorKey.currentState!
                    .push(MaterialPageRoute(
                      builder: (context) => const PaymentMethodScreen(),
                    ))
                    .then(
                      (value) => setState(() {}),
                    ),
                child: const AppText(
                  text: 'Add payment method',
                  color: Colors.green,
                )),
            const Gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              decoration: const BoxDecoration(color: AppColors.neutral100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Gap(8),
                      Image.asset(
                        AssetNames.creditCard,
                        width: 40,
                      ),
                    ],
                  ),
                  const Gap(15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            weight: FontWeight.bold,
                            size: AppSizes.bodySmall,
                            text:
                                'Use your Amex Corporate Green, Gold or Platinum Card, earn Uber Cash'),
                        Gap(5),
                        AppText(
                            color: AppColors.neutral500,
                            size: AppSizes.bodySmall,
                            text:
                                'Earn Uber Cash for personal use when you ride with Uber or order with Uber Eats for business.')
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
