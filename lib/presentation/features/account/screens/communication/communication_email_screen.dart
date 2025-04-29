import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../core/app_colors.dart';

class CommunicationEmailScreen extends ConsumerStatefulWidget {
  const CommunicationEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunicationEmailScreenState();
}

class _CommunicationEmailScreenState
    extends ConsumerState<CommunicationEmailScreen> {
  bool _hasSubscribed = false;

  bool _enablePromoOffers = false;
  bool _enableMembership = false;
  bool _enableNews = false;
  bool _enableRecommendations = false;
  bool _enableReminders = false;
  final List<String> _emails = ['nanafenyim@gmail.com', 'fish@gmail.com'];
  late String _selectedEmail;

  @override
  void initState() {
    super.initState();
    _selectedEmail = _emails.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar.medium(
                  title: AppText(
                    text: 'Email',
                    // color: Colors.red,
                    weight: FontWeight.bold,
                    size: AppSizes.heading6,
                  ),
                  pinned: true,
                )
              ],
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppText(
                  text: 'Email Address',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
              ),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: false,
                    context: context,
                    builder: (context) {
                      return Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _emails
                                .map(
                                  (email) => ListTile(
                                    onTap: () {
                                      setState(() {
                                        _selectedEmail = email;
                                        // _isEmailExpanded = false;
                                      });
                                      navigatorKey.currentState!.pop();
                                    },
                                    title: AppText(text: email),
                                  ),
                                )
                                .toList(),
                          ));
                    },
                  );
                },
                title: AppText(
                  text: _selectedEmail,
                  size: AppSizes.bodySmall,
                ),
                trailing: const Icon(Icons.keyboard_arrow_down),
              ),
              SwitchListTile.adaptive(
                title: const AppText(
                  text: 'Subscribed',
                  size: AppSizes.bodySmall,
                ),
                value: _hasSubscribed,
                onChanged: (value) {
                  setState(() {
                    _hasSubscribed = value;
                  });
                },
              ),
              const Gap(10),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppText(
                  text: 'Categories',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
              ),
              CheckboxListTile.adaptive(
                subtitle: const AppText(
                  text: 'Promotional offers, discounts and referral bonus',
                  color: AppColors.neutral500,
                ),
                title: const AppText(
                  text: 'Promotional offers',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
                value: _enablePromoOffers,
                onChanged: (value) {
                  setState(() {
                    _enablePromoOffers = value ?? false;
                  });
                },
              ),
              CheckboxListTile.adaptive(
                subtitle: const AppText(
                  text: 'Uber One membership benefits and loyalty rewards',
                  color: AppColors.neutral500,
                ),
                title: const AppText(
                  text: 'Membership',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
                value: _enableMembership,
                onChanged: (value) {
                  setState(() {
                    _enableMembership = value ?? false;
                  });
                },
              ),
              CheckboxListTile.adaptive(
                subtitle: const AppText(
                  text: 'New product updates and interesting news',
                  color: AppColors.neutral500,
                ),
                title: const AppText(
                  text: 'Product updates & news',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
                value: _enableNews,
                onChanged: (value) {
                  setState(() {
                    _enableNews = value ?? false;
                  });
                },
              ),
              CheckboxListTile.adaptive(
                subtitle: const AppText(
                  text: 'Recommendations',
                  color: AppColors.neutral500,
                ),
                title: const AppText(
                  text: 'Recommendations for great food, groceries and more',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
                value: _enableRecommendations,
                onChanged: (value) {
                  setState(() {
                    _enableRecommendations = value ?? false;
                  });
                },
              ),
              CheckboxListTile.adaptive(
                subtitle: const AppText(
                  text: 'Reminders for unfinished orders',
                  color: AppColors.neutral500,
                ),
                title: const AppText(
                  text: 'Reminders',
                  weight: FontWeight.bold,
                  size: AppSizes.bodySmall,
                ),
                value: _enableReminders,
                onChanged: (value) {
                  setState(() {
                    _enableReminders = value ?? false;
                  });
                },
              ),
            ],
          )),
    );
  }
}
