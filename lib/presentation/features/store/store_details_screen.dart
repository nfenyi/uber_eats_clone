import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/octicon.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/uber_one_screen.dart';
import 'package:uber_eats_clone/presentation/features/uber_one/join_uber_one_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../app_functions.dart';
import '../../../main.dart';
import '../../constants/asset_names.dart';
import '../../constants/weblinks.dart';
import '../../core/app_text.dart';
import '../home/home_screen.dart';
import '../webview/webview_screen.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Store store;
  const StoreDetailsScreen(
    this.store, {
    super.key,
  });

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final _webViewcontroller = WebViewControllerPlus();

  bool _timeExpanded = false;

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDayNow = TimeOfDay.now();
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              //TODO: implement map
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                pinned: true,
                floating: true,
                title: AppText(text: widget.store.name),
              )
            ];
          },
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
                child: Row(
                  children: [
                    AppText(
                        color: AppColors.neutral600,
                        text: widget.store.location.countryOfOrigin),
                    AppText(
                        color: AppColors.neutral600,
                        text: " • ${widget.store.type}"),
                    if (widget.store.isGroupFriendly)
                      const AppText(
                          color: AppColors.neutral600,
                          text: ' • Group Friendly'),
                    AppText(
                        color: AppColors.neutral600,
                        text: " • ${widget.store.priceCategory}")
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.pin_drop_outlined,
                ),
                title: AppText(text: widget.store.location.streetAddress),
                trailing: const Icon(
                  Icons.copy,
                  size: 20,
                ),
              ),
              const Divider(
                indent: 55,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      _timeExpanded = value;
                    });
                  },
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.centerLeft,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 55),
                  leading: const Icon(
                    Icons.watch_later,
                  ),
                  title: AppText(
                      text: timeOfDayNow.hour < widget.store.openingTime.hour ||
                              (timeOfDayNow.hour >=
                                      widget.store.closingTime.hour &&
                                  timeOfDayNow.minute >=
                                      widget.store.closingTime.minute)
                          ? "Opens at ${AppFunctions.formatTime(widget.store.openingTime)}"
                          : "Opens until ${AppFunctions.formatTime(widget.store.closingTime)}"),
                  trailing: _timeExpanded
                      ? const Iconify(
                          Octicon.dash_16,
                          size: 20,
                        )
                      : const Icon(
                          Icons.add_outlined,
                          size: 20,
                        ),
                  children: [
                    const AppText(
                      text: 'Sunday',
                    ),
                    AppText(
                      text:
                          "${AppFunctions.formatTime(widget.store.openingTime)} - ${AppFunctions.formatTime(widget.store.closingTime)}",
                      color: AppColors.neutral500,
                    ),
                    const AppText(text: 'Monday - Friday'),
                    AppText(
                      text:
                          "${AppFunctions.formatTime(widget.store.openingTime)} - ${AppFunctions.formatTime(widget.store.closingTime)}",
                      color: AppColors.neutral500,
                    ),
                    const AppText(text: 'Saturday'),
                    AppText(
                      text:
                          "${AppFunctions.formatTime(widget.store.openingTime)} - ${AppFunctions.formatTime(widget.store.closingTime)}",
                      color: AppColors.neutral500,
                    ),
                    const Gap(10),
                  ],
                ),
              ),
              const Divider(
                indent: 55,
              ),
              ListTile(
                onTap: () => navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const JoinUberOneScreen(),
                )),
                leading: Image.asset(
                  AssetNames.uberOneSmall,
                  width: 21,
                ),
                title: const AppText(
                    text: 'Get a \$0 Delivery Fee + up to 10% off'),
                subtitle: const AppText(
                  text: 'Try Uber One to save on eligible orders',
                  color: AppColors.neutral500,
                ),
              ),
              const Divider(
                indent: 55,
              ),
              ListTile(
                leading: const Icon(
                  Icons.star_outline,
                ),
                title: AppText(
                    text:
                        "${widget.store.rating.averageRating} (${widget.store.rating.averageRating}+ ratings)"),
              ),
              const Divider(),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: RichText(
                  text: TextSpan(
                      text:
                          "WARNING: Certain foods and beverages sold or served here canexpose you to chemicals including acrylamide in many fried orbaked foods, and mercury in fish, which are known to the State ofCalifornia to cause cancer and birth defects or other reproductiveharm. For more information go to ",
                      style: const TextStyle(
                        fontSize: AppSizes.bodySmallest,
                        color: AppColors.neutral500,
                      ),
                      children: [
                        TextSpan(
                          text: 'www.P65Warnings.ca.gov/restaurant.',
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => WebViewScreen(
                                  controller: _webViewcontroller,
                                  link: Weblinks.p65Warnings,
                                ),
                              ));
                            },
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}
