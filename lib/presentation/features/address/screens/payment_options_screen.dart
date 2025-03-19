import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
// import 'package:uber_eats_clone/models/payment_method_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

class PaymentOptionsScreen extends ConsumerStatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends ConsumerState<PaymentOptionsScreen> {
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
                  const Gap(10),
                  const AppText(
                    text: 'Payment Method',
                    color: AppColors.neutral500,
                  ),
                  //TODO: implement listing of payment methods
                  // ListView.builder(itemBuilder: )
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
                  const AppText(
                    size: AppSizes.bodySmall,
                    text: 'Vouchers',
                    weight: FontWeight.w600,
                  ),
                  const Gap(10),
                  //TODO: implement add voucher code ontap
                  const ListTile(
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
                  const Divider(),
                  if (accountType == 'Business')
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

class AppButton2 extends StatefulWidget {
  final String text;
  final VoidCallback callback;
  final OutlinedBorder? shape;
  const AppButton2({
    required this.text,
    required this.callback,
    this.shape,
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
      style: TextButton.styleFrom(
          backgroundColor: AppColors.neutral100, shape: widget.shape),
      child: AppText(
        text: widget.text,
      ),
    );
  }
}
