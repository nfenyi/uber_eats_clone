import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';

class NameEditScreen extends StatefulWidget {
  const NameEditScreen({super.key});

  @override
  State<NameEditScreen> createState() => _NameEditScreenState();
}

class _NameEditScreenState extends State<NameEditScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final bool _isVerified = true;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = 'Nana';
    _lastNameController.text = 'Fenyi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AppText(
            text: 'Uber Account',
            size: AppSizes.body,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              const AppText(
                text: 'Name',
                weight: FontWeight.w600,
                size: AppSizes.heading4,
              ),
              const Gap(10),
              const AppText(
                  text:
                      'This is the name you would like other people to use when referring to you.'),
              const Gap(20),
              const AppText(
                text: 'First name',
                size: AppSizes.bodySmall,
                weight: FontWeight.w600,
              ),
              const Gap(10),
              AppTextFormField(
                controller: _firstNameController,
                suffixIcon: GestureDetector(
                    onTap: () {
                      if (_firstNameController.text.isNotEmpty) {
                        setState(() {
                          _firstNameController.clear();
                        });
                      }
                    },
                    child: const Icon(Icons.cancel)),
              ),
              const Gap(15),
              const AppText(
                text: 'Last name',
                size: AppSizes.bodySmall,
                weight: FontWeight.w600,
              ),
              const Gap(10),
              AppTextFormField(
                controller: _lastNameController,
                suffixIcon: GestureDetector(
                    onTap: () {
                      if (_lastNameController.text.isNotEmpty) {
                        setState(() {
                          _lastNameController.clear();
                        });
                      }
                    },
                    child: const Icon(Icons.cancel)),
              ),
              const Gap(100),
              AppButton(
                text: 'Update',
                callback: () {
                  navigatorKey.currentState!.pop();
                  //TODO: add circularprogressindicator
                  showInfoToast('Updating name..',
                      context: context,
                      icon: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                      ));
                  //TODO: add tick
                  showInfoToast('Name updated', context: context);
                },
              )
            ],
          ),
        ));
  }
}
