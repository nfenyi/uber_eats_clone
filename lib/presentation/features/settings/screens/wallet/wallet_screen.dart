import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/wallet/uber_cash_modal.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_text.dart';
import '../../../payment_options/add_voucher_screen.dart';
import '../../../payment_options/payment_options_screen.dart';
import '../../../main_screen/state/bottom_nav_index_provider.dart';
import '../../../sign_in/views/payment_method_screen.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Wallet',
          size: AppSizes.bodySmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                  valueListenable: Hive.box(AppBoxes.appState)
                      .listenable(keys: [BoxKeys.userInfo]),
                  builder: (context, appStateBox, child) {
                    final userInfo = appStateBox.get(BoxKeys.userInfo);
                    final double cashAmount = userInfo['uberCash']['balance'];

                    return InkWell(
                      onTap: () => showModalBottomSheet(
                        barrierColor: Colors.transparent,
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) {
                          return Container(
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: const UberCashModal());
                        },
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            // boxShadow: const [
                            //   BoxShadow(
                            //     spreadRadius: 1,
                            //     color: Colors.black12,
                            //   )
                            // ],
                            border: Border.all(color: AppColors.neutral200),
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                colors: [Colors.white, AppColors.neutral200])),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(text: 'Uber Cash'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'USD ${cashAmount.toStringAsFixed(2)}',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: AppSizes.heading4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: AppColors.neutral500,
                                  size: 30,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
              const Gap(10),
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.neutral200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            text: 'Send a gift',
                            size: AppSizes.bodySmall,
                            weight: FontWeight.w600,
                          ),
                          const Gap(10),
                          SizedBox(
                            width: Adaptive.w(70),
                            child: const AppText(
                                text:
                                    'You can now send an instant gift card for use on Uber or Uber Eats'),
                          ),
                          const Gap(10),
                          AppButton2(
                              text: 'Send a gift',
                              callback: () {
                                navigatorKey.currentState!.pop();
                                ref
                                    .read(bottomNavIndexProvider.notifier)
                                    .showGiftScreen();
                              })
                        ],
                      ),
                      const Gap(10),
                      Image.asset(
                        AssetNames.walletGift,
                        width: 40,
                      )
                    ],
                  )),
              const Gap(30),
              const AppText(
                text: 'Payment methods',
                weight: FontWeight.w600,
                size: AppSizes.bodySmall,
              ),
              const Gap(10),
              const PaymentMethodsBuilder(),
              AppButton2(
                text: 'Add payment method',
                callback: () async => await navigatorKey.currentState!
                    .push(MaterialPageRoute(
                      builder: (context) => const PaymentMethodScreen(),
                    ))
                    .then(
                      (value) => setState(() {}),
                    ),
              ),
              const Gap(30),
              const AppText(
                text: 'Vouchers',
                weight: FontWeight.w600,
                size: AppSizes.bodySmall,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Iconify(Mdi.ticket_outline),
                title: const AppText(text: 'Vouchers'),
                trailing: ValueListenableBuilder(
                    valueListenable: Hive.box(AppBoxes.appState)
                        .listenable(keys: [BoxKeys.userInfo]),
                    builder: (context, appStateBox, child) {
                      final userInfo = appStateBox.get(BoxKeys.userInfo);
                      final int voucherCount =
                          userInfo['redeemedVouchers'].length;

                      return AppText(text: voucherCount.toString());
                    }),
              ),
              ListTile(
                leading: const Icon(
                  Icons.add,
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  barrierColor: Colors.transparent,
                  builder: (context) {
                    return const AddVoucherScreen();
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const AppText(
                  text: 'Add voucher code',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
