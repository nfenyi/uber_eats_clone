import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_onboarding_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_category_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/state/gift_type_state.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../home/home_screen.dart';
import '../../home/screens/search_screen.dart';

class GiftScreen extends ConsumerStatefulWidget {
  const GiftScreen({super.key});

  @override
  ConsumerState<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends ConsumerState<GiftScreen> {
  final List<FoodCategory> _giftCategories = [
    FoodCategory('Alcohol', AssetNames.giftAlcohol),
    FoodCategory('Sweets', AssetNames.sweets),
    FoodCategory('Retail', AssetNames.giftRetail),
    FoodCategory('Flowers', AssetNames.giftFlowers),
    FoodCategory('Gift Cards', AssetNames.giftCard),
    FoodCategory('Birthday', AssetNames.birthday),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) =>
          ref.read(bottomNavIndexProvider.notifier).updateIndex(3),
      child: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                // surfaceTintColor: const Color.fromARGB(255, 254, 243, 240),
                floating: true,
                backgroundColor: const Color.fromARGB(255, 254, 243, 240),
                pinned: true,
                expandedHeight: 150,
                leading: InkWell(
                  onTap: () {
                    ref.read(bottomNavIndexProvider.notifier).updateIndex(3);
                  },
                  child: Ink(
                    child: const Icon(FontAwesomeIcons.arrowLeft),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 55, bottom: 14),
                  background: Container(
                      color: const Color.fromARGB(255, 254, 243, 240),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText(
                                  text: 'Recipient address',
                                  color: AppColors.neutral600,
                                ),
                                GestureDetector(
                                  onTap: () => navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const AddressesScreen(),
                                  )),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AppText(text: 'Dr University '),
                                      Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Image.asset(AssetNames.sendGifts2),
                        ],
                      )),
                  title: const AppText(
                    text: 'Gifts',
                    weight: FontWeight.w600,
                    size: AppSizes.heading4,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: AppSizes.horizontalPaddingSmall),
                sliver: SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () =>
                        navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => SearchScreen(
                        stores: stores,
                      ),
                    )),
                    child: Ink(
                      child: const AppTextFormField(
                        enabled: false,
                        hintText: 'Search chocolate, flowers, etc.',
                        radius: 50,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 65,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    separatorBuilder: (context, index) => const Gap(15),
                    itemCount: _giftCategories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final giftCategory = _giftCategories[index];
                      return InkWell(
                        onTap: () {
                          if (giftCategory.name == 'Gift Cards') {
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  const GiftCardOnboardingScreen(),
                            ));
                          } else {
                            ref.read(giftTypeStateProvider.notifier).state =
                                giftCategory.name;

                            ref
                                .read(bottomNavIndexProvider.notifier)
                                .showGiftCategoryScreen();
                          }
                        },
                        child: SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Image.asset(
                                giftCategory.image,
                                height: 45,
                              ),
                              AppText(
                                text: giftCategory.name,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
