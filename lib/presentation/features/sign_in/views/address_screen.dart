import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/gridicons.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/address_details_screen.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Addresses',
          size: AppSizes.body,
        ),
      ),
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
                  size: AppSizes.heading5,
                  text: 'Find what you need near you',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                const AppText(
                  size: AppSizes.body,
                  text:
                      'We use your address to help you find the best spots nearby.',
                ),
                const Gap(30),
                TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for an address',
                      filled: true,
                      fillColor: AppColors.neutral100,
                      prefixIcon: Icon(Icons.search),
                      suffixIconConstraints:
                          BoxConstraints.tightFor(height: 20),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Iconify(
                          Gridicons.cross_circle,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const Gap(10),
                const AppText(
                  text: 'Explore nearby',
                  weight: FontWeight.w600,
                  size: AppSizes.heading6,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Iconify(
                    Bi.cursor,
                    size: 15,
                  ),
                  // dense: true,
                  title: const AppText(
                    text: 'Use current location',
                    size: AppSizes.bodySmaller,
                  ),
                  trailing: AppButton2(
                    text: 'Enable',
                    callback: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const AddressDetailsScreen(),
                      ));
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppButton2 extends StatefulWidget {
  final String text;
  final VoidCallback callback;
  const AppButton2({
    required this.text,
    required this.callback,
    super.key,
  });

  @override
  State<AppButton2> createState() => _AppButton2State();
}

class _AppButton2State extends State<AppButton2> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.callback,
      style: TextButton.styleFrom(backgroundColor: AppColors.neutral100),
      child: AppText(
        text: widget.text,
      ),
    );
  }
}
