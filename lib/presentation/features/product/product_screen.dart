import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/octicon.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';
import 'package:uber_eats_clone/presentation/features/store/store_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../constants/app_sizes.dart';
import '../../constants/weblinks.dart';
import '../../core/app_colors.dart';
import '../home/home_screen.dart';
import '../webview/webview_screen.dart';
import 'back_up_option_screen.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final Store store;
  final Product product;
  const ProductScreen({required this.product, required this.store, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  late final Product _product;

  final _selectedOptions = <String>[];

  final _webViewcontroller = WebViewControllerPlus();
  String _note = '';

  int _activeIndex = 0;
  int _quantity = 1;

  bool _footerButtonTapped = false;

  String _backupInstruction = 'Best match';

  final _noteController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _product = widget.product;
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
                    title: AppText(text: _product.name),
                    background: SafeArea(
                      child: Column(
                        children: [
                          InkWell(
                            // onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ProductImageScreen(),)),
                            child: Ink(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CarouselSlider.builder(
                                itemCount: _product.imageUrls.length,
                                itemBuilder: (context, index, realIndex) {
                                  return CachedNetworkImage(
                                    // width: double.infinity,
                                    imageUrl: _product.imageUrls[index],
                                    height: 80,
                                    fit: BoxFit.fitHeight,
                                  );
                                },
                                options: CarouselOptions(
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _activeIndex = index;
                                      });
                                    },
                                    aspectRatio: 1,
                                    height: 200,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 0.85),
                              ),
                            )),
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
                      child: Row(
                        children: [
                          Visibility(
                            visible: _product.promoPrice != null,
                            child: Row(
                              children: [
                                AppText(
                                    text: '\$${_product.initialPrice}',
                                    size: AppSizes.body,
                                    color: Colors.green),
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
                          ),
                        ],
                      ),
                    ),
                    if (_product.options != null)
                      const Column(
                        children: [
                          Divider(
                            thickness: 4,
                          ),
                          ListTile(
                            title: AppText(
                              text: 'Select Option',
                              size: AppSizes.body,
                              weight: FontWeight.w600,
                            ),
                            trailing: AppTextBadge(
                              text: 'Required',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (_product.options != null)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverList.separated(
                    itemCount: _product.options!.length,
                    itemBuilder: (context, index) {
                      final option = _product.options![index];
                      return option.isExclusive
                          ? AppRadioListTile(
                              subtitle: option.price?.toString(),
                              groupValue: 'exclusive',
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: option.name)
                          : AppCheckboxListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: option.name,
                              onChanged: (value) {},
                              selectedOptions: _selectedOptions);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
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
                                    if (_quantity != 0) {
                                      setState(() {
                                        _quantity -= 1;
                                        if (_footerButtonTapped == true) {
                                          _footerButtonTapped = false;
                                        }
                                      });
                                    }
                                  },
                                  child: Ink(
                                      child: const Iconify(Octicon.dash_24))),
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
                                              text: 'Add replacement or note',
                                              size: AppSizes.heading6,
                                            ),
                                            leading: GestureDetector(
                                                onTap: () => navigatorKey
                                                    .currentState!
                                                    .pop(),
                                                child: const Icon(Icons.clear)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: AppSizes
                                                    .horizontalPaddingSmall),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const AppText(
                                                  text: 'Add note',
                                                  size: AppSizes.body,
                                                ),
                                                const Gap(10),
                                                AppTextFormField(
                                                  controller: _noteController,
                                                  hintText:
                                                      'e.g. Green bananas please',
                                                ),
                                                const Gap(10),
                                                const AppText(
                                                  text: 'Backup instructions',
                                                  size: AppSizes.body,
                                                ),
                                              ],
                                            ),
                                          ),
                                          AppRadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: 'Best match',
                                            subtitle:
                                                'Your shopper will select an item similar price and quality',
                                            groupValue: _backupInstruction,
                                          ),
                                          AppRadioListTile(
                                            secondary: AppButton2(
                                                text: 'Select',
                                                callback: () {
                                                  navigatorKey.currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) {
                                                      return BackUpOptionScreen(
                                                          product:
                                                              widget.product,
                                                          store: widget.store);
                                                    },
                                                  ));
                                                }),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: 'Specific item',
                                            subtitle:
                                                'Select a specific replacement item if your selection is unavailable, your shopper will use Best Match to select a similar replacement.',
                                            groupValue: _backupInstruction,
                                          ),
                                          AppRadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            value: 'Refund item',
                                            subtitle:
                                                'Refund item if unavailable',
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
                          subtitle: AppText(text: _backupInstruction))
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    Gap(10),
                    Divider(
                      thickness: 4,
                    ),
                  ],
                ),
              ),
              if (_product.similarProducts != null &&
                  _product.similarProducts!.isNotEmpty)
                const SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10),
                        AppText(
                          text: 'Similar items',
                          weight: FontWeight.w600,
                          size: AppSizes.heading6,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_product.similarProducts != null &&
                  _product.similarProducts!.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: _product.similarProducts!.length,
                    itemBuilder: (context, index) {
                      final similarProduct = _product.similarProducts![index];
                      return InkWell(
                        onTap: () {
                          navigatorKey.currentState!.push(MaterialPageRoute(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        visible:
                                            similarProduct.promoPrice != null,
                                        child: Row(
                                          children: [
                                            AppText(
                                                text:
                                                    '\$${similarProduct.promoPrice}',
                                                color: Colors.green),
                                            const Gap(5),
                                          ],
                                        ),
                                      ),
                                      AppText(
                                        text:
                                            '\$${similarProduct.initialPrice}',
                                        decoration:
                                            similarProduct.promoPrice != null
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                      ),
                                      if (similarProduct.calories != null)
                                        AppText(
                                          text:
                                              ' • ${similarProduct.calories!} Cal.',
                                          maxLines: 2,
                                          color: AppColors.neutral500,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                    ],
                                  ),
                                  if (similarProduct.description != null)
                                    AppText(
                                      text: similarProduct.description!,
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
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: similarProduct.imageUrls.first,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, top: 8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Ink(
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(2, 2),
                                              )
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50)),
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
                    },
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
                              size: AppSizes.body,
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
                              size: AppSizes.body,
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
                              size: AppSizes.body,
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
                              size: AppSizes.body,
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
                            'The prices in this catalog are set by the merchant and may be higher than in store. Some in-store promotions may not apply.'),
                  ),
                ])),
              if (widget.store.type.contains('Fast Food') ||
                  widget.store.type.contains('Restaurant'))
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 4,
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
              setState(() {
                _footerButtonTapped = true;
              });
            },
            child: Ink(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                        color: Colors.white,
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
