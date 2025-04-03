import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/octicon.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/product/back_up_option_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../app_functions.dart';
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

  late final List<bool?> _optionalOptions;

  final _webViewcontroller = WebViewControllerPlus();
  final String _note = '';

  int _activeIndex = 0;
  int _quantity = 1;

  bool _footerButtonTapped = false;
  late final List<int> _optionQuantities;

  String? _backupInstruction = 'Best match';

  final _noteController = TextEditingController();

  String? _selectedExclusiveOption;

  String? _selectedSubOption;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    if (_product.options != null) {
      //for listtilecheckboxes
      _optionalOptions = List.generate(
          _product.options!.length, (index) => false,
          growable: false);

      if (_product.options!.any(
        (element) => element.canBeMultiple,
      )) {
        //for listtiles with quantity incrementor and decrementor
        _optionQuantities = List.generate(
            _product.options!.length, (index) => 0,
            growable: false);
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    // titlePadding: EdgeInsets.only(left: 50),
                    expandedTitleScale: 1.1,
                    title: AppText(
                      text: _product.name,
                      weight: FontWeight.bold,
                      size: AppSizes.heading6,
                    ),
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
                          const Gap(10),
                          if (_product.imageUrls.length > 1)
                            AnimatedSmoothIndicator(
                              activeIndex: _activeIndex,
                              count: _product.imageUrls.length,
                              effect: const WormEffect(
                                  activeDotColor: Colors.black,
                                  dotHeight: 5,
                                  dotWidth: 5,
                                  dotColor: AppColors.neutral100),
                            )
                        ],
                      ),
                    ),
                  ),
                  expandedHeight: 250,
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
                                        text: '\$${_product.initialPrice}',
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
                    if (_product.options != null)
                      Column(
                        children: [
                          const Divider(
                            thickness: 3,
                          ),
                          (_product.selectOptionRequired)
                              ? ListTile(
                                  title: const AppText(
                                    text: 'Select Option',
                                    size: AppSizes.body,
                                    weight: FontWeight.w600,
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: _selectedExclusiveOption == null
                                          ? AppColors.neutral100
                                          : const Color.fromARGB(
                                              255, 206, 232, 221),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_selectedExclusiveOption != null)
                                          const Icon(
                                            Icons.check,
                                            color: AppColors.primary2,
                                          ),
                                        const Gap(3),
                                        AppText(
                                          text: 'Required',
                                          color:
                                              _selectedExclusiveOption == null
                                                  ? null
                                                  : AppColors.primary2,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : ListTile(
                                  title: AppText(
                                    text: '${_product.name} Additions',
                                    size: AppSizes.bodySmall,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                        ],
                      ),
                  ],
                ),
              ),
              if (_product.options != null)
                SliverList.separated(
                  itemCount: _product.options!.length,
                  itemBuilder: (context, index) {
                    final option = _product.options![index];
                    return option.isExclusive == true
                        ? Column(
                            children: [
                              RadioListTile.adaptive(
                                title: AppText(text: option.name),
                                value: option.name,
                                groupValue: _selectedExclusiveOption,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedExclusiveOption = value;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                subtitle:
                                    AppText(text: option.price.toString()),
                              ),
                              if (_selectedExclusiveOption == option.name &&
                                  option.subOptions != null)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.neutral100,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      if (_selectedSubOption != null)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: '${option.name} Additions',
                                              weight: FontWeight.bold,
                                              size: AppSizes.body,
                                            ),
                                            AppText(
                                              text: _selectedSubOption!,
                                              color: AppColors.neutral500,
                                            )
                                          ],
                                        ),
                                      ListTile(
                                        onTap: () => navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              SubOptionSelectionScreen(
                                            productPrice: _product.promoPrice ??
                                                _product.initialPrice,
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
                          )
                        : option.canBeMultiple
                            ? ListTile(
                                trailing: _optionQuantities[index] == 0
                                    ? TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            backgroundColor:
                                                AppColors.neutral100,
                                            shape: const CircleBorder()),
                                        onPressed: () {
                                          setState(() {
                                            _optionQuantities[index] =
                                                _optionQuantities[index] + 1;
                                          });
                                        },
                                        child: const AppText(
                                          text: '+',
                                          size: AppSizes.body,
                                        ))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    backgroundColor:
                                                        AppColors.neutral100,
                                                    shape:
                                                        const CircleBorder()),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_optionQuantities[
                                                            index] !=
                                                        0) {
                                                      _optionQuantities[index] =
                                                          _optionQuantities[
                                                                  index] -
                                                              1;
                                                    }
                                                  });
                                                },
                                                child: const AppText(
                                                    text: '-',
                                                    size: AppSizes.body)),
                                            AppText(
                                                text: _optionQuantities[index]
                                                    .toString()),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    backgroundColor:
                                                        AppColors.neutral100,
                                                    shape:
                                                        const CircleBorder()),
                                                onPressed:
                                                    option.canBeMultipleLimit ==
                                                                null ||
                                                            _optionQuantities[
                                                                    index] <
                                                                option
                                                                    .canBeMultipleLimit!
                                                        ? () {
                                                            setState(() {
                                                              if (_optionQuantities[
                                                                      index] !=
                                                                  0) {
                                                                _optionQuantities[
                                                                        index] =
                                                                    _optionQuantities[
                                                                            index] +
                                                                        1;
                                                              }
                                                            });
                                                          }
                                                        : null,
                                                child: const AppText(
                                                    text: '+',
                                                    size: AppSizes.body)),
                                          ]),
                                title: AppText(
                                  text: option.name,
                                ),
                                subtitle: option.price != null ||
                                        option.calories != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (option.price != null)
                                            AppText(
                                              text:
                                                  '+  ${_optionQuantities[index] == 0 ? '\$${option.price}' : '\$${option.price! * _optionQuantities[index]} (\$${option.price!.toStringAsFixed(2)} ea)'} ',
                                              color: AppColors.neutral500,
                                            ),
                                          if (option.calories != null)
                                            AppText(
                                              text:
                                                  '${option.calories!.toInt()} Cal.',
                                              color: AppColors.neutral500,
                                            ),
                                        ],
                                      )
                                    : null,
                              )
                            : Builder(builder: (context) {
                                return CheckboxListTile.adaptive(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: AppText(
                                    text: option.name,
                                  ),
                                  subtitle: option.price != null ||
                                          option.calories != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (option.price != null)
                                              AppText(
                                                text: '+ \$${option.price}',
                                                color: AppColors.neutral500,
                                              ),
                                            if (option.calories != null)
                                              AppText(
                                                text:
                                                    '${option.calories!.toInt()} Cal.',
                                                color: AppColors.neutral500,
                                              ),
                                          ],
                                        )
                                      : null,
                                  value: _optionalOptions[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _optionalOptions[index] = value;
                                    });
                                  },
                                );
                              });
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
                                  onTap: () {
                                    if (_quantity != 1) {
                                      setState(() {
                                        _quantity -= 1;
                                        if (_footerButtonTapped == true) {
                                          _footerButtonTapped = false;
                                        }
                                      });
                                    }
                                  },
                                  child: Ink(
                                      child: Iconify(
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
                                      if (_footerButtonTapped == true) {
                                        _footerButtonTapped = false;
                                      }
                                    });
                                  },
                                  child: Ink(child: const Icon(Icons.add)))
                            ],
                          ),
                        ),
                      ),
                      // Add note
                      if (widget.store.type.toLowerCase().contains('grocery'))
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
                                                    callback: () {
                                                      navigatorKey.currentState!
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
                                text: _note.isEmpty
                                    ? 'Add note or edit replacement'
                                    : _note,
                                weight: FontWeight.w600,
                              ),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              subtitle:
                                  AppText(text: _backupInstruction.toString())),
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
              if (_product.similarProducts != null &&
                  _product.similarProducts!.isNotEmpty)
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
                        itemCount: _product.similarProducts!.length,
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
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Builder(
                                                builder: (context) {
                                                  return AppFunctions
                                                      .displayNetworkImage(
                                                          similarProduct
                                                              .imageUrls.first,
                                                          fit: BoxFit.fill,
                                                          height: 100,
                                                          width: 100);
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
              SliverPadding(
                  sliver: SliverToBoxAdapter(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        if (widget.product.description != null)
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: const AppText(
                              text: 'Description',
                              weight: FontWeight.w600,
                              size: AppSizes.bodySmall,
                            ),
                            children: [
                              AppText(
                                  text: widget.product.description!,
                                  color: AppColors.neutral500)
                            ],
                          ),
                        if (widget.product.nutritionFacts != null)
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: const AppText(
                              text: 'Nutrition Facts',
                              weight: FontWeight.w600,
                              size: AppSizes.bodySmall,
                            ),
                            children:
                                widget.product.nutritionFacts!.entries.map(
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
                        if (widget.product.ingredients != null)
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: const AppText(
                              text: 'Ingredients',
                              weight: FontWeight.w600,
                              size: AppSizes.bodySmall,
                            ),
                            children: [
                              AppText(
                                  text: widget.product.ingredients!,
                                  color: AppColors.neutral500)
                            ],
                          ),
                        if (widget.product.directions != null)
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: const AppText(
                              text: 'Directions',
                              weight: FontWeight.w600,
                              size: AppSizes.bodySmall,
                            ),
                            children: [
                              AppText(
                                  text: widget.product.directions!,
                                  color: AppColors.neutral500)
                            ],
                          ),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall)),
              if (widget.store.type.contains('Grocery'))
                SliverToBoxAdapter(
                    child: ListView(shrinkWrap: true, children: const [
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
        if (!_footerButtonTapped)
          InkWell(
            onTap: () {
              if (_product.selectOptionRequired == true &&
                  _selectedExclusiveOption == null) {
                showInfoToast('Select an option',
                    context: navigatorKey.currentContext);
              } else {
                setState(() {
                  _footerButtonTapped = true;
                });
              }
            },
            child: Ink(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                    color: _product.selectOptionRequired == false
                        ? Colors.black
                        : _product.selectOptionRequired == true &&
                                _selectedExclusiveOption != null
                            ? Colors.black
                            : AppColors.neutral200,
                    borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                        color: _product.selectOptionRequired == false
                            ? Colors.white
                            : _product.selectOptionRequired == true &&
                                    _selectedExclusiveOption != null
                                ? Colors.white
                                : Colors.black,
                        text:
                            'Add $_quantity to cart • \$${((_product.promoPrice ?? _product.initialPrice) * _quantity).toStringAsFixed(2)}'),
                    Visibility(
                        visible: _product.promoPrice != null,
                        child: AppText(
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                            text: (_product.initialPrice * _quantity)
                                .toStringAsFixed(2)))
                  ],
                ),
              ),
            ),
          )
        // AppButton(
        //     callback: () {
        //       setState(() {
        //         _footerButtonTapped = true;
        //       });
        //     },
        //     text:
        //         'Add $_quantity to cart • \$${(_product.promoPrice ?? _product.initialPrice) * _quantity} ${_product.promoPrice != null ? _product.initialPrice * _quantity : ''}')
        else
          AppButton(callback: () {}, text: 'View cart ($_quantity)')
      ],
    );
  }
}
