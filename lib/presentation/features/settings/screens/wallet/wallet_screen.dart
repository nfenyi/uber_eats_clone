import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/wallet/uber_cash_modal.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_text.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Wallet',
          size: AppSizes.body,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => showModalBottomSheet(
                  backgroundColor: Colors.transparent,
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
                            'IDR 0.00',
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
              ),
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
                            size: AppSizes.body,
                            weight: FontWeight.w600,
                          ),
                          const Gap(10),
                          SizedBox(
                            width: Adaptive.w(70),
                            child: const AppText(
                                text:
                                    'You can now send an instant gift card, for use on uber or uber Eats'),
                          ),
                          const Gap(10),
                          AppButton2(
                              text: 'Send a gift',
                              callback: () {
                                //TODO: fix gift navigation, no material
                                // navigatorKey.currentState!
                                //     .push(MaterialPageRoute(
                                //   builder: (context) => const GiftScreen(),
                                // ));
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
                size: AppSizes.body,
              ),
              const Gap(10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Image.asset(
                  AssetNames.masterCardLogo,
                  width: 30,
                  height: 20,
                  fit: BoxFit.fitWidth,
                ),
                title: const AppText(text: 'Mastercard ••••4320'),
              ),
              AppButton2(text: 'Add payment method', callback: () {}),
              const Gap(30),
              const AppText(
                text: 'Vouchers',
                weight: FontWeight.w600,
                size: AppSizes.body,
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Iconify(Mdi.ticket_outline),
                title: AppText(text: 'Vouchers'),
                trailing: AppText(text: '0'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.add,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const AppText(
                  text: 'Add voucher code',
                ),
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
