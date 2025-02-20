import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../constants/app_sizes.dart';
import '../../../core/app_colors.dart';

class DropOffOptionsScreen extends ConsumerStatefulWidget {
  final String selectedGroupValue;
  final String instructions;
  final String placeDescription;
  const DropOffOptionsScreen({
    required this.selectedGroupValue,
    required this.instructions,
    required this.placeDescription,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DropOffOptionsScreenState();
}

class _DropOffOptionsScreenState extends ConsumerState<DropOffOptionsScreen> {
  String? _groupValue1;
  String? _groupValue2;
  final List<String> _group1 = [
    'Meet at my door',
    'Meet outside',
    'Meet in the lobby'
  ];
  final List<String> _group2 = [
    'Leave at my door',
    'Leave at building reception'
  ];

  late String _selectedOption;
  late final ExpansionTileController _group1Controller;
  late final ExpansionTileController _group2Controller;
  Timer? _debounce;
  final _instructionsController = TextEditingController();
  final String _option1 = 'Hand it to me';
  final String _option2 = 'Leave at location';
  late final String _formattedPlaceDescription;

  @override
  void initState() {
    super.initState();
    if (_group1.contains(widget.selectedGroupValue)) {
      _groupValue1 = widget.selectedGroupValue;
      _selectedOption = _option1;
    } else {
      _groupValue2 = widget.selectedGroupValue;
      _selectedOption = _option2;
    }

    _group1Controller = ExpansionTileController();
    _group2Controller = ExpansionTileController();
    var strings = widget.placeDescription.split(',');
    _formattedPlaceDescription = '${strings[0]}, ${strings[1]}';
    _instructionsController.text = widget.instructions;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            child: InkWell(
              child: Ink(
                child: const Icon(
                  Icons.info_outline,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.horizontalPaddingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      text: 'Dropoff options',
                      size: AppSizes.heading5,
                      weight: FontWeight.w600,
                    ),
                    const Gap(10),
                    AppText(text: 'Deliver to $_formattedPlaceDescription'),
                    const Gap(15),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: _selectedOption == _option1
                                  ? Colors.black
                                  : AppColors.neutral300),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                          controller: _group1Controller,
                          onExpansionChanged: (expanded) {
                            if (expanded) {
                              _group2Controller.collapse();

                              setState(() {
                                _selectedOption = _option1;
                                // _groupValue2 = null;
                              });
                            }
                          },
                          enabled: true,
                          initiallyExpanded: _selectedOption == _option1,
                          childrenPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          showTrailingIcon: false,
                          // tilePadding: EdgeInsets.zero,
                          title: AppText(
                            text: _option1,
                            size: AppSizes.bodySmall,
                            weight: FontWeight.bold,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              AssetNames.handToMe,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          children: _group1
                              .map(
                                (e) => RadioListTile.adaptive(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: e,
                                  title: AppText(text: e),
                                  groupValue: _groupValue1,
                                  onChanged: (value) {
                                    setState(() {
                                      _groupValue1 = value;
                                    });
                                  },
                                ),
                              )
                              .toList()),
                    ),
                    const Gap(15),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: _selectedOption == _option2
                                  ? Colors.black
                                  : AppColors.neutral300),
                          borderRadius: BorderRadius.circular(10)),
                      child: ExpansionTile(
                          initiallyExpanded: _selectedOption == _option2,
                          onExpansionChanged: (expanded) {
                            if (expanded) {
                              _group1Controller.collapse();

                              setState(() {
                                _selectedOption = _option2;
                                // _groupValue1 = null;
                              });
                            }
                          },
                          controller: _group2Controller,
                          childrenPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          showTrailingIcon: false,
                          // tilePadding: EdgeInsets.zero,
                          title: AppText(
                            text: _option2,
                            weight: FontWeight.bold,
                            size: AppSizes.bodySmall,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              AssetNames.bagDoorstep,
                              width: 30,
                              height: 30,
                              fit: BoxFit.fill,
                            ),
                          ),
                          children: _group2
                              .map(
                                (e) => RadioListTile.adaptive(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: e,
                                  title: AppText(text: e),
                                  groupValue: _groupValue2,
                                  onChanged: (value) {
                                    setState(() {
                                      _groupValue2 = value;
                                    });
                                  },
                                ),
                              )
                              .toList()),
                    ),
                    const Gap(15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Instructions for delivery person',
                          size: AppSizes.bodySmall,
                        ),
                        AppTextBadge(text: 'Needs review')
                      ],
                    ),
                    const Gap(20),
                    AppTextFormField(
                      onChanged: (value) async {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 500), () {
                          setState(() {});
                        });
                      },
                      suffixIcon: Visibility(
                        //TODO: add if it is in focus so it disappears when not in focus
                        visible: _instructionsController.text.isNotEmpty,
                        child: GestureDetector(
                            onTap: () => _instructionsController.clear(),
                            child: const Icon(Icons.cancel)),
                      ),
                      controller: _instructionsController,
                      minLines: 4,

                      maxLines: 15,
                      // textAlign: TextAlign.start,
                      // height: 50,
                      hintText:
                          'Example: Please knock instead of using the doorbell',
                    ),
                  ],
                ),
              ),
            ),
            //TODO: maybe use insets to handle when keyboard pops up and using spacebetween
            const Gap(30),
            AppButton(
              text: 'Update',
              callback: () {
                if (_groupValue1 == null && _groupValue2 == null) {
                  showInfoToast('Please select a sub-option', context: context);
                  return;
                }
                navigatorKey.currentState!.pop([
                  _selectedOption == _option1 ? _groupValue1 : _groupValue2,
                  _instructionsController.text
                ]);
              },
            )
          ],
        ),
      ),
    );
  }
}

