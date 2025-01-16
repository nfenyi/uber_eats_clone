import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/confirm_location.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';
import '../../sign_in/views/payment_method_screen.dart';

class AddressDetailsScreen extends ConsumerStatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends ConsumerState<AddressDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Address Details',
          size: AppSizes.body,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                InkWell(
                  onTap: () =>
                      navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => const ConfirmLocationScreen(),
                  )),
                  child: Ink(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: AppColors.neutral300,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: const AppText(text: 'Edit pin'))
                      ],
                    ),
                  ),
                ),
                const Gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        size: AppSizes.heading5,
                        text: '1226 University Dr, Menlo Park, CA 94025, USA',
                        weight: FontWeight.w600,
                      ),
                      const Gap(15),
                      const AppTextFormField(
                        hintText: 'Apt/Suite/Floor',
                      ),
                      const Gap(15),
                      const AppTextFormField(
                        hintText: 'Business or building name',
                      ),
                      const Gap(20),
                      const Divider(),
                      const Gap(15),
                      const AppText(
                        text: 'Dropoff options',
                        size: AppSizes.body,
                        weight: FontWeight.w600,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                            decoration: BoxDecoration(
                                // border: Border.all(),
                                borderRadius: BorderRadius.circular(50)),
                            child: Image.asset(
                              AssetNames.carrierBag,
                              height: 40,
                            )),
                        title: const AppText(
                          text: 'Meet at my door',
                        ),
                        subtitle: const Row(
                          children: [
                            AppTextBadge(
                              text: 'More options available',
                            ),
                          ],
                        ),
                        trailing: AppButton2(
                            text: 'Edit',
                            callback: () {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) =>
                                    const DropOffOptionsScreen(),
                              ));
                            }),
                      ),
                      const Gap(20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Instructions for delivery person',
                            size: AppSizes.body,
                          ),
                          AppTextBadge(text: 'Needs review')
                        ],
                      ),
                      const Gap(20),
                      const AppTextFormField(
                        minLines: 4,
                        readOnly: true,
                        maxLines: 15,
                        // textAlign: TextAlign.start,
                        // height: 50,
                        hintText:
                            'Example: Please knock instead of using the doorbell',
                      ),
                      const Gap(15),
                      const Divider(),
                      const Gap(15),
                      const AppText(
                        text: 'Address Label',
                      ),
                      const Gap(10),
                      const AppTextFormField(),
                      const Gap(15),
                      const Divider(),
                      const Gap(10)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
            child: AppButton(
              text: 'Save and continue',
              callback: () {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const PaymentMethodScreen(),
                ));
              },
            ),
          )
        ],
      ),
    );
  }
}
