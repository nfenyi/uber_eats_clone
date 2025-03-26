import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/features/store/store_screen.dart';

import '../../../app_functions.dart';
import '../../../models/store/store_model.dart';
import '../../constants/asset_names.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../home/home_screen.dart';

class AdvertScreen extends StatefulWidget {
  final Store store;
  final List<Object> productRefs;
  const AdvertScreen(
      {super.key, required this.store, required this.productRefs});

  @override
  State<AdvertScreen> createState() => _AdvertScreenState();
}

class _AdvertScreenState extends State<AdvertScreen> {
  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDayNow = TimeOfDay.now();
    final bool isClosed = timeOfDayNow.hour < widget.store.openingTime.hour ||
        (timeOfDayNow.hour >= widget.store.closingTime.hour &&
            timeOfDayNow.minute >= widget.store.closingTime.minute);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar.medium(
                  pinned: true,
                  floating: true,
                  expandedHeight: 100,
                  title: AppText(
                    text: 'Prep brunch for Mom',
                    weight: FontWeight.w600,
                    size: AppSizes.heading6,
                  ),
                )
              ],
          body: Column(
            children: [
              ListTile(
                  onTap: () => navigatorKey.currentState!
                          .pushReplacement(MaterialPageRoute(
                        builder: (context) => StoreScreen(
                          widget.store,
                        ),
                      )),
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColors.neutral200)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: widget.store.logo,
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: AppText(text: widget.store.name),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Visibility(
                              visible: widget.store.delivery.fee < 1,
                              child: Image.asset(
                                AssetNames.uberOneSmall,
                                height: 10,
                              )),
                          AppText(
                              text: isClosed
                                  ? widget.store.openingTime.hour -
                                              timeOfDayNow.hour >
                                          1
                                      ? 'Available at ${AppFunctions.formatDate(widget.store.openingTime.toString(), format: 'h:i A')}'
                                      : 'Available in ${widget.store.openingTime.hour - timeOfDayNow.hour == 1 ? '1 hr' : '${widget.store.openingTime.minute - timeOfDayNow.minute} mins'}'
                                  : '\$${widget.store.delivery.fee} Delivery Fee',
                              color: widget.store.delivery.fee < 1
                                  ? const Color.fromARGB(255, 163, 133, 42)
                                  : null),
                          AppText(
                              text:
                                  ' • ${widget.store.delivery.estimatedDeliveryTime} min'),
                        ],
                      ),
                      if (widget.store.offers != null &&
                          widget.store.offers!.isNotEmpty)
                        OfferText(store: widget.store)
                    ],
                  )),
              const Divider(
                indent: 60,
              ),
              Expanded(
                  child: GridView.builder(
                padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    mainAxisExtent: 220,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: AppFunctions.loadProductReference(
                          widget.productRefs[index] as DocumentReference),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Skeletonizer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 150,
                                height: 150,
                                color: Colors.amber,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return AppText(
                            text: snapshot.error.toString(),
                          );
                        }
                        final product = snapshot.data!;
                        return Column(
                          children: [
                            ProductGridTile(
                              product: product,
                              store: widget.store,
                            ),
                            if (product.promoPrice != null)
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(50)),
                                padding: const EdgeInsets.all(5),
                                child: AppText(
                                    color: Colors.white,
                                    text:
                                        '${(((product.initialPrice - product.promoPrice!) / product.initialPrice) * 100).toStringAsFixed(0)}% off'),
                              )
                          ],
                        );
                      });
                },
                itemCount: widget.productRefs.length,
              )),
            ],
          )),
    );
  }
}

class OfferText extends StatelessWidget {
  const OfferText(
      {super.key, required this.store, this.textColor = Colors.green});

  final Store store;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return AppText(
      text:
          '${store.offers?.length == 1 ? store.offers?.first.title : '${store.offers?.length} Offers available'}',
      color: Colors.green,
    );
  }
}
