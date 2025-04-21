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
  final Option option;
  final HiveCartProduct? productInbox;

  final double currentTotal;

  const SubOptionSelectionScreen(
      {super.key,
      required this.option,
      required this.currentTotal,
      required this.productInbox});

  @override
  State<SubOptionSelectionScreen> createState() =>
      _SubOptionSelectionScreenState();
}

class _SubOptionSelectionScreenState extends State<SubOptionSelectionScreen> {
  HiveCartProduct? _productInbox;

  final Map<String, List<HiveOption>> _options = {};
  List<int> _optionQuantities = [];

  // late final List<int> _subOptionQuantities;
  // late final List<bool?> _subOptionalOptions;
  double _subOptionsTotal = 0;

  @override
  void initState() {
    super.initState();
    final subOptionInBox = _productInbox!.requiredOptions.firstWhereOrNull(
          (requiredOption) => requiredOption.name == widget.option.name,
        ) ??
        _productInbox!.requiredOptions.firstWhere(
          (optionalOption) => optionalOption.name == widget.option.name,
        );
    final options = subOptionInBox.options!;
    if (_productInbox != null) {
      for (var storedOptions in options) {
        if (_options[storedOptions.categoryName] == null) {
          _options[storedOptions.categoryName] = [storedOptions];
        } else {
          _options[storedOptions.categoryName]!.add(storedOptions);
        }
        _optionQuantities.add(storedOptions.quantity);
      }
    } else {
      _optionQuantities = List.generate(
          widget.option.subOptions.length, (index) => 0,
          growable: false);
    }

    // //for listtilecheckboxes
    // _subOptionalOptions = List.generate(
    //     widget.option.subOptions.length, (index) => false,
    //     growable: false);

    // if (widget.option.subOptions.any(
    //   (element) => element.canBeMultiple,
    // )) {
    //   //for listtiles with quantity incrementor and decrementor
    //   _subOptionQuantities = List.generate(
    //       widget.option.subOptions.length, (index) => 0,
    //       growable: false);
    // }

    // for (var i = 0; i < widget.option.subOptions.length; i++) {
    //   final subOption = widget.option.subOptions[i];
    //   if (subOption.canBeMultiple) {
    //     _canBeMultipleOptions.add(subOption);
    //   } else {
    //     _singleOptions.add(subOption);
    //   }
    // }
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
            CustomScrollView(slivers: [
              //  SingleChildScrollView(
              //     child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //       if (_canBeMultipleOptions.isNotEmpty)
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Padding(
              //                 padding: const EdgeInsets.symmetric(
              //                     horizontal: AppSizes.horizontalPaddingSmall),
              //                 child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       AppText(
              //                         text: '${widget.option.name} Comes With',
              //                         size: AppSizes.heading6,
              //                         weight: FontWeight.bold,
              //                       ),
              //                       ListView.builder(
              //                         shrinkWrap: true,
              //                         itemBuilder: (context, index) {
              //                           final subOption =
              //                               _canBeMultipleOptions[index];
              //                           return ListTile(
              //                             contentPadding: EdgeInsets.zero,
              //                             trailing: _subOptionQuantities[
              //                                         index] ==
              //                                     0
              //                                 ? TextButton(
              //                                     style: TextButton.styleFrom(
              //                                         padding:
              //                                             const EdgeInsets.all(
              //                                                 0),
              //                                         backgroundColor:
              //                                             AppColors.neutral100,
              //                                         shape:
              //                                             const CircleBorder()),
              //                                     onPressed: () {
              //                                       setState(() {
              //                                         _subOptionQuantities[
              //                                                 index] =
              //                                             _subOptionQuantities[
              //                                                     index] +
              //                                                 1;
              //                                       });
              //                                     },
              //                                     child: const AppText(
              //                                       text: '+',
              //                                       size: AppSizes.body,
              //                                     ))
              //                                 : Row(
              //                                     mainAxisSize:
              //                                         MainAxisSize.min,
              //                                     children: [
              //                                         TextButton(
              //                                             style: TextButton.styleFrom(
              //                                                 padding:
              //                                                     const EdgeInsets
              //                                                         .all(3),
              //                                                 backgroundColor:
              //                                                     AppColors
              //                                                         .neutral100,
              //                                                 shape:
              //                                                     const CircleBorder()),
              //                                             onPressed: () {
              //                                               if (_subOptionQuantities[
              //                                                       index] !=
              //                                                   0) {
              //                                                 setState(() {
              //                                                   _subOptionQuantities[
              //                                                           index] =
              //                                                       _subOptionQuantities[
              //                                                               index] -
              //                                                           1;
              //                                                   if (subOption
              //                                                           .price !=
              //                                                       null) {
              //                                                     _subOptionsTotal -=
              //                                                         subOption
              //                                                             .price!;
              //                                                   }
              //                                                 });
              //                                               }
              //                                             },
              //                                             child: const AppText(
              //                                                 text: '-',
              //                                                 size: AppSizes
              //                                                     .body)),
              //                                         AppText(
              //                                             text:
              //                                                 _subOptionQuantities[
              //                                                         index]
              //                                                     .toString()),
              //                                         TextButton(
              //                                             style: TextButton.styleFrom(
              //                                                 padding:
              //                                                     const EdgeInsets
              //                                                         .all(3),
              //                                                 backgroundColor:
              //                                                     AppColors
              //                                                         .neutral100,
              //                                                 shape:
              //                                                     const CircleBorder()),
              //                                             onPressed: subOption
              //                                                             .canBeMultipleLimit ==
              //                                                         null ||
              //                                                     _subOptionQuantities[
              //                                                             index] <
              //                                                         subOption
              //                                                             .canBeMultipleLimit!
              //                                                 ? () {
              //                                                     if (_subOptionQuantities[
              //                                                             index] !=
              //                                                         0) {
              //                                                       setState(
              //                                                           () {
              //                                                         _subOptionQuantities[
              //                                                                 index] =
              //                                                             _subOptionQuantities[index] +
              //                                                                 1;
              //                                                         if (subOption
              //                                                                 .price !=
              //                                                             null) {
              //                                                           _subOptionsTotal +=
              //                                                               subOption.price!;
              //                                                         }
              //                                                       });
              //                                                     }
              //                                                   }
              //                                                 : null,
              //                                             child: const AppText(
              //                                                 text: '+',
              //                                                 size: AppSizes
              //                                                     .body)),
              //                                       ]),
              //                             title: AppText(
              //                               text: subOption.name,
              //                             ),
              //                             subtitle: subOption.price != null ||
              //                                     subOption.calories != null
              //                                 ? Column(
              //                                     crossAxisAlignment:
              //                                         CrossAxisAlignment.start,
              //                                     children: [
              //                                       if (subOption.price != null)
              //                                         AppText(
              //                                           text:
              //                                               '+  ${_subOptionQuantities[index] == 0 ? '\$${subOption.price}' : '\$${subOption.price! * _subOptionQuantities[index]} (\$${subOption.price!.toStringAsFixed(2)} ea)'} ',
              //                                           color: AppColors
              //                                               .neutral500,
              //                                         ),
              //                                       if (subOption.calories !=
              //                                           null)
              //                                         AppText(
              //                                           text:
              //                                               '${subOption.calories!.toInt()} Cal.',
              //                                           color: AppColors
              //                                               .neutral500,
              //                                         ),
              //                                     ],
              //                                   )
              //                                 : null,
              //                           );
              //                         },
              //                         itemCount: _canBeMultipleOptions.length,
              //                       )
              //                     ])),
              //             if (_canBeMultipleOptions.isNotEmpty &&
              //                 _singleOptions.isNotEmpty)
              //               const Divider(
              //                 thickness: 3,
              //               ),
              //             if (_singleOptions.isNotEmpty)
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Padding(
              //                       padding: const EdgeInsets.symmetric(
              //                           horizontal:
              //                               AppSizes.horizontalPaddingSmall),
              //                       child: Column(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             AppText(
              //                               text:
              //                                   '${widget.option.name} Additions',
              //                               size: AppSizes.heading6,
              //                               weight: FontWeight.bold,
              //                             ),
              //                             ListView.builder(
              //                               shrinkWrap: true,
              //                               itemBuilder: (context, index) {
              //                                 final subOption =
              //                                     _singleOptions[index];
              //                                 return CheckboxListTile.adaptive(
              //                                   contentPadding: EdgeInsets.zero,
              //                                   controlAffinity:
              //                                       ListTileControlAffinity
              //                                           .trailing,
              //                                   title: AppText(
              //                                     text: subOption.name,
              //                                   ),
              //                                   subtitle: subOption.price !=
              //                                               null ||
              //                                           subOption.calories !=
              //                                               null
              //                                       ? Column(
              //                                           crossAxisAlignment:
              //                                               CrossAxisAlignment
              //                                                   .start,
              //                                           children: [
              //                                             if (subOption.price !=
              //                                                 null)
              //                                               AppText(
              //                                                 text:
              //                                                     '+ \$${subOption.price}',
              //                                                 color: AppColors
              //                                                     .neutral500,
              //                                               ),
              //                                             if (subOption
              //                                                     .calories !=
              //                                                 null)
              //                                               AppText(
              //                                                 text:
              //                                                     '${subOption.calories!.toInt()} Cal.',
              //                                                 color: AppColors
              //                                                     .neutral500,
              //                                               ),
              //                                           ],
              //                                         )
              //                                       : null,
              //                                   value:
              //                                       _subOptionalOptions[index],
              //                                   onChanged: (value) {
              //                                     setState(() {
              //                                       _subOptionalOptions[index] =
              //                                           value;
              //                                       if (subOption.price !=
              //                                           null) {
              //                                         if (value == true) {
              //                                           _subOptionsTotal +=
              //                                               subOption.price!;
              //                                         } else if (value ==
              //                                             false) {
              //                                           _subOptionsTotal -=
              //                                               subOption.price!;
              //                                         }
              //                                       }
              //                                     });
              //                                   },
              //                                 );
              //                               },
              //                               itemCount:
              //                                   _canBeMultipleOptions.length,
              //                             )
              //                           ])),
              //                 ],
              //               )
              //           ],
              //         ),
              //     ])),
              SliverList.separated(
                itemCount: widget.option.subOptions.length,
                itemBuilder: (context, index) {
                  final subOption = widget.option.subOptions[index];

                  return Column(
                    children: [
                      subOption.isExclusive == true
                          ? ListView.builder(
                              itemCount: subOption.options.length,
                              itemBuilder: (context, index) {
                                final option = subOption.options[index];
                                final selectedSubOption =
                                    _options[subOption.name]?.firstOrNull;
                                return Column(
                                  children: [
                                    RadioListTile.adaptive(
                                      title: AppText(text: option.name),
                                      value: option.name,
                                      groupValue: selectedSubOption,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _options[subOption.name] = [
                                              HiveOption(
                                                  name: option.name,
                                                  categoryName: subOption.name)
                                            ];
                                          });
                                        }
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      subtitle: AppText(
                                          text: subOption.price.toString()),
                                    ),
                                    if (_options[subOption.name] != null &&
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    text:
                                                        '${subOption.name} Additions',
                                                    weight: FontWeight.bold,
                                                    size: AppSizes.body,
                                                  ),
                                                  AppText(
                                                    text:
                                                        selectedSubOption.name,
                                                    color: AppColors.neutral500,
                                                  )
                                                ],
                                              ),
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
                                                text: 'Edit selections',
                                                weight: FontWeight.bold,
                                              ),
                                              trailing: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: AppColors.neutral500,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                );
                              },
                            )
                          : Builder(builder: (context) {
                              int chosenQuantity = 0;
                              return ListView.builder(
                                  itemCount: subOption.options.length,
                                  itemBuilder: (context, index) {
                                    final option = subOption.options[index];

                                    return subOption.canBeMultiple
                                        ? ListTile(
                                            trailing: _optionQuantities[
                                                        index] ==
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
                                                                        .all(3),
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
                                                            text:
                                                                _optionQuantities[
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
                                              text: subOption.name,
                                            ),
                                            subtitle: subOption.price != null ||
                                                    subOption.calories != null
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (subOption.price !=
                                                          null)
                                                        AppText(
                                                          text:
                                                              '+  ${_optionQuantities[index] == 0 ? '\$${subOption.price}' : '\$${subOption.price! * _optionQuantities[index]} (\$${subOption.price!.toStringAsFixed(2)} ea)'} ',
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
                                          )
                                        : CheckboxListTile.adaptive(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            title: AppText(
                                              text: subOption.name,
                                            ),
                                            subtitle: subOption.price != null ||
                                                    subOption.calories != null
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
                                            value: _options[subOption.name] !=
                                                    null &&
                                                _options[subOption.name]!.any(
                                                  (option) =>
                                                      option.name ==
                                                      subOption.name,
                                                ),
                                            onChanged: (value) {
                                              setState(() {
                                                if (_options[subOption.name] ==
                                                    null) {
                                                  _options[subOption.name] = [
                                                    HiveOption(
                                                        name: subOption.name,
                                                        categoryName:
                                                            subOption.name)
                                                  ];
                                                } else {
                                                  if (_options[subOption.name]!
                                                          .firstWhereOrNull(
                                                        (option) =>
                                                            option.name ==
                                                            subOption.name,
                                                      ) ==
                                                      null) {
                                                    _options[subOption.name]!
                                                        .add(HiveOption(
                                                            name:
                                                                subOption.name,
                                                            categoryName:
                                                                subOption
                                                                    .name));
                                                  } else {
                                                    _options[subOption.name]!
                                                        .removeWhere(
                                                      (option) =>
                                                          option.name ==
                                                          subOption.name,
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
              ),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: AppButton(
                  callback: () {
                    navigatorKey.currentState!.pop();
                  },
                  text: 'Done • \$${widget.currentTotal + _subOptionsTotal}'),
            ),
            const Gap(10),
          ],
        ));
  }
}
