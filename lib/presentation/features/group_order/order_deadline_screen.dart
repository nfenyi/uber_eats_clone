import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../app_functions.dart';
import '../../../main.dart';
import '../../core/app_colors.dart';

class OrderDeadlineScreen extends ConsumerStatefulWidget {
  final DateTime? setDeadline;
  final String orderPlacementSetting;
  final DateTime? firstOrderSchedule;
  const OrderDeadlineScreen(
      {super.key,
      required this.setDeadline,
      required this.firstOrderSchedule,
      required this.orderPlacementSetting});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderDeadlineScreenState();
}

class _OrderDeadlineScreenState extends ConsumerState<OrderDeadlineScreen> {
  final _controller = TextEditingController();
  DateTime? _setDeadline;

  String _orderPlacementSetting = 'Remind me to place the order';

  @override
  void initState() {
    super.initState();
    _setDeadline = widget.setDeadline;

    _controller.text = widget.firstOrderSchedule == null
        ? _setDeadline == null
            ? 'No deadline'
            : AppFunctions.formatDate(_setDeadline.toString(),
                format: 'l, M j, g:i A')
        : '1 hour before';
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
                //TODO: implement important/loud notification for group orders
                const AppText(
                  text: 'Set an order deadline',
                  size: AppSizes.heading5,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                const AppText(text: 'When should everyone order by?'),
                const Gap(20),
                AppTextFormField(
                  readOnly: true,
                  enabled: widget.firstOrderSchedule == null,
                  controller: _controller,
                  onTap: widget.firstOrderSchedule == null
                      ? () => BottomPicker.dateTime(
                            onSubmit: (value) {
                              setState(() {
                                _setDeadline = value;
                                _controller.text = AppFunctions.formatDate(
                                    value.toString(),
                                    format: 'l, M j, g:i A');
                              });
                            },
                            titlePadding:
                                const EdgeInsets.symmetric(vertical: 15),
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
                                  size: AppSizes.body,
                                  weight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ).show(context)
                      : null,
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: widget.firstOrderSchedule == null
                        ? Colors.black
                        : AppColors.neutral500,
                  ),
                ),
                const Gap(20),
                if (_controller.text != 'No deadline' &&
                    widget.firstOrderSchedule == null)
                  Column(
                    children: [
                      RadioListTile(
                        title: const AppText(
                          text: 'Remind me to place the order',
                          weight: FontWeight.bold,
                          size: AppSizes.bodySmall,
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _orderPlacementSetting = value;
                            });
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        subtitle: const AppText(
                            size: AppSizes.bodySmaller,
                            text: "We'll remind you to place the order"),
                        groupValue: _orderPlacementSetting,
                        value: 'Remind me to place the order',
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                      const Divider(),
                      RadioListTile(
                        title: const AppText(
                          text: 'Automatically place the order',
                          weight: FontWeight.bold,
                          size: AppSizes.bodySmall,
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _orderPlacementSetting = value;
                            });
                          }
                        },
                        groupValue: _orderPlacementSetting,
                        contentPadding: EdgeInsets.zero,
                        subtitle: const AppText(
                            size: AppSizes.bodySmallest,
                            text:
                                "Add your items and check out. We'll place the order at the deadline."),
                        value: 'Automatically place the order',
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                      const Gap(30),
                      if (widget.firstOrderSchedule == null)
                        Center(
                            child: AppTextButton(
                          text: 'Remove Deadline',
                          color: Colors.grey.shade600,
                          callback: () {
                            setState(() {
                              _controller.text = "No deadline";
                              _setDeadline = null;
                            });
                          },
                          isUnderlined: true,
                        ))
                    ],
                  ),
              ],
            ),
            Column(
              children: [
                AppButton(
                  text: 'Save',
                  callback:
                      widget.firstOrderSchedule == null && _setDeadline != null
                          ? () {
                              navigatorKey.currentState!.pop({
                                'setDeadline': widget.firstOrderSchedule != null
                                    ? widget.firstOrderSchedule!
                                        .add(const Duration(hours: 1))
                                    : _setDeadline,
                                'orderPlacementSetting': _orderPlacementSetting
                              });
                            }
                          : null,
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
