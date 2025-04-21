import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/end_membership_modal_bottom_sheet.dart';

import '../../../../../app_functions.dart';
import '../../../../../models/payment_method_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import 'switch_to_annual_plan_screen.dart';
import 'uber_one_account_screen.dart';

class ManageMembershipScreen extends StatefulWidget {
  const ManageMembershipScreen({super.key});

  @override
  State<ManageMembershipScreen> createState() => _ManageMembershipScreenState();
}

class _ManageMembershipScreenState extends State<ManageMembershipScreen> {
  final _membershipDetails = MembershipDetails(
      paymentMethod: const PaymentMethod(
        name: 'Mastercard',
        assetImage: AssetNames.masterCardLogo,
      ),
      plan: Plan(period: 'Monthly', bill: 9.99),
      dateRenewed: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Manage membership',
          size: AppSizes.heading6,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSizes.horizontalPaddingSmall),
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
                text:
                    'Renews on ${AppFunctions.formatDate(_membershipDetails.dateRenewed.add(const Duration(days: 30)).toString(), format: 'M j, Y')} for \$${_membershipDetails.plan.bill}')),
        const Divider(
          indent: 60,
        ),
        ListTile(
            dense: true,
            leading: Image.asset(
              AssetNames.uberOneSmall,
              color: Colors.black,
              width: 30,
            ),
            title: const AppText(
              text: 'Current plan',
              size: AppSizes.bodySmall,
            ),
            trailing: _membershipDetails.plan.period == 'Monthly'
                ? AppButton2(
                    text: 'Change',
                    callback: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => SwitchToAnnualPlanScreen(
                          membershipDetails: _membershipDetails,
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
                    color: AppColors.neutral500,
                    text: _membershipDetails.plan.period),
                if (_membershipDetails.plan.period == 'Monthly')
                  const AppText(
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
            size: AppSizes.bodySmall,
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
          padding:
              EdgeInsets.symmetric(horizontal: AppSizes.horizontalPaddingSmall),
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
            size: AppSizes.bodySmall,
          ),
          trailing: AppButton2(text: 'Change', callback: () {}),
          // subtitle: AppText(
          //   text:
          //       '${_membershipDetails.paymentMethod.name} ••••${_membershipDetails.paymentMethod.cardNumber!.substring(5)}',
          //   color: AppColors.neutral500,
          // ),
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
          padding:
              EdgeInsets.symmetric(horizontal: AppSizes.horizontalPaddingSmall),
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
                context: context,
                builder: (context) {
                  return Container(
                      color: Colors.white,
                      child: const EndMembershipModalBottomSheet());
                });
          },
          dense: true,
          leading: const Icon(Icons.cancel),
          title: const AppText(
            text: 'End membership',
            size: AppSizes.bodySmall,
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: AppColors.neutral500,
          ),
        ),
      ]),
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
