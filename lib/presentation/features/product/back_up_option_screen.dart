import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../main.dart';
import '../../constants/app_sizes.dart';
import '../home/home_screen.dart';

class BackUpOptionScreen extends StatefulWidget {
  final Product product;
  final Store store;
  const BackUpOptionScreen(
      {super.key, required this.product, required this.store});

  @override
  State<BackUpOptionScreen> createState() => _BackUpOptionScreenState();
}

class _BackUpOptionScreenState extends State<BackUpOptionScreen> {
  final _searchController = TextEditingController();
  late final String _categoryName;
  late final List<Product> _products;
  late List<Product> _matchingProducts;

  @override
  void initState() {
    super.initState();
    late final ProductCategory matchingCategory;
    matchingCategory = widget.store.productCategories.firstWhere(
      (productCategory) {
        return productCategory.products.any(
          (product) {
            return product.name == widget.product.name;
          },
        );
      },
    );
    _categoryName = matchingCategory.name;
    _products = List.from(matchingCategory.products);
    _products.removeWhere((product) => product.name == widget.product.name);
    _matchingProducts = _products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar(
                  // pinned: true,
                  // floating: true,
                  title: AppText(
                    text: 'Choose backup option',
                    size: AppSizes.heading6,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverToBoxAdapter(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        text: 'Original item',
                        size: AppSizes.heading6,
                      ),
                      const Gap(10),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CachedNetworkImage(
                            imageUrl: widget.product.imageUrls.first),
                        title: AppText(
                          text: widget.product.name,
                        ),
                        trailing: AppText(
                          text:
                              '\$${widget.product.promoPrice ?? widget.product.initialPrice}',
                        ),
                      ),
                      const Gap(10),
                      AppTextFormField(
                        onChanged: (query) {
                          if (query != null) {
                            setState(() {
                              _matchingProducts = _products
                                  .where(
                                    (product) => product.name
                                        .toLowerCase()
                                        .contains(query.toLowerCase()),
                                  )
                                  .toList();
                            });
                          }
                        },
                        radius: 50,
                        controller: _searchController,
                        hintText: 'Search items',
                        prefixIcon: const Icon(Icons.search),
                      )
                    ],
                  )),
                ),
              ],
          body: Padding(
            padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: _categoryName,
                  weight: FontWeight.w600,
                  size: AppSizes.heading6,
                ),
                const Gap(10),
                Expanded(
                  child: _matchingProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                  text: _products.isEmpty
                                      ? 'No other items match in this store'
                                      : 'No match found'),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _matchingProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 120,
                                  mainAxisExtent: 220,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            final product = _matchingProducts[index];

                            return InkWell(
                              onTap: () {
                                navigatorKey.currentState!.pop();
                              },
                              child: Ink(
                                child: SizedBox(
                                  width: 110,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrls.first,
                                          width: 110,
                                          height: 120,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const Gap(5),
                                      AppText(
                                        text: product.name,
                                        weight: FontWeight.w600,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Visibility(
                                            visible: product.promoPrice != null,
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
                                                product.initialPrice.toString(),
                                            decoration:
                                                product.promoPrice != null
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          )),
    );
  }
}
