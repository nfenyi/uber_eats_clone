import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/models/uber_one_status/uber_one_status_model.dart';
import 'package:uber_eats_clone/presentation/constants/other_constants.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/uber_one/manage_membership_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app_functions.dart';
import '../../../../../main.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';
import '../../../../constants/weblinks.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_text.dart';
import '../../../home/home_screen.dart';
import 'exclusive_offers_screen.dart';
import 'switch_to_annual_plan_screen.dart';

class UberOneScreen2 extends ConsumerStatefulWidget {
  final UberOneStatus uberOneStatus;
  const UberOneScreen2(this.uberOneStatus, {super.key});

  @override
  ConsumerState<UberOneScreen2> createState() => _UberOneScreen2State();
}

class _UberOneScreen2State extends ConsumerState<UberOneScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar.medium(
            title: const AppText(
              text: 'Uber One',
              size: AppSizes.heading6,
            ),
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: Row(
                      children: [
                        Image.asset(
                          AssetNames.uberOneSmall,
                          width: 40,
                        ),
                        const AppText(
                          text: 'Uber One',
                          size: AppSizes.heading4,
                          weight: FontWeight.w600,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  children: [
                    const Gap(10),
                    if (widget.uberOneStatus.hasUberOne ||
                        widget.uberOneStatus.moneySaved > 0)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: AppColors.neutral100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  text: 'Money saved',
                                  // size: AppSizes.bodySmall,
                                ),
                                AppText(
                                  text:
                                      '\$${widget.uberOneStatus.moneySaved.toStringAsFixed(2)}',
                                  color: Colors.brown,
                                  size: AppSizes.heading6,
                                )
                              ],
                            ),
                          ),
                          const Gap(15),
                        ],
                      ),
                    if (widget.uberOneStatus.plan == 'Monthly')
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.neutral300,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            onTap: () => navigatorKey.currentState!
                                .push(MaterialPageRoute(
                              builder: (context) => SwitchToAnnualPlanScreen(
                                uberOneStatus: widget.uberOneStatus,
                              ),
                            )),
                            title: const AppText(
                              text: 'Save 20% each year with an annual plan',
                              weight: FontWeight.bold,
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_right,
                              color: AppColors.neutral500,
                            ),
                            leading: Image.asset(
                              AssetNames.uberOneTag,
                              width: 30,
                            ),
                          )),
                    const Gap(10),
                  ],
                ),
              ),
              const Divider(
                thickness: 4,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(10),
                    AppText(
                      text: 'Exclusive offers',
                      size: AppSizes.heading6,
                      weight: FontWeight.bold,
                    ),
                    Gap(10),
                    AppText(
                      text: 'From stores',
                      size: AppSizes.bodySmall,
                      color: AppColors.neutral500,
                    ),
                  ],
                ),
              ),
              const Gap(10),
              FutureBuilder(
                  future: AppFunctions.getOffers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final offers = snapshot.data!;
                      return SizedBox(
                          height: 80,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            separatorBuilder: (context, index) => const Gap(20),
                            itemCount: offers.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final offer = offers.elementAt(index);
                              AppFunctions.loadStoreReference(
                                  offer.store as DocumentReference);
                              return FutureBuilder(
                                  future: AppFunctions.loadStoreReference(
                                      offer.store as DocumentReference),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final store = snapshot.data!;
                                      return Row(
                                        children: [
                                          AppFunctions.displayNetworkImage(
                                            store.cardImage,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                          const Gap(10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: store.name,
                                                weight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    AssetNames.uberOneSmall,
                                                    height: 10,
                                                  ),
                                                  AppText(
                                                    text:
                                                        '\$${store.delivery.fee.toStringAsFixed(2)} Delivery Fee',
                                                  ),
                                                ],
                                              ),
                                              AppText(
                                                  text:
                                                      '${store.delivery.estimatedDeliveryTime} min'),
                                              StoreOffersText(
                                                store,
                                                color: Colors.brown,
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return AppText(
                                        text: snapshot.error.toString(),
                                      );
                                    } else {
                                      return Skeletonizer(
                                        enabled: true,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              color: AppColors.neutral100,
                                            ),
                                            const Gap(10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const AppText(
                                                  text: 'lsakjsf',
                                                  weight: FontWeight.bold,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      AssetNames.uberOneSmall,
                                                      height: 10,
                                                    ),
                                                    const AppText(
                                                      text:
                                                          '\$klassa Delivery Fee',
                                                    ),
                                                  ],
                                                ),
                                                const AppText(
                                                    text: 'jklsamakl min'),
                                                const AppText(
                                                  text: 'mlsmoffers available',
                                                  color: Colors.brown,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  });
                            },
                          ));
                    } else if (snapshot.hasError) {
                      return AppText(text: snapshot.error.toString());
                    } else {
                      return Skeletonizer(
                        enabled: true,
                        child: SizedBox(
                            height: 80,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              separatorBuilder: (context, index) =>
                                  const Gap(20),
                              itemCount: 2,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Container(
                                      color: AppColors.neutral100,
                                      width: 80,
                                      height: 80,
                                    ),
                                    const Gap(10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const AppText(
                                          text: 'jksljlkaslakf',
                                          weight: FontWeight.bold,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AssetNames.uberOneSmall,
                                              height: 10,
                                            ),
                                            const AppText(
                                              text: 'jaslnlsfsa',
                                            ),
                                          ],
                                        ),
                                        const AppText(text: 'mksmallmsmin'),
                                        const AppText(
                                          text: 'mkalsmsaffers available',
                                          color: Colors.brown,
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            )),
                      );
                    }
                  }),
              const Gap(5),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    // backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => const ExclusiveOffersScreen(),
                  );
                },
                title: const AppText(
                  text: 'See more',
                  size: AppSizes.bodySmall,
                ),
                trailing: const Icon(
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
                  text: 'Benefits',
                  weight: FontWeight.bold,
                  size: AppSizes.heading6,
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Gap(10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final benefit = OtherConstants.benefits[index];
                  return ListTile(
                    leading: Image.asset(
                      benefit.assetImage,
                      width: 40,
                    ),
                    title: AppText(
                      text: benefit.message,
                      size: AppSizes.bodySmallest,
                    ),
                  );
                },
                itemCount: 4,
              ),
              const Divider(
                thickness: 4,
              ),
              if (widget.uberOneStatus.hasUberOne == true)
                Column(
                  children: [
                    ListTile(
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const ManageMembershipScreen(),
                        ));
                      },
                      title: const AppText(
                        text: 'Manage membership',
                        size: AppSizes.bodySmall,
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: Column(
                  children: [
                    const AppText(
                        color: AppColors.neutral500,
                        size: AppSizes.bodySmallest,
                        text:
                            '*Benefits available only for eligible stores and rides marked with the Uber One icon. Participating restaurants and non-grocery stores: \$15 minimum order to receive \$0 Delivery Fee and up to 10% off. Participating grocery stores: \$35 minimum order to receive \$0 Delivery Fee and 5% off. Membership savings applied as a reduction to service fees. 6% Uber Cash earned after completion of eligible rides. Taxes and similar fees, as applicable, do not apply towards order minimums or Uber Cash back benefits. Other fees and exclusions may apply.'),
                    const Gap(10),
                    RichText(
                      text: TextSpan(
                          text:
                              "Estimated savings do not include subscription price. Actual savings may vary. ",
                          style: const TextStyle(
                            fontSize: AppSizes.bodySmallest,
                            color: AppColors.neutral500,
                          ),
                          children: [
                            TextSpan(
                              text: 'View terms and conditions',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launchUrl(
                                      Uri.parse(Weblinks.uberOneTerms));
                                },
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              const Gap(30)
            ],
          ),
        ),
      ),
    );
  }
}