class AppRadioListTile extends StatefulWidget {
  const AppRadioListTile({
    super.key,
    required String? groupValue,
    EdgeInsets? padding,
    String? subtitle,
    ListTileControlAffinity? controlAffinity,
    Widget? secondary,
    required String value,
    Function(String? value)? onChanged,
  })  : _groupValue1 = groupValue,
        _onChanged = onChanged,
        _subtitle = subtitle,
        _secondary = secondary,
        _controlAffinity = controlAffinity,
        _padding = padding,
        _value = value;
  final String? _groupValue1;
  final String _value;
  final Function(String? value)? _onChanged;
  final ListTileControlAffinity? _controlAffinity;
  final String? _subtitle;
  final EdgeInsets? _padding;
  final Widget? _secondary;

  @override
  State<AppRadioListTile> createState() => _AppRadioListTileState();
}

class _AppRadioListTileState extends State<AppRadioListTile> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile.adaptive(
      subtitle:
          widget._subtitle != null ? AppText(text: widget._subtitle!) : null,
      splashRadius: 15,
      controlAffinity:
          widget._controlAffinity ?? ListTileControlAffinity.trailing,
      contentPadding: widget._padding,
      // contentPadding: EdgeInsets.zero,
      value: widget._value,
      secondary: widget._secondary,
      title: AppText(text: widget._value),
      groupValue: widget._groupValue1,
      onChanged: widget._onChanged,
    );
  }
}

class AppCheckboxListTile extends StatefulWidget {
  const AppCheckboxListTile({
    super.key,
    required String value,
    ListTileControlAffinity? controlAffinity,
    required Function(bool? value) onChanged,
    required List<String> selectedOptions,
  })  : _value = value,
        _onChanged = onChanged,
        _controlAffinity = controlAffinity,
        _selectedOptions = selectedOptions;

  final String _value;
  final Function(bool? value) _onChanged;
  final List<String> _selectedOptions;
  final ListTileControlAffinity? _controlAffinity;

  @override
  State<AppCheckboxListTile> createState() => _AppCheckboxListTileState();
}

class _AppCheckboxListTileState extends State<AppCheckboxListTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile.adaptive(
      splashRadius: 15,
      controlAffinity:
          widget._controlAffinity ?? ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      value: widget._selectedOptions.contains(widget._value),
      title: AppText(text: widget._value),
      onChanged: widget._onChanged,
    );
  }
}
