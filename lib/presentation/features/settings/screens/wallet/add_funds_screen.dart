import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../constants/asset_names.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  final _fundController = TextEditingController();

  String? _selectedFund;

  @override
  void initState() {
    super.initState();
    _fundController.text = '0.00';
  }

  @override
  void dispose() {
    _fundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Add Funds',
                  weight: FontWeight.bold,
                  size: AppSizes.heading4,
                ),
                const Gap(15),
                const AppText(
                  text:
                      'How much do you want to add to your Uber Cash balance?',
                  size: AppSizes.body,
                ),
                const Gap(20),
                AppTextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _fundController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  prefix: Text(
                    '\$ ',
                    style: GoogleFonts.robotoMono(
                      color: Colors.black,
                      fontSize: AppSizes.heading4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  textStyle: GoogleFonts.robotoMono(
                    fontSize: AppSizes.heading4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(10),
                const AppText(
                  text: 'Enter an amount between \$25 and \$500',
                  color: AppColors.neutral500,
                ),
                ChipsChoice<String>.single(
                  wrapped: false,
                  padding: EdgeInsets.zero,
                  value: _selectedFund,
                  onChanged: (value) async {
                    setState(() {
                      _selectedFund = value;
                      _fundController.text = value;
                    });
                  },
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: ['50.00', '100.00', '200.00'],
                    value: (i, v) => v,
                    label: (i, v) => '\$$v',
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
                InkWell(
                    onTap: () {},
                    child: Ink(
                        child: const AppText(
                      text: 'Terms apply',
                      decoration: TextDecoration.underline,
                      color: Colors.green,
                    )))
              ],
            ),
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(
                    text: 'Payment method',
                    color: AppColors.neutral500,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        AssetNames.masterCardLogo,
                        width: 15,
                        height: 15,
                      ),
                      const Gap(5),
                      const AppText(text: '4320'),
                      const Gap(5),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      isSecondary: true,
                      text: 'CANCEL',
                      callback: () {
                        navigatorKey.currentState!.pop();
                      },
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: AppButton(
                      text: 'CONFIRM',
                      callback: _fundController.text.isEmpty ||
                              double.parse(_fundController.text) < 25 ||
                              double.parse(_fundController.text) > 500
                          ? null
                          : () {
                              navigatorKey.currentState!.pop();
                            },
                    ),
                  )
                ],
              ),
              const Gap(10),
            ])
          ],
        ),
      ),
    );
  }
}
