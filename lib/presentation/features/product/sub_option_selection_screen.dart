import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../hive_adapters/cart_item/cart_item_model.dart';
import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';

class SubOptionSelectionScreen extends StatefulWidget {
  final SubOption selectedSubOption;
  final List<HiveOption> hiveOptions;

  final double currentTotal;

  const SubOptionSelectionScreen({
    super.key,
    required this.selectedSubOption,
    required this.hiveOptions,
    required this.currentTotal,
  });

  @override
  State<SubOptionSelectionScreen> createState() =>
      _SubOptionSelectionScreenState();
}

class _SubOptionSelectionScreenState extends State<SubOptionSelectionScreen> {
  final Map<String, List<HiveOption>> _hiveOptions = {};
  final List<int> _optionQuantities = [];

  // late final List<int> _subOptionQuantities;
  // late final List<bool?> _subOptionalOptions;

  final _subOptionsTotalNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    // logger.d(widget.hiveOptions.first.categoryName);
    // logger.d(widget.hiveOptions.first.name);
    // logger.d(widget.hiveOptions.first.quantity);
    for (var storedOption in widget.hiveOptions) {
      if (_hiveOptions[storedOption.categoryName] == null) {
        _hiveOptions[storedOption.categoryName] = [storedOption];
      } else {
        _hiveOptions[storedOption.categoryName]!.add(storedOption);
      }
      _optionQuantities.add(storedOption.quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(
            text: widget.selectedSubOption.name,
            size: AppSizes.heading6,
          ),
          elevation: 0.5,
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(slivers: [
                SliverList.separated(
                  itemCount: widget.selectedSubOption.options.length,
                  itemBuilder: (context, index) {
                    final option = widget.selectedSubOption.options[index];
                    double? valueAddedByRadioButtonSet = option.subOptions
                        .firstWhereOrNull(
                          (element) =>
                              element.name ==
                              _hiveOptions[option.name]?.first.name,
                        )
                        ?.price;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          child: AppText(
                            text: option.name,
                            weight: FontWeight.bold,
                            size: AppSizes.body,
                          ),
                        ),
                        option.isExclusive == true
                            ? StatefulBuilder(builder: (context, setState) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: option.subOptions.length,
                                  itemBuilder: (context, index) {
                                    final subOption = option.subOptions[index];
                                    final selectedSubOption =
                                        _hiveOptions[option.name]?.firstOrNull
                                        // TODO: so that a radio is selected by default for required options if
                                        // this is the first time the user is on this screen and hasn't selected anything yet
                                        // ?? option.subOptions.first
                                        ;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RadioListTile.adaptive(
                                          title: AppText(text: subOption.name),
                                          value: subOption.name,
                                          groupValue: selectedSubOption?.name,
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _hiveOptions[option.name] = [
                                                  HiveOption(
                                                      name: subOption.name,
                                                      categoryName: option.name)
                                                ];

                                                if (valueAddedByRadioButtonSet !=
                                                    null) {
                                                  _subOptionsTotalNotifier
                                                          .value -=
                                                      valueAddedByRadioButtonSet!;
                                                  if (subOption.price != null) {
                                                    valueAddedByRadioButtonSet =
                                                        subOption.price!;
                                                    _subOptionsTotalNotifier
                                                            .value +=
                                                        subOption.price!;
                                                  } else {
                                                    valueAddedByRadioButtonSet =
                                                        null;
                                                  }
                                                } else {
                                                  if (subOption.price != null) {
                                                    _subOptionsTotalNotifier
                                                            .value +=
                                                        subOption.price!;
                                                    valueAddedByRadioButtonSet =
                                                        subOption.price!;
                                                  }
                                                }
                                              });
                                            }
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          subtitle: subOption.price == null
                                              ? null
                                              : AppText(
                                                  text:
                                                      '\$${subOption.price!.toStringAsFixed(2)}'),
                                        ),
                                        if (_hiveOptions[subOption.name] !=
                                                null &&
                                            subOption.options.isNotEmpty)
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: AppColors.neutral100,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                if (selectedSubOption != null)
                                                  const ListTile(
                                                    // onTap: () => navigatorKey
                                                    //     .currentState!
                                                    //     .push(MaterialPageRoute(
                                                    //   builder: (context) =>
                                                    //       SubOptionSelectionScreen(
                                                    //     option: subOption,
                                                    //   ),
                                                    // )),
                                                    title: AppText(
                                                      text: 'Choose selections',
                                                      weight: FontWeight.bold,
                                                    ),
                                                    trailing: Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                      color:
                                                          AppColors.neutral500,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          )
                                      ],
                                    );
                                  },
                                );
                              })
                            : StatefulBuilder(builder: (context, setState) {
                                int chosenQuantity = 0;
                                // return ListView.builder(
                                //     shrinkWrap: true,
                                //     itemCount: option.options.length,
                                //     itemBuilder: (context, index) {
                                //       final innerOption =
                                //           initialSelectedSubOption.options[index];

                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: option.subOptions.length,
                                    itemBuilder: (context, index) {
                                      final innerOption =
                                          option.subOptions[index];

                                      return innerOption.canBeMultiple
                                          ? ListTile(
                                              trailing: _optionQuantities[index] ==
                                                      0
                                                  ? TextButton(
                                                      style: TextButton.styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          backgroundColor:
                                                              AppColors
                                                                  .neutral100,
                                                          shape:
                                                              const CircleBorder()),
                                                      onPressed: chosenQuantity ==
                                                              option
                                                                  .canBeMultipleLimit
                                                          ? null
                                                          : () {
                                                              setState(() {
                                                                _optionQuantities[
                                                                    index] = 1;
                                                              });
                                                            },
                                                      child: const AppText(
                                                        text: '+',
                                                        size: AppSizes.body,
                                                      ))
                                                  : Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                          TextButton(
                                                              style: TextButton.styleFrom(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .neutral100,
                                                                  shape:
                                                                      const CircleBorder()),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _optionQuantities[
                                                                      index] -= 1;
                                                                  chosenQuantity -=
                                                                      1;
                                                                });
                                                              },
                                                              child: const AppText(
                                                                  text: '-',
                                                                  size: AppSizes
                                                                      .body)),
                                                          AppText(
                                                              text: _optionQuantities[
                                                                      index]
                                                                  .toString()),
                                                          TextButton(
                                                              style: TextButton.styleFrom(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .neutral100,
                                                                  shape:
                                                                      const CircleBorder()),
                                                              onPressed: _optionQuantities[
                                                                          index] <=
                                                                      option
                                                                          .canBeMultipleLimit!
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        _optionQuantities[
                                                                            index] += 1;
                                                                        chosenQuantity +=
                                                                            1;
                                                                      });
                                                                    }
                                                                  : null,
                                                              child: const AppText(
                                                                  text: '+',
                                                                  size: AppSizes
                                                                      .body)),
                                                        ]),
                                              title: AppText(
                                                text: innerOption.name,
                                              ),
                                              subtitle: innerOption.price !=
                                                          null ||
                                                      innerOption.calories !=
                                                          null
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (innerOption.price !=
                                                            null)
                                                          AppText(
                                                            text:
                                                                '+  ${_optionQuantities[index] == 0 ? '\$${innerOption.price!.toStringAsFixed(2)}' : '\$${innerOption.price! * _optionQuantities[index]} (\$${innerOption.price!.toStringAsFixed(2)} ea)'} ',
                                                            color: AppColors
                                                                .neutral500,
                                                          ),
                                                        if (innerOption
                                                                .calories !=
                                                            null)
                                                          AppText(
                                                            text:
                                                                '${innerOption.calories!.toInt()} Cal.',
                                                            color: AppColors
                                                                .neutral500,
                                                          ),
                                                      ],
                                                    )
                                                  : null,
                                            )
                                          : CheckboxListTile.adaptive(
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .trailing,
                                              title: AppText(
                                                text: innerOption.name,
                                              ),
                                              subtitle: innerOption.price !=
                                                          null ||
                                                      innerOption.calories !=
                                                          null
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (innerOption.price !=
                                                            null)
                                                          AppText(
                                                            text:
                                                                '+ \$${innerOption.price}',
                                                            color: AppColors
                                                                .neutral500,
                                                          ),
                                                        if (innerOption
                                                                .calories !=
                                                            null)
                                                          AppText(
                                                            text:
                                                                '${innerOption.calories!.toInt()} Cal.',
                                                            color: AppColors
                                                                .neutral500,
                                                          ),
                                                      ],
                                                    )
                                                  : null,
                                              value:
                                                  _hiveOptions[option.name] !=
                                                          null &&
                                                      _hiveOptions[option.name]!
                                                          .any(
                                                        (option) =>
                                                            option.name ==
                                                            option.name,
                                                      ),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (_hiveOptions[
                                                          innerOption.name] ==
                                                      null) {
                                                    _hiveOptions[
                                                        innerOption.name] = [
                                                      HiveOption(
                                                          name:
                                                              innerOption.name,
                                                          categoryName:
                                                              option.name)
                                                    ];
                                                  } else {
                                                    if (_hiveOptions[innerOption
                                                                .name]!
                                                            .firstWhereOrNull(
                                                          (option) =>
                                                              option.name ==
                                                              option.name,
                                                        ) ==
                                                        null) {
                                                      _hiveOptions[
                                                              innerOption.name]!
                                                          .add(HiveOption(
                                                              name: innerOption
                                                                  .name,
                                                              categoryName:
                                                                  option.name));
                                                    } else {
                                                      _hiveOptions[
                                                              innerOption.name]!
                                                          .removeWhere(
                                                        (option) =>
                                                            option.name ==
                                                            option.name,
                                                      );
                                                    }
                                                  }
                                                });
                                              },
                                            );
                                    });
                              })
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: ValueListenableBuilder(
                  valueListenable: _subOptionsTotalNotifier,
                  builder: (context, value, child) {
                    final sum = widget.currentTotal + value;
                    return AppButton(
                        callback: () {
                          // final allHiveOptionLists = <List<HiveOption>>[];
                          // for (var key in _hiveOptions.keys) {
                          //   allHiveOptionLists.add(_hiveOptions[key]!);
                          // }
                          // final temp = _hiveOptions.values.toList();

                          // logger.d(allHiveOptionLists);
                          navigatorKey.currentState!.pop(
                              [value, _hiveOptions.values.flattened.toList()]);
                        },
                        text: 'Done • \$${sum.toStringAsFixed(2)}');
                  }),
            ),
            const Gap(10),
          ],
        ));
  }
}
