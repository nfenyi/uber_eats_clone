import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/family_profile/family_profile_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/teen/select_a_member_screen.dart';
import 'package:uber_eats_clone/presentation/features/account/screens/family_and_teens/terms_for_family_profiles_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../../../app_functions.dart';
import '../../../../core/app_colors.dart';

class NewFamilyContactScreen extends StatefulWidget {
  final Contact? contact;
  final String? selectedPhoneNumber;
  final FamilyMemberType memberType;
  const NewFamilyContactScreen(
      {required this.contact,
      required this.selectedPhoneNumber,
      required this.memberType,
      super.key});

  @override
  State<NewFamilyContactScreen> createState() => _NewFamilyContactScreenState();
}

class _NewFamilyContactScreenState extends State<NewFamilyContactScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late Country? _selectedCountry;
  Timer? _debounce;
  final _phoneNumberController = TextEditingController();
  final _selectedDOBController = TextEditingController();
  late final Iterable<Country> _countries;

  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDOB;

  @override
  void initState() {
    super.initState();
    _countries = Country.values.where(
      (country) => !(country.name.toLowerCase().contains('satellite') ||
          country.name.toLowerCase().contains('network')),
    );
    _selectedCountry = _countries.firstWhereOrNull(
          (country) =>
              country.code == Hive.box(AppBoxes.appState).get('country')!.code,
        ) ??
        _countries.first;
    if (widget.contact != null) {
      final names = widget.contact!.displayName.split(' ');
      _firstNameController.text = names.first;
      if (names.length > 1) {
        _lastNameController.text = names.last;
      }
      _phoneNumberController.text = widget.selectedPhoneNumber!;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _selectedDOBController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                const AppText(
                    color: AppColors.neutral500,
                    text:
                        "This contact won't be saved in your device's address book."),
                const Gap(40),
                const AppText(
                  text: 'First Name',
                ),
                const Gap(10),
                AppTextFormField(
                  suffixIcon: Visibility(
                    visible: _firstNameController.text.isNotEmpty,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _phoneNumberController.clear();
                        });
                      },
                      child: const Icon(Icons.cancel),
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                  controller: _firstNameController,
                ),
                const Gap(20),
                const AppText(
                  text: 'Last Name',
                ),
                const Gap(10),
                AppTextFormField(
                  suffixIcon: Visibility(
                    visible: _lastNameController.text.isNotEmpty,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _phoneNumberController.clear();
                        });
                      },
                      child: const Icon(Icons.cancel),
                    ),
                  ),
                  controller: _lastNameController,
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                ),
                const Gap(20),
                const AppText(
                  text: 'Phone Number',
                ),
                const Gap(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<Country>(
                          iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_drop_down,
                                size: 20, color: Colors.black),
                          ),
                          items: _countries
                              .map((country) => DropdownMenuItem(
                                    value: country,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: CountryFlag.fromCountryCode(
                                        country.code,
                                        width: 50,
                                      ),
                                      title: Text(country.name),
                                      trailing: Text(country.dialCode),
                                    ),
                                  ))
                              .toList(),
                          value: _selectedCountry,
                          onChanged: (value) async {
                            setState(() {
                              _selectedCountry = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: AppSizes.dropDownBoxHeight,
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            width: Adaptive.w(90),
                            maxHeight: 350,
                            elevation: 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onMenuStateChange: (isOpen) {
                            if (isOpen) {
                              // logger.d(isOpen);
                              showInfoToast('Loading countries...',
                                  context: context);
                            }
                          },
                          // isExpanded: true,
                          selectedItemBuilder: (context) => _countries
                              .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 6.0,
                                  ),
                                  child: CountryFlag.fromCountryCode(
                                    _selectedCountry!.code,
                                    width: 40,
                                    // height: 80,
                                  )))
                              .toList(),
                          menuItemStyleData: const MenuItemStyleData(
                              // height: 40.0,
                              ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                        //TODO: add input formatter
                        child: AppTextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Please provide a phone number'),
                        FormBuilderValidators.maxLength(9,
                            errorText: 'Number must have 9 digits')
                      ]),
                      // inputFormatters: [
                      //   // _PhoneNumberFormatter(),
                      // ],
                      keyboardType: const TextInputType.numberWithOptions(),
                      controller: _phoneNumberController,
                      constraintWidth: 50,
                      hintText: "123 456 789",
                      prefixIcon: AppText(
                        text: _selectedCountry?.dialCode ?? '!',
                      ),
                      suffixIcon: Visibility(
                        visible: _phoneNumberController.text.isNotEmpty,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _phoneNumberController.clear();
                            });
                          },
                          child: const Icon(Icons.cancel),
                        ),
                      ),
                    ))
                  ],
                ),
                const Gap(20),
                const AppText(
                  text: 'Date of birth',
                ),
                const Gap(10),
                AppTextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  suffixIcon: Visibility(
                    visible: _selectedDOBController.text.isNotEmpty,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDOBController.clear();
                          _selectedDOB = null;
                        });
                      },
                      child: const Icon(Icons.cancel),
                    ),
                  ),
                  hintText: 'MM/DD/YYYY',
                  onTap: () async {
                    var results = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: CalendarDatePicker2WithActionButtonsConfig(),
                      dialogSize: const Size(325, 400),
                      value: [_selectedDOB],
                      borderRadius: BorderRadius.circular(15),
                    );
                    if (results != null) {
                      setState(() {
                        _selectedDOB = results.first;
                        _selectedDOBController.text = AppFunctions.formatDate(
                            _selectedDOB.toString(),
                            format: 'd/m/Y');
                      });
                    }
                  },
                  controller: _selectedDOBController,
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                ),
                if (widget.memberType == FamilyMemberType.teen)
                  const Column(
                    children: [
                      Gap(5),
                      AppText(
                          color: AppColors.neutral500,
                          text:
                              "Teen's age must be 13 — 17. By tapping Save, you confirm that your teen agreed to share their contact information with Uber."),
                    ],
                  ),
                const Gap(80),
                AppButton(
                  text: 'Save',
                  callback: () {
                    if (_formKey.currentState!.validate()) {
                      final userInfo =
                          Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);

                      final newFamilyMember = FamilyMemberInvite(
                          id: const Uuid().v4(),
                          familyProfileId: userInfo['familyProfile'],
                          name:
                              '${_firstNameController.text} ${_lastNameController.text}',
                          dob: _selectedDOB!);

                      if (DateTime.now().difference(_selectedDOB!) <=
                          const Duration(days: 365 * 12)) {
                        showInfoToast(
                            'Your new member is less than 13 years old',
                            context: navigatorKey.currentContext);
                        return;
                      }
                      if (widget.memberType == FamilyMemberType.adult &&
                          DateTime.now().difference(_selectedDOB!) <
                              const Duration(days: 365 * 17)) {
                        showInfoToast('Your new member is not an adult',
                            context: navigatorKey.currentContext);
                        return;
                      }
                      if (widget.memberType == FamilyMemberType.teen &&
                          DateTime.now().difference(_selectedDOB!) >
                              const Duration(days: 365 * 17)) {
                        showInfoToast(
                            'Your new member is does not seem to be a teen. Please go back and register them as an adult.',
                            context: navigatorKey.currentContext,
                            seconds: 5);
                        return;
                      }
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => TermsForFamilyProfilesScreen(
                          familyMemberInvite: newFamilyMember,
                        ),
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
