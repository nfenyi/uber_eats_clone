import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

class GroupOrderNameScreen extends ConsumerStatefulWidget {
  const GroupOrderNameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupOrderNameScreenState();
}

class _GroupOrderNameScreenState extends ConsumerState<GroupOrderNameScreen> {
  final _controller = TextEditingController();

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
                  text: 'Name your order',
                  size: AppSizes.heading6,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                const AppText(text: 'Example: Halloween lunch party'),
                const Gap(20),
                AppTextFormField(
                  //TODO: fix trailing icon not appearing
                  suffixIcon: _controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.clear();
                            });
                          },
                          child: const Icon(FontAwesomeIcons.circleXmark))
                      : null,
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
