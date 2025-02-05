import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/terms_for_family_profiles_screen.dart';

import '../../../../constants/asset_names.dart';
import '../../../../core/app_colors.dart';

class NewFamilyContactScreen extends StatefulWidget {
  const NewFamilyContactScreen({super.key});

  @override
  State<NewFamilyContactScreen> createState() => _NewFamilyContactScreenState();
}

class _NewFamilyContactScreenState extends State<NewFamilyContactScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String? _selectedDOB;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'New Contact',
          size: AppSizes.heading6,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                  size: AppSizes.bodySmall,
                  text:
                      "This contact won't be saved in your device's address book."),
              const Gap(40),
              const AppText(
                text: 'First Name',
                weight: FontWeight.bold,
              ),
              const Gap(10),
              AppTextFormField(
                controller: _firstNameController,
              ),
              const Gap(20),
              const AppText(
                text: 'Last Name',
                weight: FontWeight.bold,
              ),
              const Gap(10),
              AppTextFormField(
                controller: _lastNameController,
              ),
              const Gap(20),
              const AppText(
                text: 'Phone Number',
                weight: FontWeight.bold,
              ),
              const Gap(10),
              Row(
                children: [
                  Image.asset(
                    AssetNames.usaFlag,
                    width: 30,
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                  const AppText(
                    text: '+1',
                    size: AppSizes.body,
                  ),
                  Expanded(
                    child: AppTextFormField(
                      keyboardType: const TextInputType.numberWithOptions(),
                      suffixIcon: GestureDetector(
                          onTap: () => _phoneNumberController.clear(),
                          child: const Icon(Icons.cancel)),
                      controller: _phoneNumberController,
                    ),
                  ),
                ],
              ),
              const Gap(20),
              const AppText(
                text: 'Date of birth',
                weight: FontWeight.bold,
              ),
              const Gap(10),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(10)),
                  child: AppText(
                      color: _selectedDOB == null ? AppColors.neutral500 : null,
                      text:
                          _selectedDOB == null ? 'MM/DD/YYYY' : _selectedDOB!),
                ),
              ),
              const Gap(5),
              const AppText(
                  color: AppColors.neutral500,
                  text:
                      "Teen's age must be 13 — 17. By tapping Save, you confirm that your teen agreed to share their contact information with Uber."),
              const Gap(80),
              AppButton(
                text: 'Save',
                callback: () {
                  navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => TermsForFamilyProfilesScreen(
                      familyMemberName:
                          '${_firstNameController.text} ${_lastNameController.text}',
                    ),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
