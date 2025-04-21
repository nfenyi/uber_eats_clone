import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

class GroupOrderPaymentScreen extends ConsumerStatefulWidget {
  final String whoPays;
  final String spendingLimit;
  const GroupOrderPaymentScreen({
    super.key,
    required this.whoPays,
    required this.spendingLimit,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderPaymentScreenState();
}

class _GroupOrderPaymentScreenState
    extends ConsumerState<GroupOrderPaymentScreen> {
  final _controller = TextEditingController();

  late String _whoPays;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _whoPays = widget.whoPays;
    if (_whoPays == 'You pay for everyone') {
      _controller.text = widget.spendingLimit;
    }
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
                  size: AppSizes.heading6,
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                const AppText(
                    text:
                        'Pay for the whole order or let each person pay for themselves. Payment methods are charged when the order is placed.'),
                const Gap(20),
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _whoPays = value;
                      });
                    }
                  },
                  title: const AppText(
                    text: 'You pay for everyone',
                    weight: FontWeight.bold,
                  ),
                  secondary: const Icon(Icons.credit_card),
                  groupValue: _whoPays,
                  value: 'You pay for everyone',
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                if (_whoPays == 'You pay for everyone')
                  Form(
                    key: _formKey,
                    child: AppTextFormField(
                      validator: FormBuilderValidators.positiveNumber(
                          errorText:
                              'State the maximum each group member can spend'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      constraintWidth: 80,
                      hintText: 'No spending limit',
                      prefixIcon: const AppText(text: '\$'),
                      controller: _controller,
                      suffixIcon: const AppText(text: 'per person'),
                    ),
                  ),
                const Gap(15),
                const Divider(),
                const Gap(5),
                RadioListTile(
                  title: const AppText(
                    text: 'Everyone pays for themselves',
                    weight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _controller.clear();
                        _whoPays = value;
                      });
                    }
                  },
                  groupValue: _whoPays,
                  secondary: const Icon(Icons.group),
                  value: 'Everyone pays for themselves',
                  subtitle: const AppText(text: 'Up to 18 people'),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ],
            ),
            Column(
              children: [
                AppButton(
                  text: 'Save',
                  callback: () {
                    if (_whoPays == 'You pay for everyone') {
                      if (_formKey.currentState!.validate()) {
                        navigatorKey.currentState!.pop({
                          'whoPays': _whoPays,
                          "spendingLimit": double.parse(_controller.text.trim())
                              .toStringAsFixed(2)
                        });
                      }
                    } else {
                      navigatorKey.currentState!
                          .pop({'whoPays': _whoPays, "spendingLimit": ''});
                    }
                  },
                ),
                const Gap(10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
