import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';

class OrderDeadlineScreen extends ConsumerStatefulWidget {
  const OrderDeadlineScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderDeadlineScreenState();
}

class _OrderDeadlineScreenState extends ConsumerState<OrderDeadlineScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = 'No deadline';
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
                  text: 'Set an order deadline',
                  size: AppSizes.heading6,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                const AppText(text: 'When should everyone order by?'),
                const Gap(20),
                InkWell(
                  onTap: () => BottomPicker.dateTime(
                    onSubmit: (value) {
                      // value as DateTime;
                      setState(() {
                        _controller.text = value.toString();
                      });
                    },
                    titlePadding: const EdgeInsets.symmetric(vertical: 15),
                    displayCloseIcon: false,
                    buttonPadding: 15,
                    buttonWidth: Adaptive.w(90),
                    buttonSingleColor: Colors.black,
                    buttonContent: const Align(
                        alignment: Alignment.center,
                        child: AppText(
                          text: 'Save',
                          color: Colors.white,
                        )),
                    dismissable: true,
                    titleAlignment: Alignment.center,
                    pickerTitle: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: 'Pick a time',
                          size: AppSizes.bodySmall,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ).show(context),
                  child: Ink(
                    child: AppTextFormField(
                      hintStyleColor: Colors.black,
                      controller: _controller,
                      enabled: false,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                if (_controller.text != 'No deadline')
                  Column(
                    children: [
                      const AppRadioListTile(
                        padding: EdgeInsets.zero,
                        subtitle: "We'll remind you to place the order",
                        groupValue: 'value',
                        value: 'Remind me to place the order',
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                      const Divider(),
                      const AppRadioListTile(
                        groupValue: 'value',
                        padding: EdgeInsets.zero,
                        subtitle:
                            "Add your items and check out. We'll place the order at the deadline.",
                        value: 'Automatically place the order',
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                      Center(
                          child: AppTextButton(
                        text: 'Remove Deadline',
                        size: AppSizes.bodySmall,
                        color: Colors.grey.shade600,
                        callback: () {
                          setState(() {
                            _controller.text = "No deadline";
                          });
                        },
                        isUnderlined: true,
                      ))
                    ],
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
