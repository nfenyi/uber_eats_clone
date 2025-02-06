import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/help/i_need_help_updating_account_screen.dart';
import '../../../core/app_colors.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _shopCategories = ['Restaurants', 'Stores'];
  late String _selectedCategory;

  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _shopCategories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleTextStyle: TextStyle(),
        // pinned: true,
        // expandedHeight: 80,
        // flexibleSpace: FlexibleSpaceBar(
        title: const AppText(
          text: 'Help',
          size: AppSizes.body,
          weight: FontWeight.bold,
        ),
        // ),
      ),
      //   ];
      // },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Expanded(
            child: ListView(
              children: [
                if (_selectedOption == null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChipsChoice<String>.single(
                              wrapped: false,
                              padding: EdgeInsets.zero,
                              value: _selectedCategory,
                              onChanged: (value) async {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              choiceItems: C2Choice.listFrom<String, String>(
                                // style: (index, item) => const C2ChipStyle(
                                //   height: 40,
                                //   // foregroundColor: Colors.white,
                                //   // backgroundColor: Colors.black,
                                // ),
                                source: _shopCategories,
                                value: (i, v) => v,
                                label: (i, v) => v,
                              ),
                              choiceStyle: C2ChipStyle.filled(
                                selectedStyle: const C2ChipStyle(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                height: 30,
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.neutral200,
                              ),
                            ),
                            const AppText(
                              text: 'All Topics',
                              weight: FontWeight.bold,
                              size: AppSizes.body,
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Account and payments';
                          });
                        },
                        title: const AppText(
                          text: 'Account and payments',
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Deliivery and pickup basics';
                          });
                        },
                        title: const AppText(
                          text: 'Deliivery and pickup basics',
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                if (_selectedOption == 'Account and payments')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: AppText(
                          text: 'Account and payments',
                          weight: FontWeight.bold,
                          size: AppSizes.body,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Account settings';
                          });
                        },
                        title: const AppText(
                          text: 'Account settings',
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Promos and partnerships';
                          });
                        },
                        title: const AppText(
                          text: 'Promos and partnerships',
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Payments';
                          });
                        },
                        title: const AppText(
                          text: 'Payments',
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Gift cards and vouchers';
                          });
                        },
                        title: const AppText(
                          text: 'Gift cards and vouchers',
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = "Can't sign in";
                          });
                        },
                        title: const AppText(
                          text: "Can't sign in",
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Uber Cash';
                          });
                        },
                        title: const AppText(
                          text: 'Uber Cash',
                          size: AppSizes.bodySmall,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
                if (_selectedOption == 'Account settings')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.horizontalPaddingSmall),
                        child: AppText(
                          text: 'Account settings',
                          weight: FontWeight.bold,
                          size: AppSizes.body,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption =
                                "I can't update my phone number or email";
                          });
                        },
                        title: const AppText(
                          text: "I can't update my phone number or email",
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Manage my notification settings';
                          });
                        },
                        title: const AppText(
                          text: 'Manage my notification settings',
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'I need help deleting my account';
                          });
                        },
                        title: const AppText(
                          text: 'I need help deleting my account',
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption =
                                'How do I update my account information?';
                          });
                        },
                        title: const AppText(
                          text: 'How do I update my account information?',
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = "Updating saved places";
                          });
                        },
                        title: const AppText(
                          text: "Updating saved places",
                          size: AppSizes.bodySmall,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedOption = 'Updating device language';
                          });
                        },
                        title: const AppText(
                          text: 'Updating device language',
                          size: AppSizes.bodySmall,
                        ),
                      ),
                    ],
                  ),
                if (_selectedOption == 'I need help deleting my account')
                  const INeedHelpUpdatingAccountScreen()
              ],
            ),
          )
        ],
      ),
      // ),
    );
  }
}
