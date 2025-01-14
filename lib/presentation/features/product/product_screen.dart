import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/octicon.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../constants/app_sizes.dart';
import '../../constants/weblinks.dart';
import '../../core/app_colors.dart';
import '../home/home_screen.dart';
import '../webview/webview_screen.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductScreen(this.product, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  late final Product _product;

  final _selectedOptions = <String>[];

  final _webViewcontroller = WebViewControllerPlus();

  bool _footerButtonTapped = false;
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
                    background: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: InkWell(
                        // onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ProductImageScreen(),)),
                        child: Ink(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl: _product.imageUrl)),
                        ),
                      ),
                    ),
                  ),
                  expandedHeight: 200,
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
                    const Divider(
                      thickness: 4,
                    ),
                    if (_product.options != null)
                      const ListTile(
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
                  child: SizedBox(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {},
                              child:
                                  Ink(child: const Iconify(Octicon.dash_24))),
                          const AppText(
                            text: '1',
                          ),
                          InkWell(
                              onTap: () {},
                              child: Ink(child: const Icon(Icons.add)))
                        ],
                      ),
                    ),
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
              if (_product.frequentlyBoughtTogether != null &&
                  _product.frequentlyBoughtTogether!.isNotEmpty)
                const SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10),
                        AppText(
                          text: 'Frequently bought together',
                          weight: FontWeight.w600,
                          size: AppSizes.heading6,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_product.frequentlyBoughtTogether != null &&
                  _product.frequentlyBoughtTogether!.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: _product.frequentlyBoughtTogether!.length,
                    itemBuilder: (context, index) {
                      final frequentlyBoughtTogether =
                          _product.frequentlyBoughtTogether![index];
                      return InkWell(
                        onTap: () {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) =>
                                ProductScreen(frequentlyBoughtTogether),
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
                                    text: frequentlyBoughtTogether.name,
                                    weight: FontWeight.w600,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Visibility(
                                        visible: frequentlyBoughtTogether
                                                .promoPrice !=
                                            null,
                                        child: Row(
                                          children: [
                                            AppText(
                                                text:
                                                    '\$${frequentlyBoughtTogether.initialPrice}',
                                                color: Colors.green),
                                            const Gap(5),
                                          ],
                                        ),
                                      ),
                                      AppText(
                                        text:
                                            '\$${frequentlyBoughtTogether.initialPrice}',
                                        decoration: frequentlyBoughtTogether
                                                    .promoPrice !=
                                                null
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                      if (frequentlyBoughtTogether.calories !=
                                          null)
                                        AppText(
                                          text:
                                              ' • ${frequentlyBoughtTogether.calories!} Cal.',
                                          maxLines: 2,
                                          color: AppColors.neutral500,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                    ],
                                  ),
                                  if (frequentlyBoughtTogether.description !=
                                      null)
                                    AppText(
                                      text:
                                          frequentlyBoughtTogether.description!,
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
                                    imageUrl: frequentlyBoughtTogether.imageUrl,
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
              if (_product.frequentlyBoughtTogether != null &&
                  _product.frequentlyBoughtTogether!.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      thickness: 4,
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                            text:
                                "WARNING: Certain foods and beverages sold or served here canexpose you to chemicals including acrylamide in many fried orbaked foods, and mercury in fish, which are known to the State ofCalifornia to cause cancer and birth defects or other reproductiveharm. For more information go to ",
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
                    ],
                  ),
                ),
              )
            ],
          )),
      persistentFooterButtons: [
        if (!_footerButtonTapped)
          AppButton(
              callback: () {
                setState(() {
                  _footerButtonTapped = true;
                });
              },
              text:
                  'Add 1 to cart • \$${_product.promoPrice ?? _product.initialPrice}')
        else
          AppButton(callback: () {}, text: 'View cart (number)')
      ],
    );
  }
}
