import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/carts/screens/checkouts/reg_checkout_screen.dart';
import 'package:uber_eats_clone/state/delivery_schedule_provider.dart';

import '../../../../../models/uber_cash/uber_cash_model.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../services/sign_in_view_model.dart';

class AddFundsScreen extends ConsumerStatefulWidget {
  const AddFundsScreen({super.key});

  @override
  ConsumerState<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends ConsumerState<AddFundsScreen> {
  final _fundController = TextEditingController();

  String? _selectedFund;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fundController.text = '0.00';
  }

  @override
  void dispose() {
    _fundController.dispose();
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
                  text: 'Add Funds',
                  weight: FontWeight.bold,
                  size: AppSizes.heading4,
                ),
                const Gap(15),
                const AppText(
                  text:
                      'How much do you want to add to your Uber Cash balance?',
                  size: AppSizes.bodySmall,
                ),
                const Gap(20),
                AppTextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _fundController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  prefix: Text(
                    '\$ ',
                    style: GoogleFonts.robotoMono(
                      color: Colors.black,
                      fontSize: AppSizes.heading4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  textStyle: GoogleFonts.robotoMono(
                    fontSize: AppSizes.heading4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(10),
                const AppText(
                  text: 'Enter an amount between \$25 and \$500',
                  color: AppColors.neutral500,
                ),
                const Gap(10),
                ChipsChoice<String>.single(
                  wrapped: false,
                  padding: EdgeInsets.zero,
                  value: _selectedFund,
                  onChanged: (value) async {
                    setState(() {
                      _selectedFund = value;
                      _fundController.text = value;
                    });
                  },
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: ['50.00', '100.00', '200.00'],
                    value: (i, v) => v,
                    label: (i, v) => '\$$v',
                  ),
                  choiceStyle: C2ChipStyle.filled(
                    selectedStyle: const C2ChipStyle(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    height: 30,
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.neutral200,
                  ),
                ),
                const Gap(30),
                InkWell(
                    onTap: () {},
                    child: Ink(
                        child: const AppText(
                      text: 'Terms apply',
                      decoration: TextDecoration.underline,
                      color: Colors.green,
                    )))
              ],
            ),
            Column(children: [
              const PaymentOptionWidget(),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      isSecondary: true,
                      text: 'CANCEL',
                      callback: () {
                        navigatorKey.currentState!.pop();
                      },
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: AppButton(
                      isLoading: _isLoading,
                      text: 'CONFIRM',
                      callback: ref.watch(paymentOptionProvider) == null ||
                              _fundController.text.isEmpty ||
                              double.parse(_fundController.text) < 25 ||
                              double.parse(_fundController.text) > 500
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                final usersDetails = await FirebaseFirestore
                                    .instance
                                    .collection(FirestoreCollections.users)
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get();
                                final UberCash oldDeviceUserDetails =
                                    UberCash.fromJson(
                                        usersDetails.data()!['uberCash']);
                                final increment =
                                    double.parse(_fundController.text);
                                final newDeviceUserDetails =
                                    oldDeviceUserDetails.copyWith(
                                        balance: oldDeviceUserDetails.balance +
                                            increment,
                                        cashAdded:
                                            oldDeviceUserDetails.cashAdded +
                                                increment);

                                await FirebaseFirestore.instance
                                    .collection(FirestoreCollections.users)
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  'uberCash': newDeviceUserDetails.toJson()
                                });
                                await AppFunctions.getOnlineUserInfo();
                                showInfoToast('Funds added!',
                                    context: navigatorKey.currentContext);
                                navigatorKey.currentState!.pop();
                              } on Exception catch (e) {
                                showInfoToast(e.toString(),
                                    context: navigatorKey.currentContext);
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                    ),
                  )
                ],
              ),
              const Gap(10),
            ])
          ],
        ),
      ),
    );
  }
}
