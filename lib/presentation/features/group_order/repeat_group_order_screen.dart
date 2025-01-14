import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/drop_off_options_screen.dart';

import '../../../main.dart';
import '../../core/app_colors.dart';

class RepeatGroupOrderScreen extends ConsumerStatefulWidget {
  const RepeatGroupOrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RepeatGroupOrderScreenState();
}

class _RepeatGroupOrderScreenState
    extends ConsumerState<RepeatGroupOrderScreen> {
  final _scheduleController = TextEditingController();
  final _frequencyController = TextEditingController();
  final List<String> _frequencyOptions = [
    'Daily',
    'Every weekday (Mon-Fri)',
    'Weekly on ',
    'Bi-weekly on ',
    'Monthly on First '
  ];
  String? _selectedSchedule;
  String? _selectedFrequency;

  bool _endDate = false;

  final _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scheduleController.text = 'No deadline';
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    _frequencyController.dispose();
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
                  text: 'Repeat group order',
                  size: AppSizes.heading5,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                const AppText(
                    text:
                        'Select how often you want to place this group order. Everyone gets to choose their own items each time.'),
                const Gap(20),
                const AppText(
                  text: 'First order scheduled for',
                  size: AppSizes.body,
                ),
                const Gap(10),
                InkWell(
                  onTap: () => BottomPicker.dateTime(
                    onSubmit: (value) {
                      // value as DateTime;
                      setState(() {
                        _scheduleController.text = value.toString();
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
                          text: 'Apply',
                          color: Colors.white,
                        )),
                    dismissable: true,
                    titleAlignment: Alignment.center,
                    pickerTitle: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: 'First Schedule',
                          size: AppSizes.body,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ).show(context),
                  child: Ink(
                    child: AppTextFormField(
                      hintStyleColor: Colors.black,
                      controller: _scheduleController,
                      enabled: false,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                const AppText(
                  text: 'Frequency',
                  size: AppSizes.body,
                ),
                const Gap(10),
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              // horizontal:
                              AppSizes.horizontalPaddingSmall),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                  child: AppText(
                                text: 'Frequency',
                                size: AppSizes.body,
                                weight: FontWeight.w600,
                              )),
                              const Gap(5),
                              const Divider(),
                              const Gap(15),
                              ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final option = _frequencyOptions[index];
                                  return AppRadioListTile(
                                      padding: EdgeInsets.zero,
                                      groupValue: 'frequency',
                                      value: option);
                                },
                                itemCount: _frequencyOptions.length,
                              ),
                              const Gap(15),
                              AppButton(
                                text: 'Apply',
                                callback: () =>
                                    navigatorKey.currentState!.pop(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  child: Ink(
                    child: AppTextFormField(
                      hintStyleColor: Colors.black,
                      controller: _frequencyController,
                      enabled: false,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: 'End date',
                      ),
                      Switch(
                        value: _endDate,
                        onChanged: (value) {
                          setState(() {
                            _endDate = value;
                          });
                        },
                      ),
                    ]),
                const Gap(20),
                const Divider(),
                if (_endDate)
                  Column(
                    children: [
                      const Gap(10),
                      InkWell(
                        onTap: () => BottomPicker.date(
                          dateOrder: DatePickerDateOrder.dmy,
                          onSubmit: (value) {
                            // value as DateTime;
                            setState(() {
                              _endDateController.text = value.toString();
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
                                text: 'Apply',
                                color: Colors.white,
                              )),
                          dismissable: true,
                          titleAlignment: Alignment.center,
                          pickerTitle: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                text: 'Select end date',
                                size: AppSizes.body,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ).show(context),
                        child: Ink(
                          child: AppTextFormField(
                            hintStyleColor: Colors.black,
                            controller: _endDateController,
                            enabled: false,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const Gap(10),
                (_selectedFrequency == null && _selectedSchedule == null)
                    ? const AppText(
                        text:
                            "Once you set up recurring orders at the frequency of your choice with the 'Pay for everybody' option, you'll be charged at your scheduled delivery times for any items placed in the cart for each order, including items added by your guests, so the charge each time will likely vary. You may cancel at any time until the store starts preparing your order.")
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedFrequency = null;
                            _selectedSchedule = null;
                          });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: AppColors.neutral300),
                        child: const AppText(
                          text: 'Turn off repeat order',
                          color: Colors.redAccent,
                        ),
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
