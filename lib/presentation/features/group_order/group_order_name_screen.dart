import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../main.dart';

class GroupOrderNameScreen extends ConsumerStatefulWidget {
  final String orderName;
  const GroupOrderNameScreen(this.orderName, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderNameScreenState();
}

class _GroupOrderNameScreenState extends ConsumerState<GroupOrderNameScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.orderName;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                  text: 'Name your order',
                  size: AppSizes.heading6,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                const AppText(text: 'Example: Halloween lunch party'),
                const Gap(20),
                AppTextFormField(
                  controller: _nameController,
                  suffixIcon: _nameController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _nameController.clear();
                            });
                          },
                          child: const Icon(Icons.cancel))
                      : null,
                ),
              ],
            ),
            Column(
              children: [
                AppButton(
                  text: 'Save',
                  callback: () {
                    navigatorKey.currentState!.pop(_nameController.text);
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
