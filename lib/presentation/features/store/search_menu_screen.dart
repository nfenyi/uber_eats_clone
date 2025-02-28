import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          AppTextFormField(
            autofocus: true,
            onChanged: (query) {
              setState(() {
                // if (query != null) {
                //   _searchResults = widget.store.productCategories
                //       .where(
                //         (category) => category.products.any(
                //           (product) => product.name
                //               .toLowerCase()
                //               .contains(query.toLowerCase()),
                //         ),
                //       )
                //       .toList();
                // }
              });
            },
            controller: _controller,
            hintText: 'Search menu',
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _controller.clear();
                  });
                },
                child: Ink(child: const Icon(Icons.close))),
            prefixIcon: const Icon(Icons.search),
          ),
          const Gap(20),
          _controller.text.isEmpty
              ? const SizedBox()
              : _searchResults.isEmpty
                  ? NoMatch(widget: widget)
                  : Expanded(
                      child: Padding(
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
                                      size: AppSizes.heading6,
                                      weight: FontWeight.w600,
                                    ),
                                    // ListView.separated(
                                    //   padding: EdgeInsets.zero,
                                    //   shrinkWrap: true,
                                    //   itemBuilder: (context, index) {
                                    //     final product = result.products[index];
                                    //     return InkWell(
                                    //       onTap: () {
                                    //         navigatorKey.currentState!
                                    //             .push(MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               ProductScreen(
                                    //             product: product,
                                    //             store: widget.store,
                                    //           ),
                                    //         ));
                                    //       },
                                    //       child: Row(
                                    //         // crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           Expanded(
                                    //             child: Column(
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
                                    //               children: [
                                    //                 AppText(
                                    //                   text: product.name,
                                    //                   weight: FontWeight.w600,
                                    //                   maxLines: 3,
                                    //                   overflow:
                                    //                       TextOverflow.ellipsis,
                                    //                 ),
                                    //                 Row(
                                    //                   children: [
                                    //                     Visibility(
                                    //                       visible: product
                                    //                               .promoPrice !=
                                    //                           null,
                                    //                       child: Row(
                                    //                         children: [
                                    //                           AppText(
                                    //                               text:
                                    //                                   '\$${product.initialPrice}',
                                    //                               color: Colors
                                    //                                   .green),
                                    //                           const Gap(5),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                     AppText(
                                    //                       text:
                                    //                           '\$${product.initialPrice}',
                                    //                       decoration: product
                                    //                                   .promoPrice !=
                                    //                               null
                                    //                           ? TextDecoration
                                    //                               .lineThrough
                                    //                           : TextDecoration
                                    //                               .none,
                                    //                     ),
                                    //                     if (product.calories !=
                                    //                         null)
                                    //                       AppText(
                                    //                         text:
                                    //                             ' • ${product.calories!} Cal.',
                                    //                         maxLines: 2,
                                    //                         color: AppColors
                                    //                             .neutral500,
                                    //                         overflow:
                                    //                             TextOverflow
                                    //                                 .ellipsis,
                                    //                       )
                                    //                   ],
                                    //                 ),
                                    //                 if (product.description !=
                                    //                     null)
                                    //                   AppText(
                                    //                     text: product
                                    //                         .description!,
                                    //                     maxLines: 2,
                                    //                     color: AppColors
                                    //                         .neutral500,
                                    //                     overflow: TextOverflow
                                    //                         .ellipsis,
                                    //                   ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //           const Gap(20),
                                    //           Stack(
                                    //             alignment:
                                    //                 Alignment.bottomRight,
                                    //             children: [
                                    //               ClipRRect(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                         12),
                                    //                 child: CachedNetworkImage(
                                    //                   imageUrl: product
                                    //                       .imageUrls.first,
                                    //                   width: 100,
                                    //                   height: 100,
                                    //                   fit: BoxFit.fill,
                                    //                 ),
                                    //               ),
                                    //               Padding(
                                    //                 padding:
                                    //                     const EdgeInsets.only(
                                    //                         right: 8.0,
                                    //                         top: 8.0),
                                    //                 child: InkWell(
                                    //                   onTap: () {},
                                    //                   child: Ink(
                                    //                     child: Container(
                                    //                       padding:
                                    //                           const EdgeInsets
                                    //                               .all(5),
                                    //                       decoration: BoxDecoration(
                                    //                           boxShadow: const [
                                    //                             BoxShadow(
                                    //                               color: Colors
                                    //                                   .black12,
                                    //                               offset:
                                    //                                   Offset(
                                    //                                       2, 2),
                                    //                             )
                                    //                           ],
                                    //                           color:
                                    //                               Colors.white,
                                    //                           borderRadius:
                                    //                               BorderRadius
                                    //                                   .circular(
                                    //                                       50)),
                                    //                       child: const Icon(
                                    //                         Icons.add,
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                 ),
                                    //               )
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     );
                                    //   },
                                    //   separatorBuilder: (context, index) =>
                                    //       const Divider(),
                                    //   itemCount: result.products.length,
                                    // )
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
      width: 300,
      child: Column(
        children: [
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
