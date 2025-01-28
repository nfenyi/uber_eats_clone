import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../constants/app_sizes.dart';
import '../../home/home_screen.dart';

class CartsScreen extends ConsumerStatefulWidget {
  const CartsScreen({super.key});

  @override
  ConsumerState<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends ConsumerState<CartsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: const AppText(
                        text: 'Carts',
                        size: AppSizes.heading6,
                        weight: FontWeight.w600,
                      ),
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColors.neutral100,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Row(
                              children: [
                                Icon(Icons.list),
                                Gap(5),
                                AppText(text: 'Orders'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: CustomScrollView(
                slivers: [
                  SliverList.separated(
                    itemCount: stores.length,
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.neutral100)),
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(text: store.name),
                                  GestureDetector(
                                      onTap: () {},
                                      child: const Icon(Icons.more_horiz))
                                ],
                              ),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(store.cardImage)),
                              subtitle: AppText(
                                  text:
                                      '3 items • \$11.79\n Deliver by ${AppFunctions.formatDate(DateTime.now().toString(), format: r'g:i A')} to 1226 University Dr'),
                            ),
                            const AppButton(text: 'View cart'),
                            const AppButton(
                              text: 'View store',
                              isSecondary: true,
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(10),
                  ),
                  SliverList.separated(
                    itemCount: stores.length,
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.neutral100)),
                        child: Column(
                          children: [
                            ListTile(
                              title: AppText(text: store.name),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(store.cardImage)),
                              subtitle: AppText(
                                  text:
                                      '3 items • \$11.79\n Deliver by ${AppFunctions.formatDate(DateTime.now().toString(), format: r'g:i A')} to 1226 University Dr'),
                            ),
                            const AppButton(text: 'View cart'),
                            const AppButton(
                              text: 'View store',
                              isSecondary: true,
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(10),
                  )
                ],
              ),
            )));
  }
}
