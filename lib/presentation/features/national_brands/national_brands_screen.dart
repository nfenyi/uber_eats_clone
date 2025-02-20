import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/features/store/store_screen.dart';

import '../../../main.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../home/home_screen.dart';

class NationalBrandsScreen extends StatefulWidget {
  final List<Store> nationalBrands;
  const NationalBrandsScreen({super.key, required this.nationalBrands});

  @override
  State<NationalBrandsScreen> createState() => _NationalBrandsScreenState();
}

class _NationalBrandsScreenState extends State<NationalBrandsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'National brands',
          size: AppSizes.heading6,
          // weight: FontWeight.w600,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        separatorBuilder: (context, index) => const Gap(10),
        itemBuilder: (context, index) {
          final nationalBrand = widget.nationalBrands[index];
          bool isFavorite = nationalBrand.isFavorite;
          return InkWell(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => StoreScreen(nationalBrand),
              ));
            },
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: nationalBrand.cardImage,
                        width: 100,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        child: Ink(
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Gap(20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: nationalBrand.name,
                            weight: FontWeight.w600,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: AppColors.neutral200,
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: AppText(
                                  text: nationalBrand.rating.averageRating
                                      .toString()))
                        ],
                      ),
                      AppText(
                        text: '\$${nationalBrand.delivery.fee} Delivery Fee',
                      ),

                      AppText(
                        text:
                            '${nationalBrand.delivery.estimatedDeliveryTime} min',
                        maxLines: 2,
                        color: AppColors.neutral500,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // AppText(
                      //   text: nationalBrand.description!,
                      //   maxLines: 2,
                      //   color: AppColors.neutral500,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: widget.nationalBrands.length,
      ),
    );
  }
}
