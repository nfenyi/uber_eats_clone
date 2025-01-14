import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';

class GroupOrderPaymentScreen extends ConsumerStatefulWidget {
  const GroupOrderPaymentScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderPaymentScreenState();
}

class _GroupOrderPaymentScreenState
    extends ConsumerState<GroupOrderPaymentScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '0';
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  text: 'Choose who pays',
                  size: AppSizes.heading5,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                const AppText(
                    text:
                        'Pay for the whole order or let each person pay for themselves. Payment methods are charged when the order is placed.'),
                const Gap(20),
                const AppRadioListTile(
                  secondary: Icon(Icons.credit_card),
                  groupValue: 'group',
                  value: 'You pay for everyone',
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                AppTextFormField(
                  prefixIcon: const AppText(text: '\$'),
                  controller: _controller,
                  suffixText: 'per person',
                ),
                const Divider(),
                const AppRadioListTile(
                  groupValue: 'group',
                  secondary: Icon(Icons.group),
                  value: 'Everyone pays for themselves',
                  subtitle: 'Up to 18 people',
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ],
            ),
            const Column(
              children: [
                AppButton(text: 'Save'),
                Gap(10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
