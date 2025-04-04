import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/icons/cib.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:uber_eats_clone/app_functions.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/models/credit_card_details/credit_card_details_model.dart';
import 'package:uber_eats_clone/models/payment_method_model.dart';
// import 'package:uber_eats_clone/models/payment_method_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';

import '../../sign_in/views/add_a_credit_card/add_a_credit_card.dart';

class PaymentOptionsScreen extends ConsumerStatefulWidget {
  final bool showOnlyPaymentMethods;
  const PaymentOptionsScreen({super.key, this.showOnlyPaymentMethods = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends ConsumerState<PaymentOptionsScreen> {
  final _ccValidator = CreditCardValidator();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              navigatorKey.currentState!.pop();
            },
            child: const Icon(Icons.close)),
      ),
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box(AppBoxes.appState).listenable(keys: [BoxKeys.userInfo]),
          builder: (context, appStateBox, child) {
            Map userInfo = appStateBox.get(BoxKeys.userInfo);
            String accountType = userInfo['type'];
            Map uberCash = userInfo['uberCash'];

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Payment options',
                    weight: FontWeight.w600,
                    size: AppSizes.heading5,
                  ),
                  const Gap(10),
                  if (!widget.showOnlyPaymentMethods)
                    Row(
                      children: [
                        AppButton(
                          buttonColor: accountType == 'Personal'
                              ? Colors.black
                              : AppColors.neutral200,
                          callback: () async {
                            userInfo['type'] = 'Personal';

                            await appStateBox.put(BoxKeys.userInfo, userInfo);
                          },
                          text: 'Personal',
                          textColor: accountType == 'Personal'
                              ? Colors.white
                              : Colors.black,
                          borderRadius: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          iconFirst: true,
                          icon: Icon(
                            Icons.person,
                            color: accountType == 'Personal'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const Gap(5),
                        AppButton(
                          borderRadius: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          callback: () async {
                            userInfo['type'] = 'Business';

                            await appStateBox.put(BoxKeys.userInfo, userInfo);
                          },
                          text: 'Business',
                          iconFirst: true,
                          textColor: accountType == 'Business'
                              ? Colors.white
                              : Colors.black,
                          buttonColor: accountType == 'Business'
                              ? Colors.green
                              : AppColors.neutral200,
                          icon: Icon(
                            FontAwesomeIcons.briefcase,
                            color: accountType == 'Business'
                                ? Colors.white
                                : Colors.black,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  const Gap(30),
                  if (!widget.showOnlyPaymentMethods)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: 'Uber Cash',
                          color: AppColors.neutral500,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              AssetNames.uberLogo,
                              height: 30,
                            ),
                          ),
                          title: const AppText(text: 'Uber Cash'),
                          subtitle: AppText(
                            text: '\$${uberCash['balance'].toStringAsFixed(2)}',
                          ),
                          trailing: Switch.adaptive(
                            value: uberCash['isActive'],
                            onChanged: (value) async {
                              uberCash['isActive'] = value;
                              await appStateBox.put(BoxKeys.userInfo, userInfo);
                            },
                          ),
                        ),
                      ],
                    ),
                  const Gap(10),
                  const AppText(
                    text: 'Payment Method',
                    color: AppColors.neutral500,
                  ),
                  FutureBuilder<List<CreditCardDetails>>(
                      future: AppFunctions.getCreditCards(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final creditCard = snapshot.data![index];
                              final types = detectCCType(creditCard.cardNumber);

                              return ListTile(
                                onTap: () {
                                  navigatorKey.currentState!.pop(creditCard);
                                },
                                contentPadding: EdgeInsets.zero,
                                leading: CreditCardLogo(types: types),
                                title: AppText(
                                  text:
                                      '${AppFunctions.getCreditCardName(types)}••••${creditCard.cardNumber.substring(6)}',
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return AppText(text: snapshot.error.toString());
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                  const Gap(10),
                  GestureDetector(
                    onTap: () =>
                        navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const PaymentMethodScreen(),
                    )),
                    child: const AppText(
                      text: 'Add payment method',
                      color: Colors.green,
                    ),
                  ),
                  const Gap(30),
                  if (!widget.showOnlyPaymentMethods)
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          size: AppSizes.bodySmall,
                          text: 'Vouchers',
                          weight: FontWeight.w600,
                        ),
                        Gap(10),
                        //TODO: implement add voucher code ontap
                        ListTile(
                          // onTap: () =>
                          //     navigatorKey.currentState!.push(MaterialPageRoute(
                          //   builder: (context) => const PromoScreen(),
                          // ))
                          // ,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.add,
                            weight: 4,
                          ),
                          title: AppText(
                            text: 'Add voucher code',
                            size: AppSizes.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  if (accountType == 'Business')
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        AppText(
                          size: AppSizes.bodySmall,
                          text: 'Business settings',
                          weight: FontWeight.w600,
                        ),
                        Gap(10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.receipt,
                            weight: 4,
                          ),
                          title: AppText(
                            text: 'Receipts to nanafenyim@gmail.com',
                            color: AppColors.neutral500,
                            size: AppSizes.bodySmall,
                          ),
                          subtitle: AppText(
                            text: 'Expense not set',
                            color: AppColors.neutral500,
                            size: AppSizes.bodySmall,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }),
    );
  }
}

class Address {
  final String name;
  final String location;

  Address({required this.name, required this.location});
}
