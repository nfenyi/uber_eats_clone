import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/group_order/group_order_model.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/features/group_order/group_order_screen.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../../core/app_text.dart';
import '../../core/widgets.dart';

class GroupOrderCompleteScreen extends ConsumerStatefulWidget {
  final GroupOrder groupOrder;
  final Store store;
  const GroupOrderCompleteScreen(
      {super.key, required this.groupOrder, required this.store});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderCompleteScreenState();
}

class _GroupOrderCompleteScreenState
    extends ConsumerState<GroupOrderCompleteScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return GroupOrderScreen(
                    store: widget.store,
                    groupOrder: widget.groupOrder,
                  );
                },
              ));
            },
            child: const Icon(Icons.close)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AssetNames.groupOrderComplete,
              width: double.infinity,
            ),
            const Gap(10),
            AppText(
              text: widget.groupOrder.frequency != null
                  ? "Repeat group order scheduled"
                  : 'Group order scheduled',
              size: AppSizes.heading5,
              weight: FontWeight.bold,
            ),
            const Gap(15),
            const AppText(
                color: AppColors.neutral500,
                text:
                    'You can invite guests by sharing a link below. Make changes or cancel this repeat order from your cart.'),
            const Gap(10),
            (widget.groupOrder.frequency != null)
                ? ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    title: AppText(
                      text: widget.groupOrder.frequency == null
                          ? "Does not repeat"
                          : widget.groupOrder.frequency!,
                      size: AppSizes.bodySmall,
                    ),
                    subtitle: AppText(
                      text:
                          '${AppFunctions.formatDate(widget.groupOrder.firstOrderSchedule.toString(), format: 'g:i A')} - ${AppFunctions.formatDate(widget.groupOrder.firstOrderSchedule!.add(const Duration(minutes: 30)).toString(), format: 'g:i A')}\nStarts ${AppFunctions.formatDate(widget.groupOrder.firstOrderSchedule.toString(), format: 'n/j/Y')}${widget.groupOrder.endDate == null ? '' : '. Ends ${AppFunctions.formatDate(widget.groupOrder.endDate.toString(), format: 'n/j/Y')}'}',
                      color: AppColors.neutral500,
                    ),
                    tileColor: AppColors.neutral100,
                    leading: const Icon(Icons.refresh),
                    contentPadding: const EdgeInsets.all(10),
                  )
                : ListTile(
                    tileColor: AppColors.neutral100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    leading: const Icon(Icons.shopping_bag),
                    title: AppText(
                      text: widget.groupOrder.orderByDeadline == null
                          ? 'People can order at any time'
                          : 'Order by ${AppFunctions.formatDate(widget.groupOrder.orderByDeadline.toString(), format: 'D, M j, g:i A')}',
                      size: AppSizes.bodySmall,
                    ),
                    subtitle: AppText(
                      text: widget.groupOrder.orderByDeadline == null
                          ? 'No deadline set'
                          : widget.groupOrder.orderPlacementSetting!,
                      color: AppColors.neutral500,
                    ),
                  ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
            AppButton(
                isLoading: _isLoading,
                callback: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final dynamicLinkParams = DynamicLinkParameters(
                      link: Uri.parse(
                          "https://uber-eats-clone-d792a.firebaseapp.com/group-order?id=${widget.groupOrder.id}"),
                      uriPrefix: "https://ubereatsclone.page.link",
                      androidParameters: const AndroidParameters(
                        packageName: 'com.example.uber_eats_clone',
                      ),
                      iosParameters: const IOSParameters(
                        bundleId: 'com.example.uberEatsClone',
                      ),
                    );
                    final dynamicLink = await FirebaseDynamicLinks.instance
                        .buildLink(dynamicLinkParams);
                    var displayName = Hive.box(AppBoxes.appState)
                        .get(BoxKeys.userInfo)['displayName'];
                    // logger.d(dynamicLink.shortUrl.toString());
                    // logger.d(dynamicLink.data?.uri);
                    await Share.share(dynamicLink.toString(),
                        subject:
                            '$displayName invites you to their group order');
                  } on Exception catch (e) {
                    await showAppInfoDialog(navigatorKey.currentContext!,
                        description: e.toString());
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
                text: 'Share a link'),
            const Gap(10),
            AppTextButton(
                text: 'Close',
                callback: () async => navigatorKey.currentState!
                        .pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return GroupOrderScreen(
                          store: widget.store,
                          groupOrder: widget.groupOrder,
                        );
                      },
                    ))),
          ],
        )
      ],
    );
  }
}
