import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../models/store/store_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';

class SubOptionSelectionScreen extends StatefulWidget {
  final Option option;

  final double productPrice;

  const SubOptionSelectionScreen(
      {super.key, required this.option, required this.productPrice});

  @override
  State<SubOptionSelectionScreen> createState() =>
      _SubOptionSelectionScreenState();
}

class _SubOptionSelectionScreenState extends State<SubOptionSelectionScreen> {
  final List<SubOption> _canBeMultipleOptions = [];
  final List<SubOption> _singleOptions = [];
  late final List<int> _subOptionQuantities;
  late final List<bool?> _subOptionalOptions;
  double _subOptionsTotal = 0;

  @override
  void initState() {
    super.initState();

    //for listtilecheckboxes
    _subOptionalOptions = List.generate(
        widget.option.subOptions!.length, (index) => false,
        growable: false);

    if (widget.option.subOptions!.any(
      (element) => element.canBeMultiple,
    )) {
      //for listtiles with quantity incrementor and decrementor
      _subOptionQuantities = List.generate(
          widget.option.subOptions!.length, (index) => 0,
          growable: false);
    }

    for (var i = 0; i < widget.option.subOptions!.length; i++) {
      final subOption = widget.option.subOptions![i];
      if (subOption.canBeMultiple) {
        _canBeMultipleOptions.add(subOption);
      } else {
        _singleOptions.add(subOption);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(
            text: widget.option.name,
            size: AppSizes.heading6,
          ),
          elevation: 0.5,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    if (_canBeMultipleOptions.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.horizontalPaddingSmall),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: '${widget.option.name} Comes With',
                                      size: AppSizes.heading6,
                                      weight: FontWeight.bold,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final subOption =
                                            _canBeMultipleOptions[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          trailing: _subOptionQuantities[
                                                      index] ==
                                                  0
                                              ? TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      backgroundColor:
                                                          AppColors.neutral100,
                                                      shape:
                                                          const CircleBorder()),
                                                  onPressed: () {
                                                    setState(() {
                                                      _subOptionQuantities[
                                                              index] =
                                                          _subOptionQuantities[
                                                                  index] +
                                                              1;
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
                                                                      .all(3),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .neutral100,
                                                              shape:
                                                                  const CircleBorder()),
                                                          onPressed: () {
                                                            if (_subOptionQuantities[
                                                                    index] !=
                                                                0) {
                                                              setState(() {
                                                                _subOptionQuantities[
                                                                        index] =
                                                                    _subOptionQuantities[
                                                                            index] -
                                                                        1;
                                                                if (subOption
                                                                        .price !=
                                                                    null) {
                                                                  _subOptionsTotal -=
                                                                      subOption
                                                                          .price!;
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: const AppText(
                                                              text: '-',
                                                              size: AppSizes
                                                                  .body)),
                                                      AppText(
                                                          text:
                                                              _subOptionQuantities[
                                                                      index]
                                                                  .toString()),
                                                      TextButton(
                                                          style: TextButton.styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .neutral100,
                                                              shape:
                                                                  const CircleBorder()),
                                                          onPressed: subOption
                                                                          .canBeMultipleLimit ==
                                                                      null ||
                                                                  _subOptionQuantities[
                                                                          index] <
                                                                      subOption
                                                                          .canBeMultipleLimit!
                                                              ? () {
                                                                  if (_subOptionQuantities[
                                                                          index] !=
                                                                      0) {
                                                                    setState(
                                                                        () {
                                                                      _subOptionQuantities[
                                                                              index] =
                                                                          _subOptionQuantities[index] +
                                                                              1;
                                                                      if (subOption
                                                                              .price !=
                                                                          null) {
                                                                        _subOptionsTotal +=
                                                                            subOption.price!;
                                                                      }
                                                                    });
                                                                  }
                                                                }
                                                              : null,
                                                          child: const AppText(
                                                              text: '+',
                                                              size: AppSizes
                                                                  .body)),
                                                    ]),
                                          title: AppText(
                                            text: subOption.name,
                                          ),
                                          subtitle: subOption.price != null ||
                                                  subOption.calories != null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (subOption.price != null)
                                                      AppText(
                                                        text:
                                                            '+  ${_subOptionQuantities[index] == 0 ? '\$${subOption.price}' : '\$${subOption.price! * _subOptionQuantities[index]} (\$${subOption.price!.toStringAsFixed(2)} ea)'} ',
                                                        color: AppColors
                                                            .neutral500,
                                                      ),
                                                    if (subOption.calories !=
                                                        null)
                                                      AppText(
                                                        text:
                                                            '${subOption.calories!.toInt()} Cal.',
                                                        color: AppColors
                                                            .neutral500,
                                                      ),
                                                  ],
                                                )
                                              : null,
                                        );
                                      },
                                      itemCount: _canBeMultipleOptions.length,
                                    )
                                  ])),
                          if (_canBeMultipleOptions.isNotEmpty &&
                              _singleOptions.isNotEmpty)
                            const Divider(
                              thickness: 3,
                            ),
                          if (_singleOptions.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppSizes.horizontalPaddingSmall),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text:
                                                '${widget.option.name} Additions',
                                            size: AppSizes.heading6,
                                            weight: FontWeight.bold,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final subOption =
                                                  _singleOptions[index];
                                              return CheckboxListTile.adaptive(
                                                contentPadding: EdgeInsets.zero,
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .trailing,
                                                title: AppText(
                                                  text: subOption.name,
                                                ),
                                                subtitle: subOption.price !=
                                                            null ||
                                                        subOption.calories !=
                                                            null
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (subOption.price !=
                                                              null)
                                                            AppText(
                                                              text:
                                                                  '+ \$${subOption.price}',
                                                              color: AppColors
                                                                  .neutral500,
                                                            ),
                                                          if (subOption
                                                                  .calories !=
                                                              null)
                                                            AppText(
                                                              text:
                                                                  '${subOption.calories!.toInt()} Cal.',
                                                              color: AppColors
                                                                  .neutral500,
                                                            ),
                                                        ],
                                                      )
                                                    : null,
                                                value:
                                                    _subOptionalOptions[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _subOptionalOptions[index] =
                                                        value;
                                                    if (subOption.price !=
                                                        null) {
                                                      if (value == true) {
                                                        _subOptionsTotal +=
                                                            subOption.price!;
                                                      } else if (value ==
                                                          false) {
                                                        _subOptionsTotal -=
                                                            subOption.price!;
                                                      }
                                                    }
                                                  });
                                                },
                                              );
                                            },
                                            itemCount:
                                                _canBeMultipleOptions.length,
                                          )
                                        ])),
                              ],
                            )
                        ],
                      ),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppButton(
                  callback: () {
                    navigatorKey.currentState!.pop();
                  },
                  text: 'Done • \$${widget.productPrice + _subOptionsTotal}'),
            ),
            const Gap(10),
          ],
        ));
  }
}
