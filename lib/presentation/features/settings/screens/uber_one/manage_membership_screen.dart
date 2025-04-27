import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/uber_one_status/uber_one_status_model.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/end_membership_modal_bottom_sheet.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';

import '../../../../../app_functions.dart';
import '../../../../../models/payment_method_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../constants/other_constants.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../payment_options/payment_options_screen.dart';
import 'switch_to_annual_plan_screen.dart';

class ManageMembershipScreen extends StatefulWidget {
  const ManageMembershipScreen({super.key});

  @override
  State<ManageMembershipScreen> createState() => _ManageMembershipScreenState();
}

class _ManageMembershipScreenState extends State<ManageMembershipScreen> {
  // final _membershipDetails = MembershipDetails(
  //     paymentMethod: const PaymentMethod(
  //       name: 'Mastercard',
  //       assetImage: AssetNames.masterCardLogo,
  //     ),
  //     plan: Plan(period: 'Monthly', bill: 9.99),
  //     dateRenewed: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Manage membership',
          size: AppSizes.heading6,
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box(AppBoxes.appState).listenable(keys: [BoxKeys.userInfo]),
          builder: (context, appStateBox, child) {
            final uberOneStatus = UberOneStatus.fromJson(
                appStateBox.get(BoxKeys.userInfo)['uberOneStatus']);

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: AppText(
                      weight: FontWeight.bold,
                      text: 'Your membership',
                      size: AppSizes.heading6,
                    ),
                  ),
                  ListTile(
                      dense: true,
                      leading: Image.asset(
                        AssetNames.uberOneSmall,
                        color: Colors.black,
                        width: 30,
                      ),
                      title: const AppText(
                        text: 'Uber One',
                        size: AppSizes.bodySmall,
                      ),
                      subtitle: AppText(
                          color: AppColors.neutral500,
                          size: AppSizes.bodySmallest,
                          text:
                              'Renews on ${AppFunctions.formatDate(uberOneStatus.expirationDate.toString(), format: 'M j, Y')} for \$${OtherConstants.billings.firstWhere(
                                    (element) =>
                                        element.period == uberOneStatus.plan,
                                  ).bill.toStringAsFixed(2)}')),
                  const Divider(
                    indent: 60,
                  ),
                  ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.calendar_month_outlined,
                        size: 25,
                      ),
                      title: const AppText(
                        text: 'Current plan',
                        size: AppSizes.bodySmall,
                      ),
                      trailing: uberOneStatus.plan == 'Monthly'
                          ? AppButton2(
                              text: 'Change',
                              callback: () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      SwitchToAnnualPlanScreen(
                                    uberOneStatus: uberOneStatus,
                                  ),
                                ));
                                //                       SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                                //   statusBarIconBrightness: Brightness.light,
                                //   statusBarColor: Colors.transparent,
                                // ));
                              })
                          : null,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                              size: AppSizes.bodySmallest,
                              color: AppColors.neutral500,
                              text: uberOneStatus.plan!),
                          if (uberOneStatus.plan == 'Monthly')
                            const AppText(
                              size: AppSizes.bodySmallest,
                              text: 'Save 20% with an annual plan',
                              color: Colors.green,
                            )
                        ],
                      )),
                  const Divider(
                    indent: 60,
                  ),
                  const ListTile(
                    leading: Icon(Icons.help_outline),
                    title: AppText(
                      text: 'Learn more',
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.neutral500,
                    ),
                  ),
                  const Divider(
                    thickness: 4,
                  ),
                  const Gap(5),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: AppText(
                      weight: FontWeight.bold,
                      text: 'Payment details',
                      size: AppSizes.heading6,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.credit_card),
                    title: const AppText(
                      text: 'Payment method',
                    ),
                    trailing: AppButton2(
                        text: 'Change',
                        callback: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return const PaymentOptionsScreen(
                                showOnlyPaymentMethods: true,
                              );
                            },
                          );
                        }),
                    subtitle: Consumer(builder: (context, ref, child) {
                      final selectedPaymentMethod =
                          ref.read(paymentOptionProvider);

                      return AppText(
                        text: selectedPaymentMethod == null
                            ? 'None selected'
                            : '${selectedPaymentMethod.creditCardType ?? 'N/A'} •••${selectedPaymentMethod.cardNumber.substring(8)}',
                        color: AppColors.neutral500,
                      );
                    }),
                  ),
                  const Divider(
                    indent: 60,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.refresh),
                    title: const AppText(text: 'Backup payment methods'),
                  ),
                  const Divider(
                    thickness: 4,
                  ),
                  const Gap(5),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: AppText(
                      weight: FontWeight.bold,
                      text: 'Manage membership',
                      size: AppSizes.heading6,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                                color: Colors.white,
                                child: EndMembershipModalBottomSheet(
                                    uberOneStatus));
                          });
                    },
                    dense: true,
                    leading: const Icon(Icons.cancel),
                    title: const AppText(
                      text: 'End membership',
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.neutral500,
                    ),
                  ),
                ]);
          }),
    );
  }
}

class MembershipDetails {
  final DateTime dateRenewed;
  final Plan plan;
  final PaymentMethod paymentMethod;

  MembershipDetails(
      {required this.dateRenewed,
      required this.plan,
      required this.paymentMethod});
}
