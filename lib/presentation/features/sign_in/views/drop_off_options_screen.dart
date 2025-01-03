import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../constants/app_sizes.dart';

class DropOffOptionsScreen extends ConsumerStatefulWidget {
  const DropOffOptionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DropOffOptionsScreenState();
}

class _DropOffOptionsScreenState extends ConsumerState<DropOffOptionsScreen> {
  final String _groupValue1 = 'Hand it to me';
  final String _groupValue2 = 'Leave at location';

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
            SingleChildScrollView(
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
                  const AppText(text: 'Deliver to 1226 University Dr.'),
                  const Gap(15),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      showTrailingIcon: false,
                      // tilePadding: EdgeInsets.zero,
                      title: AppText(
                        text: _groupValue1,
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
                      children: [
                        AppRadioListTile(
                          groupValue1: _groupValue1,
                          value: 'Meet at my door',
                        ),
                        AppRadioListTile(
                          groupValue1: _groupValue1,
                          value: 'Meet outside',
                        ),
                        AppRadioListTile(
                          groupValue1: _groupValue1,
                          value: 'Meet in the lobby',
                        ),
                        // ListTile(
                        //   title: AppText(text: 'Meet at my door'),
                        //   trailing: Rad,
                        // )
                      ],
                    ),
                  ),
                  const Gap(15),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      showTrailingIcon: false,
                      // tilePadding: EdgeInsets.zero,
                      title: AppText(
                        text: _groupValue2,
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
                      children: [
                        AppRadioListTile(
                          groupValue1: _groupValue1,
                          value: 'Meet at my door',
                        ),
                        AppRadioListTile(
                          groupValue1: _groupValue1,
                          value: 'Meet outside',
                        ),
                        AppRadioListTile(
                          groupValue1: _groupValue1,
                          value: 'Meet in the lobby',
                        ),
                        // ListTile(
                        //   title: AppText(text: 'Meet at my door'),
                        //   trailing: Rad,
                        // )
                      ],
                    ),
                  ),
                  const Gap(15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: 'Instructions for delivery person',
                        size: AppSizes.body,
                      ),
                      AppTextBadge(text: 'Needs review')
                    ],
                  ),
                  const Gap(20),
                  const AppTextFormField(
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
            const AppButton(
              text: 'Update',
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
    required String groupValue1,
    required String value,
  })  : _groupValue1 = groupValue1,
        _value = value;
  final String _groupValue1;
  final String _value;

  @override
  State<AppRadioListTile> createState() => _AppRadioListTileState();
}

class _AppRadioListTileState extends State<AppRadioListTile> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile.adaptive(
      splashRadius: 15,
      controlAffinity: ListTileControlAffinity.trailing,
      // contentPadding: EdgeInsets.zero,
      value: widget._value,
      title: AppText(text: widget._value),
      groupValue: widget._groupValue1,
      onChanged: (value) {},
    );
  }
}
