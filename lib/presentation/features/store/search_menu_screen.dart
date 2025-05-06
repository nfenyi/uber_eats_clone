import 'dart:async';
import 'dart:convert' show base64Decode;
import 'dart:typed_data' show Uint8List;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../product/product_screen.dart';

class SearchMenuScreen extends ConsumerStatefulWidget {
  final Store store;
  const SearchMenuScreen(this.store, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchMenuScreenState();
}

class _SearchMenuScreenState extends ConsumerState<SearchMenuScreen> {
  final _controller = TextEditingController();
  List<ProductCategory> _searchResults = [];
  Timer? _debounce;

  late String _query;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          AppTextFormField(
            radius: 0,
            autofocus: true,
            onChanged: (value) {
              if (_debounce?.isActive ?? false) {
                _debounce?.cancel();
              }
              _debounce = Timer(const Duration(seconds: 1), () async {
                setState(() {
                  if (value != null) {
                    _query = value;
                    if (widget.store.productCategories == null) {
                      _searchResults = [];
                    } else {
                      _searchResults = widget.store.productCategories!
                          .where(
                            (category) =>
                                category.name != 'Most Popular' &&
                                category.name != 'Featured items' &&
                                category.productsAndQuantities.any(
                                  (productAndQuantity) => productAndQuantity
                                      .name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                                ),
                          )
                          .toList();
                    }
                  }
                });
              });
            },
            controller: _controller,
            hintText: 'Search menu',
            suffixIcon: InkWell(
                onTap: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      _controller.clear();
                    });
                  } else {
                    navigatorKey.currentState!.pop();
                  }
                },
                child: Ink(child: const Icon(Icons.close))),
            prefixIcon: const Icon(Icons.search),
          ),
          const Gap(20),
          Expanded(
            child: _controller.text.isEmpty
                ? const SizedBox.shrink()
                : _searchResults.isEmpty
                    ? NoMatch(widget: widget)
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: CustomScrollView(
                          slivers: [
                            SliverList.separated(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: result.name,
                                      size: AppSizes.heading5,
                                      weight: FontWeight.bold,
                                    ),
                                    const Gap(5),
                                    Builder(builder: (context) {
                                      List<DocumentReference>
                                          matchingProductsRefs = [];
                                      for (var productAndQuantity
                                          in result.productsAndQuantities) {
                                        if (productAndQuantity.name
                                            .toLowerCase()
                                            .contains(_query.toLowerCase())) {
                                          matchingProductsRefs.add(
                                              productAndQuantity.product
                                                  as DocumentReference);
                                        }
                                      }
                                      return ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final matchingProductsRef =
                                              matchingProductsRefs[index];
                                          return FutureBuilder<Product>(
                                              future: AppFunctions
                                                  .loadProductReference(
                                                      matchingProductsRef),
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
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text:
                                                                    'nklanslldslmasdlms',
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  AppText(
                                                                    text:
                                                                        '20.50',
                                                                  ),
                                                                ],
                                                              ),
                                                              AppText(
                                                                text:
                                                                    'nanlasndlfmsalmflamflmalfmlewmalfmds,fmasd, mkfadm,fam,maf,mafm,famlmlasmlamlaf;lm',
                                                                maxLines: 2,
                                                                color: AppColors
                                                                    .neutral500,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Gap(20),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Container(
                                                            width: 100,
                                                            height: 100,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return AppText(
                                                      text: snapshot.error
                                                          .toString());
                                                }

                                                final product = snapshot.data!;
                                                return InkWell(
                                                  onTap: () {
                                                    navigatorKey.currentState!
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductScreen(
                                                        product: product,
                                                        store: widget.store,
                                                      ),
                                                    ));
                                                  },
                                                  child: Ink(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text: product
                                                                    .name,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                                size: AppSizes
                                                                    .bodySmall,
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Visibility(
                                                                    visible:
                                                                        product.promoPrice !=
                                                                            null,
                                                                    child: AppText(
                                                                        text:
                                                                            '\$${product.promoPrice} ',
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                  AppText(
                                                                    text:
                                                                        '\$${product.initialPrice}',
                                                                    decoration: product.promoPrice !=
                                                                            null
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : TextDecoration
                                                                            .none,
                                                                  ),
                                                                  if (product
                                                                          .calories !=
                                                                      null)
                                                                    AppText(
                                                                      text:
                                                                          ' • ${product.calories!.toInt()} Cal.',
                                                                      maxLines:
                                                                          2,
                                                                      color: AppColors
                                                                          .neutral500,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    )
                                                                ],
                                                              ),
                                                              if (product.description !=
                                                                      null ||
                                                                  product.ingredients !=
                                                                      null)
                                                                AppText(
                                                                  text: product
                                                                          .description ??
                                                                      product
                                                                          .ingredients!,
                                                                  maxLines: 2,
                                                                  color: AppColors
                                                                      .neutral500,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Gap(20),
                                                        Stack(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    if (product
                                                                        .imageUrls
                                                                        .first
                                                                        .startsWith(
                                                                            'http')) {
                                                                      return CachedNetworkImage(
                                                                        imageUrl: product
                                                                            .imageUrls
                                                                            .first,
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            100,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      );
                                                                    } else if (product
                                                                        .imageUrls
                                                                        .first
                                                                        .startsWith(
                                                                            'data:image')) {
                                                                      // It's a base64 string
                                                                      try {
                                                                        String base64String = product
                                                                            .imageUrls
                                                                            .first
                                                                            .split(',')
                                                                            .last;
                                                                        Uint8List
                                                                            bytes =
                                                                            base64Decode(base64String);
                                                                        return Image.memory(
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                100,
                                                                            fit:
                                                                                BoxFit.fill,
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
                                                                )),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          8.0,
                                                                      top: 8.0),
                                                              child: InkWell(
                                                                onTap: () {},
                                                                child: Ink(
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                    decoration: BoxDecoration(
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            offset:
                                                                                Offset(2, 2),
                                                                          )
                                                                        ],
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(50)),
                                                                    child:
                                                                        //Implement add button
                                                                        const Icon(
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
                                                  ),
                                                );
                                              });
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: matchingProductsRefs.length,
                                      );
                                    })
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                            )
                          ],
                        ),
                      ),
          ),
        ],
      )),
    );
  }
}

class NoMatch extends StatelessWidget {
  const NoMatch({
    super.key,
    required this.widget,
  });

  final SearchMenuScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: Column(
        children: [
          const Gap(30),
          Image.asset(
            AssetNames.didntFindMatch,
            width: 200,
          ),
          const AppText(
            text: "We didn't find a match",
            size: AppSizes.bodySmall,
            weight: FontWeight.w600,
          ),
          const AppText(
            text: "Try searching for something else",
            color: AppColors.neutral500,
          ),
          const Gap(10),
          AppButton(
            text: 'Back to ${widget.store.name}',
            callback: () => navigatorKey.currentState!.pop(),
            borderRadius: 50,
          ),
        ],
      ),
    );
  }
}
