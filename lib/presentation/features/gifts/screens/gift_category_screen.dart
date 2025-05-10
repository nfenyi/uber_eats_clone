import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/store/store_model.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../../models/advert/advert_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../home/home_screen.dart';
import '../../main_screen/screens/main_screen.dart';
import '../../main_screen/state/bottom_nav_index_provider.dart';
import '../../some_kind_of_section/advert_screen.dart';
import '../state/gift_type_state.dart';

class GiftCategoryScreen extends ConsumerStatefulWidget {
  const GiftCategoryScreen({
    super.key,
  });

  @override
  ConsumerState<GiftCategoryScreen> createState() => _GiftCategoryScreenState();
}

class _GiftCategoryScreenState extends ConsumerState<GiftCategoryScreen> {
  late String _type;

  @override
  void initState() {
    super.initState();
    _type = ref.read(giftTypeStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) =>
          ref.read(bottomNavIndexProvider.notifier).showGiftScreen(),
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar.medium(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        ref
                            .read(bottomNavIndexProvider.notifier)
                            .showGiftScreen();
                      },
                      child: Ink(
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const Gap(10),
                    AppText(
                      text: _type,
                      weight: FontWeight.w600,
                      size: AppSizes.heading6,
                    ),
                  ],
                ),
                // surfaceTintColor: const Color.fromARGB(255, 254, 243, 240),
                floating: true,

                backgroundColor: _type == 'Alcohol'
                    ? const Color.fromARGB(255, 245, 228, 223)
                    : _type == 'Sweets'
                        ? const Color.fromARGB(255, 165, 71, 131)
                        : _type == 'Retail'
                            ? const Color.fromARGB(255, 71, 70, 191)
                            : const Color.fromARGB(255, 202, 149, 105),
                pinned: true,
                expandedHeight: 200,

                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 55, bottom: 14),
                  background: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Image.asset(
                        _type == 'Alcohol'
                            ? AssetNames.giftAlcoholBg
                            : _type == 'Sweets'
                                ? AssetNames.giftSweetsBg
                                : _type == 'Retail'
                                    ? AssetNames.giftRetailBg
                                    : AssetNames.giftBirthdayBg,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                ref
                                    .read(bottomNavIndexProvider.notifier)
                                    .showGiftScreen();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Icon(Icons.arrow_back),
                              ),
                            ),
                            const Spacer(),
                            AppText(
                              text: _type,
                              color: Colors.white,
                              weight: FontWeight.w600,
                              size: AppSizes.heading2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: FutureBuilder<List<Advert>>(
              future: AppFunctions.getGiftCategoryAdverts(_type),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final giftCategoryAdverts = snapshot.data!;

                  if (giftCategoryAdverts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(text: 'No gifts for this category yet'),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: giftCategoryAdverts.length,
                      itemBuilder: (context, index) {
                        final advert = giftCategoryAdverts[index];
                        final store = allStores.firstWhere(
                          (store) {
                            return store.id == advert.shopId;
                          },
                        );

                        return Column(
                          children: [
                            MainScreenTopic(
                                removeDivider: true,
                                callback: () => navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return AdvertScreen(
                                          store: store,
                                          advert: advert,
                                        );
                                      },
                                    )),
                                title: advert.title,
                                subtitle: 'From ${store.name}',
                                imageUrl: store.logo),
                            SizedBox(
                              height: 230,
                              child: ListView.separated(
                                  // shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  itemCount: advert.products.length,
                                  separatorBuilder: (context, index) =>
                                      const Gap(15),
                                  itemBuilder: (context, index) {
                                    final productReference =
                                        advert.products[index];
                                    return FutureBuilder<Product>(
                                        future:
                                            AppFunctions.loadProductReference(
                                                productReference
                                                    as DocumentReference),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  color: AppColors.neutral100,
                                                  width: 110,
                                                  height: 200,
                                                ));
                                          } else if (snapshot.hasError) {
                                            return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  color: AppColors.neutral100,
                                                  width: 110,
                                                  height: 200,
                                                  child: AppText(
                                                    text: snapshot.error
                                                        .toString(),
                                                    size: AppSizes.bodySmallest,
                                                  ),
                                                ));
                                          }

                                          return ProductGridTilePriceFirst(
                                              product: snapshot.data!,
                                              store: store);
                                        });
                                  }),
                            ),
                          ],
                        );
                      });
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall),
                    child: AppText(text: snapshot.error.toString()),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(text: 'Fetching alcohol gifts...'),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
