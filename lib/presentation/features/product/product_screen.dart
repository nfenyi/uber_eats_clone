import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/octicon.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/carts_screen.dart';
import 'package:uber_eats_clone/presentation/features/product/back_up_option_screen.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';
import 'package:uber_eats_clone/state/user_location_providers.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../app_functions.dart';
import '../../../hive_adapters/cart_item/cart_item_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/weblinks.dart';
import '../../core/app_colors.dart';
import '../address/screens/addresses_screen.dart';
import '../webview/webview_screen.dart';
import 'product_image_screen.dart';
import 'sub_option_selection_screen.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final Store store;
  final Product product;
  const ProductScreen({required this.product, required this.store, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  late final Product _product;
  final _cart = Hive.box<HiveCartItem>(AppBoxes.carts);
  late double initialSubTotal;
  late double initialInitialPricesTotal;
  String? _backupInstruction = 'Best match';
  final _webViewcontroller = WebViewControllerPlus();
  int _activeIndex = 0;
  int _quantity = 1;
  final _noteController = TextEditingController();
  bool _isLoading = false;
  String? _selectedReplacementId;
  HiveCartProduct? _productInbox;
  HiveCartItem? _cartItemInBox;
  final Map<String, List<HiveOption>> _requiredOptions = {};
  final Map<String, List<HiveOption>> _optionalOptions = {};
  // List<String?> _optionalOptions = [];

  // List<String> _requiredOptions = [];
  List<int> _optionQuantities = [];

  final _productsBox = Hive.box<HiveCartProduct>(AppBoxes.storedProducts);
  // String? _selectedSubOption;

  @override
  void initState() {
    super.initState();
    _product = widget.product;

    _cartItemInBox = _cart.get(widget.store.id);
    if (_cartItemInBox != null) {
      _productInbox = _cartItemInBox!.products.firstWhereOrNull(
        (element) => element.id == _product.id,
      );
      if (_productInbox != null) {
        for (var storedOptions in _productInbox!.requiredOptions) {
          if (_requiredOptions[storedOptions.categoryName] == null) {
            _requiredOptions[storedOptions.categoryName] = [storedOptions];
          } else {
            _requiredOptions[storedOptions.categoryName]!.add(storedOptions);
          }
          _optionQuantities.add(storedOptions.quantity);
        }

        for (var storedOptions in _productInbox!.optionalOptions) {
          if (_optionalOptions[storedOptions.categoryName] == null) {
            _optionalOptions[storedOptions.categoryName] = [storedOptions];
          } else {
            _optionalOptions[storedOptions.categoryName]!.add(storedOptions);
          }
          _optionQuantities.add(storedOptions.quantity);
        }
        _quantity = _productInbox!.quantity;
        _noteController.text = _productInbox!.note;
        _backupInstruction = _productInbox!.backupInstruction;
        _quantity = _productInbox!.quantity;

        _selectedReplacementId = _productInbox?.productReplacementId;
      } else {
        _optionQuantities = List.generate(
            _product.requiredOptions.length + _product.optionalOptions.length,
            (index) => 0,
            growable: false);
      }
    }
    initialSubTotal = _cartItemInBox?.subtotal ?? 0;
    initialInitialPricesTotal = _cartItemInBox?.initialPricesTotal ?? 0;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double currentTotal =
        ((_product.promoPrice ?? _product.initialPrice) * _quantity);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar.medium(
                  title: AppText(
                    text: _product.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  pinned: true,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    // titlePadding: EdgeInsets.only(left: 50),

                    background: SafeArea(
                      child: Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: _product.imageUrls.length,
                            itemBuilder: (context, index, realIndex) {
                              if (_product.imageUrls.first.startsWith('http')) {
                                return InkWell(
                                  onTap: () => navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => ProductImageScreen(
                                      imageUrl: _product.imageUrls[index],
                                      productName: _product.name,
                                    ),
                                  )),
                                  child: Ink(
                                    child: ClipRRect(
                                      // borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        imageUrl: _product.imageUrls[index],
                                        height: 80,
                                        // width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_product.imageUrls.first
                                  .startsWith('data:image')) {
                                // It's a base64 string
                                try {
                                  String base64String =
                                      _product.imageUrls.first.split(',').last;
                                  Uint8List bytes = base64Decode(base64String);
                                  return InkWell(
                                    onTap: () => navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductImageScreen(
                                        imageUrl: _product.imageUrls[index],
                                        productName: _product.name,
                                      ),
                                    )),
                                    child: Ink(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.memory(
                                            height: 80,
                                            fit: BoxFit.fitHeight,
                                            bytes),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  logger.d('Error decoding base64 image: $e');
                                  return const AppText(
                                      text: 'Error loading image');
                                }
                              } else {
                                // Handle invalid image source (neither URL nor base64)
                                return const AppText(
                                    text: 'Invalid image source');
                              }

                              // return CachedNetworkImage(
                              //   // width: double.infinity,
                              //   imageUrl: _product.imageUrls[index],
                              //   height: 80,
                              //   fit: BoxFit.fitHeight,
                              // );
                            },
                            options: CarouselOptions(
                                padEnds: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _activeIndex = index;
                                  });
                                },
                                aspectRatio: 1,
                                height: 200,
                                enableInfiniteScroll: false,
                                viewportFraction: 1),
                          ),
                          if (_product.imageUrls.length > 1)
                            Column(
                              children: [
                                const Gap(10),
                                AnimatedSmoothIndicator(
                                  activeIndex: _activeIndex,
                                  count: _product.imageUrls.length,
                                  effect: const WormEffect(
                                      activeDotColor: Colors.black,
                                      dotHeight: 5,
                                      dotWidth: 5,
                                      dotColor: AppColors.neutral100),
                                ),
                              ],
                            ),
                          const Gap(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.horizontalPaddingSmall),
                            child: AppText(
                              text: _product.name,
                              weight: FontWeight.bold,
                              size: AppSizes.heading6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  expandedHeight: 280,
                )
              ],
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_product.calories != null)
                            AppText(
                              text: '${_product.calories!.toInt()} Cal.',
                              size: AppSizes.bodySmall,
                            ),
                          Row(
                            children: [
                              Visibility(
                                visible: _product.promoPrice != null,
                                child: Row(
                                  children: [
                                    AppText(
                                        text: '\$${_product.promoPrice}',
                                        size: AppSizes.body,
                                        weight: FontWeight.bold,
                                        color: Colors.green.shade900),
                                    const Gap(5),
                                  ],
                                ),
                              ),
                              AppText(
                                text: '\$${_product.initialPrice}',
                                size: AppSizes.body,
                                decoration: _product.promoPrice != null
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: AppColors.neutral500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverList.separated(
                itemCount: _product.requiredOptions.length,
                itemBuilder: (context, optionIndex) {
                  final option = _product.requiredOptions[optionIndex];

                  return Column(
                    children: [
                      Column(
                        children: [
                          const Divider(
                            thickness: 3,
                          ),
                          ListTile(
                            title: AppText(
                              text: option.name,
                              size: AppSizes.body,
                              weight: FontWeight.w600,
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: _requiredOptions[option.name] != null
                                    ? const Color.fromARGB(255, 206, 232, 221)
                                    : AppColors.neutral100,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_requiredOptions[option.name] != null)
                                    const Icon(
                                      Icons.check,
                                      color: AppColors.primary2,
                                    ),
                                  const Gap(3),
                                  AppText(
                                      text: 'Required',
                                      color:
                                          _requiredOptions[option.name] != null
                                              ? AppColors.primary2
                                              : null)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      option.isExclusive == true
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: option.subOptions.length,
                              itemBuilder: (context, subOptionIndex) {
                                final subOption =
                                    option.subOptions[subOptionIndex];
                                final selectedSubOption =
                                    _requiredOptions[option.name]?.firstOrNull;
                                return Column(
                                  children: [
                                    RadioListTile.adaptive(
                                      title: AppText(text: subOption.name),
                                      value: subOption.name,
                                      groupValue: selectedSubOption,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _requiredOptions[option.name] = [
                                              HiveOption(
                                                  name: subOption.name,
                                                  categoryName: option.name)
                                            ];
                                          });
                                        }
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      subtitle: AppText(
                                          text: subOption.price.toString()),
                                    ),
                                    if (_requiredOptions[option.name] != null &&
                                        option.subOptions.isNotEmpty)
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: AppColors.neutral100,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            if (selectedSubOption != null)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    text:
                                                        '${option.name} Additions',
                                                    weight: FontWeight.bold,
                                                    size: AppSizes.body,
                                                  ),
                                                  AppText(
                                                    text:
                                                        selectedSubOption.name,
                                                    color: AppColors.neutral500,
                                                  )
                                                ],
                                              ),
                                            ListTile(
                                              onTap: () => navigatorKey
                                                  .currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    SubOptionSelectionScreen(
                                                  currentTotal: currentTotal,
                                                  productInbox: _productInbox,
                                                  option: option,
                                                ),
                                              )),
                                              title: const AppText(
                                                text: 'Edit selections',
                                                weight: FontWeight.bold,
                                              ),
                                              trailing: const Icon(
                                                Icons.keyboard_arrow_right,
                                                color: AppColors.neutral500,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                );
                              },
                            )
                          : Builder(builder: (context) {
                              int chosenQuantity = 0;
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: option.subOptions.length,
                                  itemBuilder: (context, subOptionIndex) {
                                    final subOption =
                                        option.subOptions[subOptionIndex];

                                    return subOption.canBeMultiple
                                        ? ListTile(
                                            trailing: _optionQuantities[
                                                        subOptionIndex] ==
                                                    0
                                                ? TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        backgroundColor:
                                                            AppColors
                                                                .neutral100,
                                                        shape:
                                                            const CircleBorder()),
                                                    onPressed: chosenQuantity ==
                                                            option
                                                                .canBeMultipleLimit
                                                        ? null
                                                        : () {
                                                            setState(() {
                                                              _optionQuantities[
                                                                  subOptionIndex] = 1;
                                                              chosenQuantity +=
                                                                  1;
                                                            });
                                                          },
                                                    child: const AppText(
                                                      text: '+',
                                                      size: AppSizes.body,
                                                    ))
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                        TextButton(
                                                            style: TextButton.styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .neutral100,
                                                                shape:
                                                                    const CircleBorder()),
                                                            onPressed: () {
                                                              setState(() {
                                                                _optionQuantities[
                                                                    subOptionIndex] -= 1;
                                                                chosenQuantity -=
                                                                    1;
                                                              });
                                                            },
                                                            child: const AppText(
                                                                text: '-',
                                                                size: AppSizes
                                                                    .body)),
                                                        AppText(
                                                            text: _optionQuantities[
                                                                    subOptionIndex]
                                                                .toString()),
                                                        TextButton(
                                                            style: TextButton.styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .neutral100,
                                                                shape:
                                                                    const CircleBorder()),
                                                            onPressed: _optionQuantities[
                                                                        subOptionIndex] <=
                                                                    option
                                                                        .canBeMultipleLimit!
                                                                ? () {
                                                                    setState(
                                                                        () {
                                                                      _optionQuantities[
                                                                          subOptionIndex] += 1;
                                                                      chosenQuantity +=
                                                                          1;
                                                                    });
                                                                  }
                                                                : null,
                                                            child: const AppText(
                                                                text: '+',
                                                                size: AppSizes
                                                                    .body)),
                                                      ]),
                                            title: AppText(
                                              text: subOption.name,
                                            ),
                                            subtitle: subOption.price != null ||
                                                    subOption.calories != null
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (subOption.price !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '+  ${_optionQuantities[subOptionIndex] == 0 ? '\$${subOption.price}' : '\$${subOption.price! * _optionQuantities[subOptionIndex]} (\$${subOption.price!.toStringAsFixed(2)} ea)'} ',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                      if (subOption.calories !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '${subOption.calories!.toInt()} Cal.',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                    ],
                                                  )
                                                : null,
                                          )
                                        : CheckboxListTile.adaptive(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: AppText(
                                              text: subOption.name,
                                            ),
                                            subtitle: subOption.price != null ||
                                                    subOption.calories != null
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (subOption.price !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '+ \$${subOption.price}',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                      if (subOption.calories !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '${subOption.calories!.toInt()} Cal.',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                    ],
                                                  )
                                                : null,
                                            value: _requiredOptions[
                                                        option.name] !=
                                                    null &&
                                                _requiredOptions[option.name]!
                                                    .any(
                                                  (option) =>
                                                      option.name ==
                                                      subOption.name,
                                                ),
                                            onChanged: (value) {
                                              setState(() {
                                                if (_requiredOptions[
                                                        option.name] ==
                                                    null) {
                                                  _requiredOptions[
                                                      option.name] = [
                                                    HiveOption(
                                                        name: subOption.name,
                                                        categoryName:
                                                            option.name)
                                                  ];
                                                } else {
                                                  if (_requiredOptions[
                                                              option.name]!
                                                          .firstWhereOrNull(
                                                        (option) =>
                                                            option.name ==
                                                            subOption.name,
                                                      ) ==
                                                      null) {
                                                    _requiredOptions[
                                                            option.name]!
                                                        .add(HiveOption(
                                                            name:
                                                                subOption.name,
                                                            categoryName:
                                                                option.name));
                                                  } else {
                                                    _requiredOptions[
                                                            option.name]!
                                                        .removeWhere(
                                                      (option) =>
                                                          option.name ==
                                                          subOption.name,
                                                    );
                                                  }
                                                }
                                              });
                                            },
                                          );
                                  });
                            })
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
              SliverList.separated(
                itemCount: _product.optionalOptions.length,
                itemBuilder: (context, index) {
                  final option = _product.optionalOptions[index];

                  return Column(
                    children: [
                      option.isExclusive == true
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: option.subOptions.length,
                              itemBuilder: (context, index) {
                                final subOption = option.subOptions[index];
                                final selectedSubOption =
                                    _optionalOptions[option.name]?.firstOrNull;
                                return Column(
                                  children: [
                                    RadioListTile.adaptive(
                                      title: AppText(text: subOption.name),
                                      value: subOption.name,
                                      groupValue: selectedSubOption,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _optionalOptions[option.name] = [
                                              HiveOption(
                                                  name: subOption.name,
                                                  categoryName: option.name)
                                            ];
                                          });
                                        }
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      subtitle: AppText(
                                          text: subOption.price.toString()),
                                    ),
                                    if (_optionalOptions[option.name] != null &&
                                        option.subOptions.isNotEmpty)
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: AppColors.neutral100,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            if (selectedSubOption != null)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    text:
                                                        '${option.name} Additions',
                                                    weight: FontWeight.bold,
                                                    size: AppSizes.body,
                                                  ),
                                                  AppText(
                                                    text:
                                                        selectedSubOption.name,
                                                    color: AppColors.neutral500,
                                                  )
                                                ],
                                              ),
                                            ListTile(
                                              onTap: () => navigatorKey
                                                  .currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    SubOptionSelectionScreen(
                                                  currentTotal: currentTotal,
                                                  productInbox: _productInbox,
                                                  option: option,
                                                ),
                                              )),
                                              title: const AppText(
                                                text: 'Edit selections',
                                                weight: FontWeight.bold,
                                              ),
                                              trailing: const Icon(
                                                Icons.keyboard_arrow_right,
                                                color: AppColors.neutral500,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                );
                              },
                            )
                          : Builder(builder: (context) {
                              int chosenQuantity = 0;
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: option.subOptions.length,
                                  itemBuilder: (context, index) {
                                    final subOption = option.subOptions[index];

                                    return subOption.canBeMultiple
                                        ? ListTile(
                                            trailing: _optionQuantities[_product
                                                            .requiredOptions
                                                            .length +
                                                        index] ==
                                                    0
                                                ? TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        backgroundColor:
                                                            AppColors
                                                                .neutral100,
                                                        shape:
                                                            const CircleBorder()),
                                                    onPressed: chosenQuantity ==
                                                            option
                                                                .canBeMultipleLimit
                                                        ? null
                                                        : () {
                                                            setState(() {
                                                              _optionQuantities[_product
                                                                      .requiredOptions
                                                                      .length +
                                                                  index] = 1;
                                                            });
                                                          },
                                                    child: const AppText(
                                                      text: '+',
                                                      size: AppSizes.body,
                                                    ))
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                        TextButton(
                                                            style: TextButton.styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .neutral100,
                                                                shape:
                                                                    const CircleBorder()),
                                                            onPressed: () {
                                                              setState(() {
                                                                _optionQuantities[_product
                                                                        .requiredOptions
                                                                        .length +
                                                                    index] -= 1;
                                                                chosenQuantity -=
                                                                    1;
                                                              });
                                                            },
                                                            child: const AppText(
                                                                text: '-',
                                                                size: AppSizes
                                                                    .body)),
                                                        AppText(
                                                            text: _optionQuantities[_product
                                                                        .requiredOptions
                                                                        .length +
                                                                    index]
                                                                .toString()),
                                                        TextButton(
                                                            style: TextButton.styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                backgroundColor:
                                                                    AppColors
                                                                        .neutral100,
                                                                shape:
                                                                    const CircleBorder()),
                                                            onPressed: _optionQuantities[_product
                                                                            .requiredOptions
                                                                            .length +
                                                                        index] <=
                                                                    option
                                                                        .canBeMultipleLimit!
                                                                ? () {
                                                                    setState(
                                                                        () {
                                                                      _optionQuantities[_product
                                                                              .requiredOptions
                                                                              .length +
                                                                          index] += 1;
                                                                      chosenQuantity +=
                                                                          1;
                                                                    });
                                                                  }
                                                                : null,
                                                            child: const AppText(
                                                                text: '+',
                                                                size: AppSizes
                                                                    .body)),
                                                      ]),
                                            title: AppText(
                                              text: subOption.name,
                                            ),
                                            subtitle: subOption.price != null ||
                                                    subOption.calories != null
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (subOption.price !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '+  ${_optionQuantities[_product.requiredOptions.length + index] == 0 ? '\$${subOption.price}' : '\$${subOption.price! * _optionQuantities[_product.requiredOptions.length + index]} (\$${subOption.price!.toStringAsFixed(2)} ea)'} ',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                      if (subOption.calories !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '${subOption.calories!.toInt()} Cal.',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                    ],
                                                  )
                                                : null,
                                          )
                                        : CheckboxListTile.adaptive(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: AppText(
                                              text: subOption.name,
                                            ),
                                            subtitle: subOption.price != null ||
                                                    subOption.calories != null
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (subOption.price !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '+ \$${subOption.price}',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                      if (subOption.calories !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '${subOption.calories!.toInt()} Cal.',
                                                          color: AppColors
                                                              .neutral500,
                                                        ),
                                                    ],
                                                  )
                                                : null,
                                            value: _optionalOptions[
                                                        option.name] !=
                                                    null &&
                                                _optionalOptions[option.name]!
                                                    .any(
                                                  (option) =>
                                                      option.name ==
                                                      subOption.name,
                                                ),
                                            onChanged: (value) {
                                              setState(() {
                                                if (_optionalOptions[
                                                        option.name] ==
                                                    null) {
                                                  _optionalOptions[
                                                      option.name] = [
                                                    HiveOption(
                                                        name: subOption.name,
                                                        categoryName:
                                                            option.name)
                                                  ];
                                                } else {
                                                  if (_optionalOptions[
                                                              option.name]!
                                                          .firstWhereOrNull(
                                                        (option) =>
                                                            option.name ==
                                                            subOption.name,
                                                      ) ==
                                                      null) {
                                                    _optionalOptions[
                                                            option.name]!
                                                        .add(HiveOption(
                                                            name:
                                                                subOption.name,
                                                            categoryName:
                                                                option.name));
                                                  } else {
                                                    _optionalOptions[
                                                            option.name]!
                                                        .removeWhere(
                                                      (option) =>
                                                          option.name ==
                                                          subOption.name,
                                                    );
                                                  }
                                                }
                                              });
                                            },
                                          );
                                  });
                            })
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Gap(15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    if (_quantity == 1 &&
                                        _productInbox != null) {
                                      _cartItemInBox!.subtotal -=
                                          _product.promoPrice ??
                                              _product.initialPrice;
                                      _cartItemInBox!.initialPricesTotal -=
                                          _product.initialPrice;
                                      await _cartItemInBox!.save();
                                      await _productInbox!.delete().then(
                                        (value) {
                                          if (_cartItemInBox!
                                              .products.isEmpty) {
                                            _cartItemInBox!.delete();
                                          }
                                        },
                                      );
                                      setState(() {
                                        _productInbox = null;
                                      });
                                    } else {
                                      if (_quantity != 1) {
                                        setState(() {
                                          _quantity -= 1;
                                        });
                                      }
                                    }
                                  },
                                  child: Ink(
                                      child: (_quantity == 1 &&
                                              _productInbox != null)
                                          ? const Icon(Icons.delete_outline)
                                          : Iconify(
                                              Octicon.dash_24,
                                              color: (_quantity != 1)
                                                  ? Colors.black
                                                  : AppColors.neutral300,
                                            ))),
                              AppText(
                                text: _quantity.toString(),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _quantity += 1;
                                    });
                                  },
                                  child: Ink(child: const Icon(Icons.add)))
                            ],
                          ),
                        ),
                      ),
                      // Add note
                      if (_product.similarProducts.isNotEmpty)
                        Column(children: [
                          const Gap(10),
                          ListTile(
                              onTap: () {
                                showModalBottomSheet(
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppBar(
                                                title: const AppText(
                                                  text:
                                                      'Add replacement or note',
                                                  size: AppSizes.heading6,
                                                ),
                                                leading: GestureDetector(
                                                    onTap: () => navigatorKey
                                                        .currentState!
                                                        .pop(),
                                                    child: const Icon(
                                                        Icons.clear)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: AppSizes
                                                        .horizontalPaddingSmall),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const AppText(
                                                      text: 'Add note',
                                                      size: AppSizes.bodySmall,
                                                    ),
                                                    const Gap(10),
                                                    AppTextFormField(
                                                      controller:
                                                          _noteController,
                                                      hintText:
                                                          'e.g. Green bananas please',
                                                    ),
                                                    const Gap(10),
                                                    const AppText(
                                                      text:
                                                          'Backup instructions',
                                                      size: AppSizes.bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RadioListTile(
                                                onChanged: (value) {
                                                  setState(() {
                                                    _backupInstruction = value;
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                value: 'Best match',
                                                subtitle: const AppText(
                                                    text:
                                                        'Your shopper will select an item similar price and quality'),
                                                groupValue: _backupInstruction,
                                              ),
                                              RadioListTile(
                                                onChanged: (value) {
                                                  setState(() {
                                                    _backupInstruction = value;
                                                  });
                                                },
                                                secondary: AppButton2(
                                                    text: 'Select',
                                                    callback: () async {
                                                      final temp =
                                                          await navigatorKey
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                        builder: (context) {
                                                          return BackUpOptionScreen(
                                                              product: widget
                                                                  .product,
                                                              store:
                                                                  widget.store);
                                                        },
                                                      ));
                                                      if (temp != null) {
                                                        _selectedReplacementId =
                                                            temp;
                                                      }
                                                    }),
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                value: 'Specific item',
                                                subtitle: const AppText(
                                                    text:
                                                        'Select a specific replacement item if your selection is unavailable, your shopper will use Best Match to select a similar replacement.'),
                                                groupValue: _backupInstruction,
                                              ),
                                              RadioListTile(
                                                onChanged: (value) {
                                                  setState(() {
                                                    _backupInstruction = value;
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                value: 'Refund item',
                                                subtitle: const AppText(
                                                  text:
                                                      'Refund item if unavailable',
                                                ),
                                                groupValue: _backupInstruction,
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: AppSizes
                                                    .horizontalPaddingSmall),
                                            child: Column(
                                              children: [
                                                AppButton(text: 'Update'),
                                                Gap(10),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.repeat),
                              title: AppText(
                                text: _noteController.text.trim().isEmpty
                                    ? 'Add note or edit replacement'
                                    : _noteController.text,
                                weight: FontWeight.w600,
                              ),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              subtitle:
                                  AppText(text: _backupInstruction ?? '')),
                          const Gap(10),
                        ])
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Divider(
                  thickness: 3,
                ),
              ),
              if (_product.frequentlyBoughtTogether != null &&
                  _product.frequentlyBoughtTogether!.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Gap(5),
                      const AppText(
                        text: 'Frequently bought together',
                        weight: FontWeight.w600,
                        size: AppSizes.heading6,
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: _product.frequentlyBoughtTogether!.length,
                        itemBuilder: (context, index) {
                          final item =
                              _product.frequentlyBoughtTogether![index];

                          return FutureBuilder<Product>(
                              future: AppFunctions.loadProductReference(
                                  item as DocumentReference),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Skeletonizer(
                                    enabled: true,
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'vgjvjvjvj',
                                              ),
                                              Row(
                                                children: [
                                                  AppText(
                                                    text: 'bhbjnmnm,',
                                                  ),
                                                  AppText(
                                                    text: 'vggjbbjb n',
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Gap(20),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            color: AppColors.neutral100,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return AppText(
                                      text: snapshot.error.toString());
                                }
                                final product = snapshot.data!;
                                return InkWell(
                                  onTap: () {
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                        product: product,
                                        store: widget.store,
                                      ),
                                    ));
                                  },
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: product.name,
                                              weight: FontWeight.w600,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Visibility(
                                                  visible: product.promoPrice !=
                                                      null,
                                                  child: Row(
                                                    children: [
                                                      AppText(
                                                          text:
                                                              '\$${product.promoPrice}',
                                                          color: Colors.green),
                                                      const Gap(5),
                                                    ],
                                                  ),
                                                ),
                                                AppText(
                                                  text:
                                                      '\$${product.initialPrice}',
                                                  decoration:
                                                      product.promoPrice != null
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                ),
                                                if (product.calories != null)
                                                  AppText(
                                                    text:
                                                        ' • ${product.calories!.toInt()} Cal.',
                                                    color: AppColors.neutral500,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                              ],
                                            ),
                                            if (product.description != null)
                                              AppText(
                                                text: product.description!,
                                                maxLines: 2,
                                                color: AppColors.neutral500,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),
                                      const Gap(20),
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Builder(
                                              builder: (context) {
                                                if (product.imageUrls.first
                                                    .startsWith('http')) {
                                                  return CachedNetworkImage(
                                                    imageUrl:
                                                        product.imageUrls.first,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.fill,
                                                  );
                                                } else if (product
                                                    .imageUrls.first
                                                    .startsWith('data:image')) {
                                                  // It's a base64 string
                                                  try {
                                                    String base64String =
                                                        product.imageUrls.first
                                                            .split(',')
                                                            .last;
                                                    Uint8List bytes =
                                                        base64Decode(
                                                            base64String);
                                                    return Image.memory(
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.fill,
                                                        bytes);
                                                  } catch (e) {
                                                    // logger.d(
                                                    //     'Error decoding base64 image: $e');
                                                    return const AppText(
                                                        text:
                                                            'Error loading image');
                                                  }
                                                } else {
                                                  // Handle invalid image source (neither URL nor base64)
                                                  return const AppText(
                                                      text:
                                                          'Invalid image source');
                                                }
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0, top: 8.0),
                                            child: InkWell(
                                              onTap: () {},
                                              child: Ink(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          offset: Offset(2, 2),
                                                        )
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: const Icon(
                                                    Icons.add,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ]),
                  ),
                ),
              if (_product.similarProducts.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Gap(10),
                      const AppText(
                        text: 'Similar items',
                        weight: FontWeight.w600,
                        size: AppSizes.heading6,
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: _product.similarProducts.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<Product>(
                              future: AppFunctions.loadProductReference(_product
                                  .similarProducts[index] as DocumentReference),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final similarProduct = snapshot.data!;
                                  return InkWell(
                                    onTap: () {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) => ProductScreen(
                                          product: similarProduct,
                                          store: widget.store,
                                        ),
                                      ));
                                    },
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: similarProduct.name,
                                                weight: FontWeight.w600,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Visibility(
                                                    visible: similarProduct
                                                            .promoPrice !=
                                                        null,
                                                    child: Row(
                                                      children: [
                                                        AppText(
                                                            text:
                                                                '\$${similarProduct.promoPrice}',
                                                            color:
                                                                Colors.green),
                                                        const Gap(5),
                                                      ],
                                                    ),
                                                  ),
                                                  AppText(
                                                    text:
                                                        '\$${similarProduct.initialPrice}',
                                                    decoration: similarProduct
                                                                .promoPrice !=
                                                            null
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                  ),
                                                  if (similarProduct.calories !=
                                                      null)
                                                    AppText(
                                                      text:
                                                          ' • ${similarProduct.calories!.toInt()} Cal.',
                                                      color:
                                                          AppColors.neutral500,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                ],
                                              ),
                                              if (similarProduct.description !=
                                                  null)
                                                AppText(
                                                  text: similarProduct
                                                      .description!,
                                                  maxLines: 2,
                                                  color: AppColors.neutral500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                            ],
                                          ),
                                        ),
                                        const Gap(20),
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            AppFunctions.displayNetworkImage(
                                                similarProduct.imageUrls.first,
                                                fit: BoxFit.fill,
                                                height: 100,
                                                width: 100),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0, top: 8.0),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Ink(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            offset:
                                                                Offset(2, 2),
                                                          )
                                                        ],
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: const Icon(
                                                      Icons.add,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return AppText(
                                    text: snapshot.error.toString(),
                                    maxLines: null,
                                  );
                                } else {
                                  return ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        color: Colors.blue,
                                        width: 110,
                                        height: 200,
                                      ));
                                }
                              });
                        },
                      ),
                    ]),
                  ),
                ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: SliverToBoxAdapter(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      if (_product.description != null)
                        ExpansionTile(
                          title: const AppText(
                            text: 'Description',
                            weight: FontWeight.w600,
                            size: AppSizes.bodySmall,
                          ),
                          children: [
                            AppText(
                                text: _product.description!,
                                color: AppColors.neutral500)
                          ],
                        ),
                      if (_product.nutritionFacts != null)
                        ExpansionTile(
                          title: const AppText(
                            text: 'Nutrition Facts',
                            weight: FontWeight.w600,
                            size: AppSizes.bodySmall,
                          ),
                          children: _product.nutritionFacts!.entries.map(
                            (entry) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: entry.key,
                                        weight: FontWeight.w600,
                                      ),
                                      AppText(text: entry.value)
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  )
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      if (_product.ingredients != null)
                        ExpansionTile(
                          title: const AppText(
                            text: 'Ingredients',
                            weight: FontWeight.w600,
                            size: AppSizes.bodySmall,
                          ),
                          children: [
                            AppText(
                                text: _product.ingredients!,
                                color: AppColors.neutral500)
                          ],
                        ),
                      if (_product.directions != null)
                        ExpansionTile(
                          title: const AppText(
                            text: 'Directions',
                            weight: FontWeight.w600,
                            size: AppSizes.bodySmall,
                          ),
                          children: [
                            AppText(
                                text: _product.directions!,
                                color: AppColors.neutral500)
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (widget.store.type.contains('Grocery'))
                SliverToBoxAdapter(
                    child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: const [
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: AppText(
                            size: AppSizes.bodySmallest,
                            color: AppColors.neutral500,
                            text:
                                'The information shown here may not be current, complete or accurate. Always check the item\'s packaging for product information and warnings.\n\nThe prices in this catalog are set by the merchant and may be higher than in store. Some in-store promotions may not apply.'),
                      ),
                    ])),
              if (widget.store.type.contains('Fast Food') ||
                  widget.store.type.contains('Restaurant'))
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: RichText(
                          text: TextSpan(
                              text:
                                  "WARNING: Certain foods and beverages sold or served here can expose you to chemicals including acrylamide in many fried or baked foods, and mercury in fish, which are known to the State of California to cause cancer and birth defects or other reproductive harm. For more information go to ",
                              style: const TextStyle(
                                fontSize: AppSizes.bodySmallest,
                                color: AppColors.neutral500,
                              ),
                              children: [
                                TextSpan(
                                  text: 'www.P65Warnings.ca.gov/restaurant',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        //TODO: fix webviewscreens not loading. It glitches like the map
                                        builder: (context) => WebViewScreen(
                                          controller: _webViewcontroller,
                                          link: Weblinks.p65Warnings,
                                        ),
                                      ));
                                    },
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )),
      persistentFooterButtons: [
        if (_productInbox?.quantity != _quantity)
          AppButton(
            isLoading: _isLoading,
            text:
                'Add ($_quantity) to cart • \$${currentTotal.toStringAsFixed(2)}',
            callback: () async {
              if (_requiredOptions.length != _product.requiredOptions.length) {
                showInfoToast('Select an option',
                    context: navigatorKey.currentContext);
              } else {
                setState(() {
                  _isLoading = true;
                });

                List<HiveOption> requiredOptions = [];
                for (var i = 0; i < _requiredOptions.values.length; i++) {
                  var options = _requiredOptions.values.elementAt(i);
                  for (var j = 0; i < options.length; i++) {
                    var option = options[j];
                    option.quantity = _optionQuantities[i + j];
                    requiredOptions.add(option);
                  }
                }

                List<HiveOption> optionalOptions = [];
                for (var i = _product.requiredOptions.length;
                    i <
                        _product.requiredOptions.length +
                            _optionalOptions.values.length;
                    i++) {
                  var options = _optionalOptions.values.elementAt(i);
                  for (var j = 0; i < options.length; i++) {
                    var option = options[j];
                    option.quantity = _optionQuantities[i + j];
                    optionalOptions.add(option);
                  }
                }
                if (_productInbox == null) {
                  final newProduct = HiveCartProduct(
                    id: _product.id,
                    quantity: _quantity,
                    backupInstruction: _backupInstruction,
                    note: _noteController.text,
                    requiredOptions: requiredOptions,
                    optionalOptions: optionalOptions,
                    productReplacementId: _selectedReplacementId,
                  );
                  await _productsBox.add(newProduct);
                  if (_cartItemInBox == null) {
                    var temp = HiveCartItem(
                      deliveryDate: ref.read(deliveryScheduleProvider),
                      placeDescription: ref.read(selectedLocationDescription),
                      products: HiveList(_productsBox),
                      initialPricesTotal: _product.initialPrice * _quantity,
                      subtotal: _product.promoPrice ??
                          _product.initialPrice * _quantity,
                      storeId: widget.store.id,
                    );
                    temp.products.add(_productsBox.values.last);
                    await Hive.box<HiveCartItem>(AppBoxes.carts).add(temp);
                    _cartItemInBox = _cart.values.firstWhere(
                      (element) => element.storeId == widget.store.id,
                    );
                  } else {
                    _cartItemInBox!.products.add(_productsBox.values.last);
                    _cartItemInBox!.subtotal = initialSubTotal +
                        (_product.promoPrice ??
                            _product.initialPrice * _quantity);
                    _cartItemInBox!.initialPricesTotal =
                        initialInitialPricesTotal +
                            _product.initialPrice * _quantity;

                    await _cartItemInBox!.save();
                  }
                  _productInbox = _productsBox.values.last;
                } else {
                  _productInbox!.quantity = _quantity;
                  await _productInbox!.save();
                  _cartItemInBox!.subtotal = initialSubTotal +
                      (_product.promoPrice ??
                          _product.initialPrice * _quantity);
                  _cartItemInBox!.initialPricesTotal =
                      initialInitialPricesTotal +
                          _product.initialPrice * _quantity;
                  await _cartItemInBox!.save();
                }

                setState(() {
                  _isLoading = false;
                });
              }
            },
          )
        else
          AppButton(
              callback: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return CartSheet(
                      store: widget.store,
                      cartItem: _cartItemInBox!,
                    );
                  },
                );
              },
              text: 'View cart ($_quantity)')
      ],
    );
  }
}
