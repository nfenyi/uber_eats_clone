// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gap/gap.dart';
// import 'package:image_color_builder/image_color_builder.dart';
// import 'package:marquee_list/marquee_list.dart';

// import '../../../../main.dart';
// import '../../../../models/store/store_model.dart';
// import '../../../constants/app_sizes.dart';
// import '../../../constants/asset_names.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_text.dart';

// import '../../../core/widgets.dart';
// import 'grocery_shop_search_screen.dart';
// import '../../home/home_screen.dart';

// class GroceryShopScreen extends StatefulWidget {
//   final Store groceryStore;
//   const GroceryShopScreen({super.key, required this.groceryStore});

//   @override
//   State<GroceryShopScreen> createState() => _GroceryShopScreenState();
// }

// class _GroceryShopScreenState extends State<GroceryShopScreen> {
//   bool _onFilterScreen = false;
//   List<String> _selectedFilters = [];

//   // final FocusNode _focus = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               automaticallyImplyLeading: false,
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: AppSizes.horizontalPaddingSmall),
//                   child: InkWell(
//                     child: Ink(
//                       child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                               color: Colors.black38,
//                               borderRadius: BorderRadius.circular(50)),
//                           child: const Icon(
//                             Icons.more_horiz,
//                             color: Colors.white,
//                           )),
//                     ),
//                   ),
//                 )
//               ],
//               // leadingWidth: 50,
//               leading: InkWell(
//                 onTap: () {
//                   navigatorKey.currentState!.pop();
//                 },
//                 child: Ink(
//                   decoration: BoxDecoration(
//                       color: Colors.black38,
//                       borderRadius: BorderRadius.circular(50)),
//                   padding: const EdgeInsets.all(1),
//                   child: const Icon(
//                     FontAwesomeIcons.arrowLeft,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//               pinned: true,
//               floating: true,
//               expandedHeight: 210,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: ImageColorBuilder(
//                     fit: BoxFit.fitHeight,
//                     url: widget.groceryStore.logo,
//                     placeholder: (contect, url) => Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: AppSizes.horizontalPaddingSmall,
//                             vertical: 50),
//                         color: AppColors.neutral500,
//                         child: Column(children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(50),
//                             child: Image.asset(
//                               AssetNames.store,
//                               // color: Colors.black,
//                               height: 40,
//                             ),
//                           ),
//                           const Gap(10),
//                           AppText(
//                             text: widget.groceryStore.name,
//                             color: Colors.white,
//                             size: AppSizes.bodySmall,
//                             weight: FontWeight.w600,
//                           ),
//                           const Gap(10),
//                           MarqueeList(
//                               scrollDuration: const Duration(seconds: 20),
//                               children: [
//                                 AppText(
//                                     color: Colors.white,
//                                     text:
//                                         '${widget.groceryStore.delivery.estimatedDeliveryTime} min'),
//                                 AppText(
//                                   color: Colors.white,
//                                   text:
//                                       ' • \$${widget.groceryStore.delivery.fee} Delivery Fee',
//                                 ),
//                                 AppText(
//                                   color: Colors.white,
//                                   text:
//                                       ' • ${widget.groceryStore.location.streetAddress}',
//                                 ),
//                                 Visibility(
//                                   visible: widget.groceryStore.delivery.fee < 1,
//                                   child: Row(children: [
//                                     const AppText(
//                                       text: ' • ',
//                                       color: Colors.white,
//                                     ),
//                                     Image.asset(
//                                       AssetNames.uberOneSmall,
//                                       color: Colors.white,
//                                       height: 10,
//                                     )
//                                   ]),
//                                 ),
//                               ])
//                         ])),
//                     builder: (context, image, imageColor) {
//                       return Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: AppSizes.horizontalPaddingSmall,
//                               vertical: 50),
//                           color: imageColor ?? AppColors.neutral100,
//                           child: Column(children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child: SizedBox(
//                                 height: 60,
//                                 child: image!,
//                               ),
//                             ),
//                             const Gap(10),
//                             AppText(
//                               text: widget.groceryStore.name,
//                               color: Colors.white,
//                               size: AppSizes.bodySmall,
//                               weight: FontWeight.w600,
//                             ),
//                             const Gap(10),
//                             MarqueeList(
//                                 scrollDuration: const Duration(seconds: 20),
//                                 children: [
//                                   AppText(
//                                       color: Colors.white,
//                                       text:
//                                           '${widget.groceryStore.delivery.estimatedDeliveryTime} min'),
//                                   AppText(
//                                     color: Colors.white,
//                                     text:
//                                         ' • \$${widget.groceryStore.delivery.fee} Delivery Fee',
//                                   ),
//                                   AppText(
//                                     color: Colors.white,
//                                     text:
//                                         ' • ${widget.groceryStore.location.streetAddress}',
//                                   ),
//                                   Visibility(
//                                     visible:
//                                         widget.groceryStore.delivery.fee < 1,
//                                     child: Row(children: [
//                                       const AppText(
//                                         text: ' • ',
//                                         color: Colors.white,
//                                       ),
//                                       Image.asset(
//                                         AssetNames.uberOneSmall,
//                                         color: Colors.white,
//                                         height: 10,
//                                       )
//                                     ]),
//                                   ),
//                                 ])
//                           ]));
//                     }),

