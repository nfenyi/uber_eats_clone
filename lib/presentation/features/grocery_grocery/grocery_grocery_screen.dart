import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/features/some_kind_of_section/advert_screen.dart';

import '../../../app_functions.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../services/sign_in_view_model.dart';
import '../home/home_screen.dart';
import '../store/store_screen.dart';

class GroceryGroceryScreen extends StatefulWidget {
  final List<Store> stores;
  const GroceryGroceryScreen({super.key, required this.stores});

  @override
  State<GroceryGroceryScreen> createState() => _GroceryGroceryScreenState();
}

class _GroceryGroceryScreenState extends State<GroceryGroceryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar.medium(
                pinned: true,
                floating: true,
                expandedHeight: 90,
                title: AppText(
                  text: 'Grocery',
                  weight: FontWeight.w600,
                  size: AppSizes.heading5,
                ),
              ),
            ];
          },
          body: ListView.builder(
            itemCount: widget.stores.length,
            itemBuilder: (context, index) {
              final groceryStore = widget.stores[index];
              TimeOfDay timeOfDayNow = TimeOfDay.now();
              final bool isClosed = timeOfDayNow.hour <
                      groceryStore.openingTime.hour ||
                  (timeOfDayNow.hour >= groceryStore.closingTime.hour &&
                      timeOfDayNow.minute >= groceryStore.closingTime.minute);
              return ListTile(
                  onTap: () async {
                    await AppFunctions.navigateToStoreScreen(groceryStore);
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.neutral200)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: groceryStore.logo,
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: AppText(
                    text: groceryStore.name,
                    size: AppSizes.bodySmall,
                    weight: FontWeight.bold,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  trailing: FavouriteButton(
                    store: groceryStore,
                    color: AppColors.neutral500,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Visibility(
                              visible: groceryStore.delivery.fee < 1,
                              child: Image.asset(
                                AssetNames.uberOneSmall,
                                height: 10,
                              )),
                          AppText(
                              text: isClosed
                                  ? groceryStore.openingTime.hour -
                                              timeOfDayNow.hour >
                                          1
                                      ? 'Available at ${AppFunctions.formatDate(groceryStore.openingTime.toString(), format: 'h:i A')}'
                                      : 'Available in ${groceryStore.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${groceryStore.openingTime.minute - timeOfDayNow.minute} mins'}'
                                  : '\$${groceryStore.delivery.fee} Delivery Fee',
                              color: groceryStore.delivery.fee < 1
                                  ? const Color.fromARGB(255, 163, 133, 42)
                                  : null),
                          AppText(
                              text:
                                  ' • ${groceryStore.delivery.estimatedDeliveryTime} min'),
                        ],
                      ),
                      if (groceryStore.offers != null &&
                          groceryStore.offers!.isNotEmpty)
                        OfferText(store: groceryStore)
                    ],
                  ));
            },
          )),
    );
  }
}
