import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../app_functions.dart';
import '../../../main.dart';
import '../../constants/app_sizes.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../home/home_screen.dart';

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
              const SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  // expandedTitleScale: 2,
                  title: AppText(
                    text: 'Grocery',
                    weight: FontWeight.w600,
                    size: AppSizes.bodySmall,
                  ),
                ),
              )
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
                  // onTap: () => navigatorKey.currentState!
                  //         .pushReplacement(MaterialPageRoute(
                  //       builder: (context) => StoreScreen(groceryStore),
                  //     )),
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.neutral200)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: groceryStore.logo,
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: AppText(text: groceryStore.name),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  trailing: InkWell(
                    onTap: () {},
                    child: Ink(
                      child: Icon(
                        groceryStore.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: AppColors.neutral500,
                      ),
                    ),
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
                                      ? 'Available at ${AppFunctions.formatTime(groceryStore.openingTime)}'
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
                      const AppText(
                        text: 'Offers available',
                        color: Colors.green,
                      )
                    ],
                  ));
            },
          )),
    );
  }
}
