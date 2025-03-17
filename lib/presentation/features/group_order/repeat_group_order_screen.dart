import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../main.dart';
import '../../core/app_colors.dart';

class RepeatGroupOrderScreen extends ConsumerStatefulWidget {
  final DateTime? orderByDeadline;
  final DateTime? endDate;
  final String? frequency;
  const RepeatGroupOrderScreen({
    super.key,
    required this.endDate,
    required this.frequency,
    required this.orderByDeadline,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RepeatGroupOrderScreenState();
}

class _RepeatGroupOrderScreenState
    extends ConsumerState<RepeatGroupOrderScreen> {
  final _scheduleController = TextEditingController();
  final _frequencyController = TextEditingController();

  String? _selectedFrequency;

  bool _endDateEnabled = false;

  final _endDateController = TextEditingController();

  DateTime? _firstOrderSchedule;
  DateTime? _endDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstOrderSchedule = widget.orderByDeadline == null
        ? DateTime.now().add(const Duration(hours: 2))
        : widget.orderByDeadline!.add(const Duration(hours: 2));
    _scheduleController.text =
        '${AppFunctions.formatDate(_firstOrderSchedule.toString(), format: 'l, M d • g:i A')} - ${AppFunctions.formatDate(_firstOrderSchedule!.add(const Duration(minutes: 30)).toString(), format: 'g:i A')}';
    // _selectedFrequency = widget.frequency;
    _frequencyController.text = widget.frequency ?? '';
    _selectedFrequency = widget.frequency;
    _endDate = widget.endDate;
    _endDateEnabled = widget.endDate != null;
    if (widget.endDate != null) {
      _endDateController.text = AppFunctions.formatDate(
          widget.endDate.toString(),
          format: 'D, M d, Y');
    }
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    _frequencyController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> frequencyOptions = [
      'Daily',
      'Every weekday (Mon-Fri)',
      'Weekly on ${AppFunctions.formatDate(_firstOrderSchedule.toString(), format: 'l')}',
      'Bi-weekly on ${AppFunctions.formatDate(_firstOrderSchedule.toString(), format: 'l')}',
      'Monthly on First ${AppFunctions.formatDate(_firstOrderSchedule.toString(), format: 'l')}'
    ];
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
                const Gap(10),
                const AppText(
                    size: AppSizes.bodySmall,
                    color: AppColors.neutral500,
                    text:
                        'Select how often you want to place this group order. Everyone gets to choose their own items each time.'),
                const Gap(20),
                const AppText(
                  text: 'First order scheduled for',
                  size: AppSizes.bodySmall,
                ),
                const Gap(10),
                AppTextFormField(
                  controller: _scheduleController,
                  onTap: () => BottomPicker.dateTime(
                    onSubmit: (value) {
                      if (value is DateTime &&
                          value.difference(DateTime.now()) >=
                              const Duration(hours: 2)) {
                        setState(() {
                          _firstOrderSchedule = value;

                          _scheduleController.text =
                              '${AppFunctions.formatDate(value.toString(), format: 'l, M d • g:i A')} - ${AppFunctions.formatDate(value.add(const Duration(minutes: 30)).toString(), format: 'g:i A')}';
                        });
                      } else if (value.difference(DateTime.now()) <
                          const Duration(hours: 1)) {
                        showInfoToast(
                            'The time you set must be at least two hours from now',
                            context: context);
                      }
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
                          size: AppSizes.bodySmall,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ).show(context),
                  readOnly: true,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
                const Gap(20),
                const AppText(
                  text: 'Frequency',
                  size: AppSizes.bodySmall,
                ),
                const Gap(10),
                AppTextFormField(
                  hintText: 'Choose a frequency',
                  readOnly: true,
                  controller: _frequencyController,
                  onTap: () async => await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      var temp = _selectedFrequency;
                      return StatefulBuilder(builder: (context, setState) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Gap(10),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                child: Center(
                                    child: AppText(
                                  text: 'Frequency',
                                  size: AppSizes.body,
                                  weight: FontWeight.w600,
                                )),
                              ),
                              const Gap(5),
                              const Divider(),
                              const Gap(15),
                              ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final option = frequencyOptions[index];
                                  return RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: AppText(text: option),
                                      onChanged: (value) {
                                        setState(() {
                                          temp = value;
                                        });
                                      },
                                      groupValue: temp,
                                      value: option);
                                },
                                itemCount: frequencyOptions.length,
                              ),
                              const Gap(15),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppSizes.horizontalPaddingSmall),
                                child: AppButton(
                                  text: 'Apply',
                                  callback: () {
                                    navigatorKey.currentState!.pop();
                                    _updateFrequencySelectedFromModal(temp);
                                  },
                                ),
                              ),
                              const Gap(10)
                            ],
                          ),
                        );
                      });
                    },
                  ),

                  // enabled: false,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
                const Gap(20),
                if (_selectedFrequency != null)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          text: 'End date',
                        ),
                        Switch.adaptive(
                          value: _endDateEnabled,
                          onChanged: (value) {
                            setState(() {
                              _endDateEnabled = value;
                            });
                          },
                        ),
                      ]),
                const Gap(20),
                const Divider(),
                if (_endDateEnabled)
                  Column(
                    children: [
                      const Gap(10),
                      Form(
                        key: _formKey,
                        child: AppTextFormField(
                          validator: FormBuilderValidators.required(
                              errorText:
                                  'Provide an end date or turn off end date'),
                          hintText: 'Pick an end date',
                          controller: _endDateController,
                          readOnly: true,
                          onTap: () => BottomPicker.date(
                            dateOrder: DatePickerDateOrder.dmy,
                            onSubmit: (value) {
                              //TODO: guard against the change of year to a past year for all date pickers of group order screens

                              setState(() {
                                _endDate = value;
                                _endDateController.text =
                                    AppFunctions.formatDate(value.toString(),
                                        format: 'D, M d, Y');
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
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                const Gap(10),
                (_selectedFrequency == null)
                    ? const AppText(
                        text:
                            "Once you set up recurring orders at the frequency of your choice with the 'Pay for everybody' option, you'll be charged at your scheduled delivery times for any items placed in the cart for each order, including items added by your guests, so the charge each time will likely vary. You may cancel at any time until the store starts preparing your order.")
                    : AppButton(
                        callback: () {
                          navigatorKey.currentState!.pop({
                            'firstOrderSchedule': null,
                            'frequency': null,
                            'endDate': null
                          });
                          setState(() {
                            // _selectedFrequency = null;
                            // _frequencyController.clear();
                            // _endDateEnabled = false;
                          });
                        },
                        buttonColor: AppColors.neutral200,
                        textColor: Colors.red.shade900,
                        text: 'Turn off repeat order',
                      ),
              ],
            ),
            Column(
              children: [
                AppButton(
                  text: 'Save',
                  callback:
                      _firstOrderSchedule == null || _selectedFrequency == null
                          ? null
                          : () {
                              if (_endDateEnabled) {
                                if (_formKey.currentState!.validate()) {
                                  navigatorKey.currentState!.pop({
                                    'firstOrderSchedule': _firstOrderSchedule,
                                    'frequency': _selectedFrequency,
                                    'endDate': _endDate
                                  });
                                }
                              } else {
                                navigatorKey.currentState!.pop({
                                  'firstOrderSchedule': _firstOrderSchedule,
                                  'frequency': _selectedFrequency,
                                  'endDate': _endDate
                                });
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

  void _updateFrequencySelectedFromModal(String? temp) {
    setState(() {
      if (temp != null) {
        _selectedFrequency = temp;
        _frequencyController.text = temp;
      }
    });
  }
}
