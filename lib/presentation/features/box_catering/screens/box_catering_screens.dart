import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/entypo.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/state/bottom_nav_index_provider.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';

import '../../../../app_functions.dart';
import '../../../../main.dart';
import '../../../../models/store/store_model.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/other_constants.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

import '../../../core/widgets.dart';
import '../../home/home_screen.dart';
import '../../main_screen/screens/main_screen.dart';
import '../../sign_in/views/drop_off_options_screen.dart';

class BoxCateringScreen extends ConsumerStatefulWidget {
  const BoxCateringScreen({super.key});

  @override
  ConsumerState<BoxCateringScreen> createState() => _BoxCateringScreenState();
}

class _BoxCateringScreenState extends ConsumerState<BoxCateringScreen> {
  List<String> _selectedFilters = [];

  List<Store> _boxCateringStores = [];

  String? _selectedGroupSize;

  String? _selectedSort;

  @override
  Widget build(BuildContext context) {
    final timeOfDayNow = TimeOfDay.now();
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar.medium(
                  leading: GestureDetector(
                      onTap: () => ref
                          .read(bottomNavIndexProvider.notifier)
                          .updateIndex(2),
                      child: const Icon(Icons.arrow_back)),
                  title: const AppText(
                    text: 'Box Catering',
                    weight: FontWeight.w600,
                    size: AppSizes.heading6,
                  ),
                  pinned: true,
                  floating: true,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPaddingSmall,
                      ),
                      color: const Color.fromARGB(255, 246, 239, 233),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                text: 'Box Catering',
                                weight: FontWeight.w600,
                                size: AppSizes.heading5,
                              ),
                              Image.asset(
                                AssetNames.boxCatering,
                                fit: BoxFit.cover,
                                height: 80,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ];
            },
            body: FutureBuilder<List<Store>>(
                future: _fetchBoxCateringStores(),
                builder: (context, snapshot) {
                  if (_boxCateringStores.isEmpty && snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          // fit: BoxFit.fitHeight,
                          AssetNames.storeBNW,
                          height: 100,
                        ),
                        const Gap(10),
                        const AppText(
                          text: 'Stores coming soon',
                        ),
                      ],
                    );
                  } else {
                    if (snapshot.hasData) {
                      final filteredStores = snapshot.data!;

                      return Column(
                        children: [
                          const Gap(10),
                          ChipsChoice<String>.multiple(
                            choiceLeadingBuilder: (item, i) {
                              if (i < 2) {
                                return const AppText(text: '');
                              } else if (i == 2) {
                                return Iconify(
                                  Ph.tag_fill,
                                  size: 15,
                                  color: _selectedFilters.contains('Offers')
                                      ? Colors.white
                                      : Colors.black,
                                );
                              } else {
                                return Iconify(
                                  Entypo.medal,
                                  size: 15,
                                  color:
                                      _selectedFilters.contains('Best overall')
                                          ? Colors.white
                                          : Colors.black,
                                );
                              }
                            },
                            choiceLabelBuilder: (item, i) {
                              if (i == 0) {
                                if (_selectedGroupSize == null) {
                                  return AppText(
                                    text: item.label,
                                  );
                                } else {
                                  return AppText(text: _selectedGroupSize!);
                                }
                              } else if (i == 1) {
                                if (_selectedSort == null) {
                                  return AppText(
                                    text: item.label,
                                  );
                                } else {
                                  return AppText(text: _selectedSort!);
                                }
                              } else {
                                return AppText(
                                  text: item.label,
                                );
                              }
                            },
                            choiceTrailingBuilder: (item, i) {
                              if (i < 2) {
                                return const Icon(
                                    Icons.keyboard_arrow_down_sharp);
                              }
                              return null;
                            },
                            wrapped: false,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            value: _selectedFilters,
                            onChanged: (value) async {
                              late String tappedFilter;
                              if (value.isEmpty) {
                                tappedFilter = _selectedFilters.first;
                              } else if (_selectedFilters.isNotEmpty &&
                                  _selectedFilters.length < value.length) {
                                value.any(
                                  (element) {
                                    if (!_selectedFilters.contains(element)) {
                                      tappedFilter = element;
                                      return true;
                                    }
                                    return false;
                                  },
                                );
                              } else if (_selectedFilters.isNotEmpty &&
                                  _selectedFilters.length > value.length) {
                                for (var filter in _selectedFilters) {
                                  if (!value.contains(filter)) {
                                    tappedFilter = filter;
                                    break;
                                  }
                                }
                              }

                              if (OtherConstants.boxCateringFilters
                                      .indexOf(tappedFilter) ==
                                  0) {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    String? temp = _selectedGroupSize;

                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              // horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Center(
                                                  child: AppText(
                                                text: 'Group size',
                                                size: AppSizes.bodySmall,
                                                weight: FontWeight.w600,
                                              )),
                                              ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  AppRadioListTile(
                                                    padding: EdgeInsets.zero,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    groupValue: temp,
                                                    value: '1-10 people',
                                                    onChanged: (value) {
                                                      setState(() {
                                                        temp = value;
                                                      });
                                                    },
                                                  ),
                                                  AppRadioListTile(
                                                    padding: EdgeInsets.zero,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    groupValue: temp,
                                                    value: '11-24 people',
                                                    onChanged: (value) {
                                                      setState(() {
                                                        temp = value;
                                                      });
                                                    },
                                                  ),
                                                  AppRadioListTile(
                                                    padding: EdgeInsets.zero,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    groupValue: temp,
                                                    value: '25+ people',
                                                    onChanged: (value) {
                                                      setState(() {
                                                        temp = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Gap(20),
                                              AppButton(
                                                text: 'Apply',
                                                callback: () {
                                                  _selectedGroupSize = temp;

                                                  _setStateWithModal(
                                                      value, tappedFilter);
                                                },
                                              ),
                                              Center(
                                                child: AppTextButton(
                                                  size: AppSizes.bodySmall,
                                                  text: 'Reset',
                                                  callback: () {
                                                    _selectedGroupSize = null;
                                                    _resetFilter(value, 0);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );
                              } else if (OtherConstants.boxCateringFilters
                                      .indexOf(tappedFilter) ==
                                  1) {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    var temp = _selectedSort;

                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              // horizontal:
                                              AppSizes.horizontalPaddingSmall),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Center(
                                                  child: AppText(
                                                text: 'Sort',
                                                size: AppSizes.bodySmall,
                                                weight: FontWeight.w600,
                                              )),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: OtherConstants
                                                    .sortOptions.length,
                                                itemBuilder: (context, index) {
                                                  final sortOption =
                                                      OtherConstants
                                                          .sortOptions[index];
                                                  return RadioListTile<
                                                      String>.adaptive(
                                                    value: sortOption,
                                                    title: AppText(
                                                        text: sortOption),
                                                    groupValue: temp,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .trailing,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        temp = value;
                                                      });
                                                    },
                                                  );
                                                  // AppRadioListTile(
                                                  //   groupValue: 'Sort',
                                                  //   value: 'Recommended',
                                                  // ),
                                                  // AppRadioListTile(
                                                  //   groupValue: 'Sort',
                                                  //   value: 'Rating',
                                                  // ),
                                                  // AppRadioListTile(
                                                  //   groupValue: 'Sort',
                                                  //   value: 'Delivery time',
                                                  // ),
                                                },
                                              ),
                                              const Gap(20),
                                              AppButton(
                                                text: 'Apply',
                                                callback: () {
                                                  if (temp != null) {
                                                    _selectedSort = temp;

                                                    _setStateWithModal(
                                                        value, tappedFilter);
                                                  }
                                                },
                                              ),
                                              Center(
                                                child: AppTextButton(
                                                  size: AppSizes.bodySmall,
                                                  text: 'Reset',
                                                  callback: () {
                                                    _selectedSort = null;
                                                    _resetFilter(value, 7);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );
                              } else {
                                setState(() {
                                  if (_selectedFilters.contains(tappedFilter)) {
                                    _selectedFilters.remove(tappedFilter);
                                  } else {
                                    _selectedFilters.add(tappedFilter);
                                  }
                                });
                              }
                            },
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: OtherConstants.boxCateringFilters,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            choiceStyle: C2ChipStyle.filled(
                              selectedStyle: const C2ChipStyle(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              height: 30,
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.neutral200,
                            ),
                          ),
                          const Gap(10),
                          Visibility(
                            visible: filteredStores.isNotEmpty,
                            replacement: const Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Gap(350),
                                AppText(
                                  text: 'No results',
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppSizes.horizontalPaddingSmall),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                          size: AppSizes.heading6,
                                          weight: FontWeight.w600,
                                          text:
                                              '${filteredStores.length} ${filteredStores.length == 1 ? 'Result' : 'Results'}'),
                                      const Gap(20),
                                      ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final store = filteredStores[index];

                                            final bool isClosed = timeOfDayNow
                                                    .isBefore(
                                                        store.openingTime) ||
                                                timeOfDayNow
                                                    .isAfter(store.closingTime);
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              store.cardImage,
                                                          width:
                                                              double.infinity,
                                                          height: 170,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      isClosed
                                                          ? Container(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: double
                                                                  .infinity,
                                                              height: 170,
                                                              child:
                                                                  const Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  AppText(
                                                                    text:
                                                                        'Closed',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : !store.delivery
                                                                  .canDeliver
                                                              ? Container(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  width: double
                                                                      .infinity,
                                                                  height: 170,
                                                                  child:
                                                                      const Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      AppText(
                                                                        text:
                                                                            'Pick up',
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : const SizedBox
                                                                  .shrink(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0,
                                                                top: 8.0),
                                                        child: InkWell(
                                                          onTap: () {},
                                                          child: Ink(
                                                            child: Icon(
                                                              favoriteStores.any(
                                                                      (element) =>
                                                                          element.id ==
                                                                          store
                                                                              .id)
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_outline,
                                                              color: AppColors
                                                                  .neutral300,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const Gap(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppText(
                                                      text: store.name,
                                                      weight: FontWeight.w600,
                                                    ),
                                                    store.bestOverall
                                                        ? Image.asset(
                                                            AssetNames
                                                                .bestOverallWhBg,
                                                            height: 25,
                                                          )
                                                        : AverageRatingWidget(
                                                            store)
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Visibility(
                                                        visible:
                                                            store.delivery.fee <
                                                                1,
                                                        child: Image.asset(
                                                          AssetNames
                                                              .uberOneSmall,
                                                          height: 10,
                                                        )),
                                                    AppText(
                                                      text: isClosed
                                                          ? 'Closed • Available at ${AppFunctions.formatTimeOFDay(store.openingTime)}'
                                                          : '\$${store.delivery.fee} Delivery Fee',
                                                      // color: store.delivery.fee < 1
                                                      //     ? const Color.fromARGB(
                                                      //         255, 163, 133, 42)
                                                      //     : null
                                                    ),
                                                    // AppText(
                                                    //     text:
                                                    //         ' • ${store.delivery.estimatedDeliveryTime} min'),
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const Gap(10),
                                          itemCount: filteredStores.length),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (snapshot.hasError)
                              ? AppText(
                                  text: snapshot.error.toString(),
                                )
                              : const CircularProgressIndicator.adaptive()
                        ],
                      ),
                    );
                  }
                })));
  }

  void _setStateWithModal(List<String> value, String newFilter) {
    navigatorKey.currentState!.pop();
    setState(() {
      if (!_selectedFilters.contains(newFilter)) {
        _selectedFilters.add(newFilter);
      }
    });
  }

  void _resetFilter(
    List<String> value,
    int filterIndex,
  ) {
    navigatorKey.currentState!.pop();
    setState(() {
      List<String> temp = List<String>.from(value);

      temp.removeWhere(
        (element) => element == OtherConstants.boxCateringFilters[filterIndex],
      );

      _selectedFilters = temp;
    });
  }

  Future<List<Store>> _fetchBoxCateringStores() async {
    if (_boxCateringStores.isEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.stores)
          .where('groupSize', isNull: false)
          .get();
      _boxCateringStores = snapshot.docs.map(
        (snapshot) {
          // logger.d(snapshot.data());
          return Store.fromJson(snapshot.data());
        },
      ).toList();
    }
    Iterable<Store> filteredStores = _boxCateringStores;
    if (_selectedFilters.contains('Best overall')) {
      filteredStores = filteredStores.where(
        (store) => store.bestOverall,
      );
    }
    if (_selectedFilters.contains('Offers')) {
      filteredStores = filteredStores.where(
        (store) => store.offers != null && store.offers!.isNotEmpty,
      );
    }
    if (_selectedFilters.contains('Group Size')) {
      switch (_selectedGroupSize) {
        case '11-24 people':
          filteredStores =
              filteredStores.where((store) => store.groupSize! < 25);
          break;
        case '25+ people':
          filteredStores.where((store) => store.groupSize! < 200);
          break;
        default:
          filteredStores.where((store) => store.groupSize! < 10);
          break;
      }
    }
    List<Store> filteredStoresToList = filteredStores.toList();

    if (_selectedFilters.contains('Sort')) {
      if (_selectedSort == 'Rating') {
        filteredStoresToList.sort(
          (a, b) => b.rating.averageRating.compareTo(a.rating.averageRating),
        );
      } else if (_selectedSort == 'Delivery time') {
        filteredStoresToList.sort(
          (a, b) => int.parse(a.delivery.estimatedDeliveryTime.split('-').first)
              .compareTo(
                  int.parse(b.delivery.estimatedDeliveryTime.split('-').first)),
        );
      }
    }

    return filteredStoresToList;
  }
}
