import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/screens/gift_card_onboarding_screen.dart';
import 'package:uber_eats_clone/presentation/features/gifts/state/gift_type_state.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/states/onboarding_state_model.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';

import '../../../../main.dart';
import '../../../../models/advert/advert_model.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';

import '../../home/home_screen.dart';
import '../../home/screens/search_screen.dart';
import '../../some_kind_of_section/advert_screen.dart';
import 'gift_card_screen.dart';

class GiftScreen extends ConsumerStatefulWidget {
  const GiftScreen({super.key});

  @override
  ConsumerState<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends ConsumerState<GiftScreen> {
  late AddressDetails _recipientAddress;

  final List<FoodCategory> _giftCategories = [
    FoodCategory('Alcohol', AssetNames.giftAlcohol),
    FoodCategory('Sweets', AssetNames.sweets),
    FoodCategory('Retail', AssetNames.giftRetail),
    FoodCategory('Flowers', AssetNames.giftFlowers),
    FoodCategory('Gift Cards', AssetNames.giftCard),
    FoodCategory('Birthday', AssetNames.birthday),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(tempAddressForRecipient) == null) {
      final Map userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);

      //🙄 The following two statements because i was getting type '_Map<dynamic, dynamic>' is not a subtype of type 'Map<String, dynamic>'
      final selectedAddress = userInfo['selectedAddress']; //
      selectedAddress as Map<dynamic, dynamic>; //
      Map<String, dynamic> stringedKeyMap = selectedAddress.map((key, value) {
        return MapEntry(key.toString(), value);
      });
      stringedKeyMap['latlng'] = GeoPoint(stringedKeyMap['latlng'].latitude,
          stringedKeyMap['latlng'].longitude);
      _recipientAddress = AddressDetails.fromJson(stringedKeyMap);
    } else {
      _recipientAddress = ref.read(tempAddressForRecipient)!;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          ref.read(bottomNavIndexProvider.notifier).updateIndex(2),
      child: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar.medium(
                title: Row(
                  children: [
                    const AppText(
                      text: 'Gifts',
                      weight: FontWeight.w600,
                      size: AppSizes.heading4,
                    ),
                    Expanded(
                      child: Image.asset(
                        AssetNames.sendGifts2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                // surfaceTintColor: const Color.fromARGB(255, 254, 243, 240),
                floating: true,
                backgroundColor: const Color.fromARGB(255, 254, 243, 240),
                pinned: true,
                expandedHeight: 150,
                leading: InkWell(
                  onTap: () {
                    ref.read(bottomNavIndexProvider.notifier).updateIndex(2);
                  },
                  child: Ink(
                    child: const Icon(FontAwesomeIcons.arrowLeft),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 55, bottom: 14),
                  background: Container(
                      color: const Color.fromARGB(255, 254, 243, 240),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(AssetNames.sendGifts2),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText(
                                  text: 'Gifts',
                                  weight: FontWeight.w600,
                                  size: AppSizes.heading4,
                                ),
                                const Gap(15),
                                const AppText(
                                  text: 'Recipient address',
                                  color: AppColors.neutral600,
                                ),
                                GestureDetector(
                                  onTap: () => navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => AddressesScreen(
                                      isFromGiftScreen: true,
                                      recipientAddressLabel:
                                          _recipientAddress.addressLabel,
                                    ),
                                  )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AppText(
                                          text: AppFunctions
                                                  .formatPlaceDescription(
                                                      _recipientAddress
                                                          .placeDescription)
                                              .split(', ')
                                              .first),
                                      const Gap(5),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
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
                        stores: allStores,
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
                    separatorBuilder: (context, index) => const Gap(20),
                    itemCount: _giftCategories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final giftCategory = _giftCategories[index];
                      return InkWell(
                        onTap: () {
                          if (giftCategory.name == 'Gift Cards') {
                            if (Hive.box(AppBoxes.appState).get(
                                BoxKeys.isOnboardedToUberGifts,
                                defaultValue: false)) {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                  builder: (context) => const GiftCardScreen(),
                                  settings: const RouteSettings(
                                      name: '/giftCardScreen')));
                            } else {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) =>
                                    const GiftCardOnboardingScreen(),
                              ));
                            }
                          } else {
                            ref.read(giftTypeStateProvider.notifier).state =
                                giftCategory.name;

                            ref
                                .read(bottomNavIndexProvider.notifier)
                                .showGiftCategoryScreen();
                          }
                        },
                        child: SizedBox(
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
              ),
              FutureBuilder<List<Advert>>(
                  future: AppFunctions.getGiftAdverts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final giftAdverts = snapshot.data!;
                      return SliverList.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final advert = giftAdverts[index];
                            final store = allStores.firstWhere(
                              (store) {
                                return store.id == advert.shopId;
                              },
                            );

                            return Column(
                              children: [
                                MainScreenTopic(
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
                                  height: 235,
                                  child: ListView.separated(
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
                                            future: AppFunctions
                                                .loadProductReference(
                                                    productReference
                                                        as DocumentReference),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Container(
                                                      color:
                                                          AppColors.neutral100,
                                                      width: 110,
                                                      height: 210,
                                                    ));
                                              } else if (snapshot.hasError) {
                                                return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Container(
                                                      color:
                                                          AppColors.neutral100,
                                                      width: 110,
                                                      height: 210,
                                                      child: AppText(
                                                        text: snapshot.error
                                                            .toString(),
                                                        size: AppSizes
                                                            .bodySmallest,
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
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          child: AppText(text: snapshot.error.toString()),
                        ),
                      );
                    }
                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  }),
              // ref.watch(storesProvider).when(
              //     data: (data) {

              //       return Column(
              //         children: [
              //           SliverToBoxAdapter(
              //               child: MainScreenTopic(
              //                   callback: () {}, title: 'All Stores')),
              //           AllStoresSliver(
              //             stores: data,
              //           ),
              //         ],
              //       );
              //     },
              //     error: (error, stackTrace) => SliverToBoxAdapter(child: AppText(text: error.toString()),),
              //     loading: () => const SizedBox.shrink(),)
              if (allStores.isNotEmpty)
                SliverToBoxAdapter(
                    child:
                        MainScreenTopic(callback: () {}, title: 'All Stores')),

              AllStoresSliver(
                stores: allStores,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllStoresSliver extends StatelessWidget {
  final List<Store> stores;
  const AllStoresSliver({
    super.key,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDayNow = TimeOfDay.now();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPaddingSmall),
      sliver: SliverList.separated(
          itemBuilder: (context, index) {
            final store = stores[index];
            final bool isClosed = timeOfDayNow.hour < store.openingTime.hour ||
                (timeOfDayNow.hour >= store.closingTime.hour &&
                    timeOfDayNow.minute >= store.closingTime.minute);
            return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.neutral200)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: store.logo,
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title: AppText(text: store.name),
                contentPadding: EdgeInsets.zero,
                trailing: FavouriteButton(
                  store: store,
                  color: AppColors.neutral500,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Visibility(
                            visible: store.delivery.fee < 1,
                            child: Image.asset(
                              AssetNames.uberOneSmall,
                              height: 10,
                            )),
                        AppText(
                            text: isClosed
                                ? store.openingTime.hour - timeOfDayNow.hour > 1
                                    ? 'Available at ${AppFunctions.formatDate(store.openingTime.toString(), format: 'h:i A')}'
                                    : 'Available in ${store.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${store.openingTime.minute - timeOfDayNow.minute} mins'}'
                                : '\$${store.delivery.fee} Delivery Fee',
                            color: store.delivery.fee < 1
                                ? const Color.fromARGB(255, 163, 133, 42)
                                : null),
                        AppText(
                            text:
                                ' • ${store.delivery.estimatedDeliveryTime} min'),
                      ],
                    ),
                    const AppText(
                      text: 'Offers available',
                      color: Colors.green,
                    )
                  ],
                ));
          },
          separatorBuilder: (context, index) => const Divider(
                indent: 30,
              ),
          itemCount: stores.length),
    );
  }
}