//                 // titlePadding: const EdgeInsets.symmetric(
//                 //     horizontal: AppSizes.horizontalPaddingSmall),

//                 title: SafeArea(
//                   child: InkWell(
//                     onTap: () =>
//                         navigatorKey.currentState!.push(MaterialPageRoute(
//                       builder: (context) => GroceryShopSearchScreen(
//                         store: widget.groceryStore,
//                       ),
//                     )),
//                     child: Ink(
//                       child: AppTextFormField(
//                         enabled: false,
//                         hintText: 'Search ${widget.groceryStore.name}',
//                         radius: 50,
//                         prefixIcon: const Padding(
//                           padding: EdgeInsets.only(left: 8.0),
//                           child: Icon(Icons.search),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 expandedTitleScale: 1,
//               ),
//             )
//           ];
//         },
//         body: Visibility(
//           visible: widget.groceryStore.productCategories.isNotEmpty,
//           replacement: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 // fit: BoxFit.fitHeight,
//                 AssetNames.store,
//                 height: 100,
//                 color: Colors.black,
//               ),
//               const Gap(10),
//               const AppText(
//                 text: 'Stores coming soon',
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               HomeScreenTopic(
//                 callback: () {},
//                 title: 'Recently viewed',
//               ),
//               SizedBox(
//                 height: 200,
//                 child: CustomScrollView(
//                   scrollDirection: Axis.horizontal,
//                   slivers: stores[2]
//                       .productCategories
//                       .map((productCategory) => SliverPadding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             sliver: SliverList.separated(
//                               separatorBuilder: (context, index) =>
//                                   const Gap(10),
//                               itemBuilder: (context, index) =>
//                                   ListView.separated(
//                                       scrollDirection: Axis.horizontal,
//                                       // TODO: find a way to do lazy loading and remove shrinkWrap
//                                       shrinkWrap: true,
//                                       itemCount:
//                                           productCategory.productsAndQuantities.length,
//                                       separatorBuilder: (context, index) =>
//                                           const Gap(15),
//                                       itemBuilder: (context, index) {
//                                         final product =
//                                             productCategory.products[index];
//                                         return ProductGridTile(
//                                             product: product, store: stores[2]);
//                                       }),
//                               itemCount: 1,
//                             ),
//                           ))
//                       .toList(),
//                 ),
//               ),
//               HomeScreenTopic(
//                   callback: () {},
//                   title: 'Prep brunch for Mum',
//                   subtitle: 'From ${stores[2].name}',
//                   imageUrl: stores[2].logo),
//               SizedBox(
//                 height: 200,
//                 child: CustomScrollView(
//                   scrollDirection: Axis.horizontal,
//                   slivers: stores[2]
//                       .productCategories
//                       .map((productCategory) => SliverPadding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             sliver: SliverList.separated(
//                               separatorBuilder: (context, index) =>
//                                   const Gap(10),
//                               itemBuilder: (context, index) =>
//                                   ListView.separated(
//                                       scrollDirection: Axis.horizontal,
//                                       // TODO: find a way to do lazy loading and remove shrinkWrap
//                                       shrinkWrap: true,
//                                       itemCount:
//                                           productCategory.products.length,
//                                       separatorBuilder: (context, index) =>
//                                           const Gap(15),
//                                       itemBuilder: (context, index) {
//                                         final product =
//                                             productCategory.products[index];
//                                         return ProductGridTile(
//                                             product: product, store: stores[2]);
//                                       }),
//                               itemCount: 1,
//                             ),
//                           ))
//                       .toList(),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
