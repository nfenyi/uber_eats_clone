import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bi.dart';
import 'package:iconify_flutter_plus/icons/gridicons.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/payment_options_screen.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/schedule_delivery_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';

import '../../../../app_functions.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  final _emailController = TextEditingController();
  bool _firstLogIn = false;

  final List<Address> _recentAddresses = [
    Address(name: '222 NY-59', location: 'Suffen, NY'),
    Address(name: 'My Home', location: '1226 University Dr')
  ];

  String _profile = 'Business';

  DateTime? _timePreference;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_firstLogIn)
              const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      size: AppSizes.heading5,
                      text: 'Find what you need near you',
                      weight: FontWeight.w600,
                    ),
                    Gap(10),
                    AppText(
                      size: AppSizes.body,
                      text:
                          'We use your address to help you find the best spots nearby.',
                    ),
                    Gap(30),
                  ]),
            TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for an address',
                  filled: true,
                  fillColor: AppColors.neutral100,
                  prefixIcon: Icon(Icons.search),
                  suffixIconConstraints: BoxConstraints.tightFor(height: 20),
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
            const Gap(20),
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
                  //Check for location permission
                  //if (not permitted){
                  //
                  //}
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              AppSizes.horizontalPaddingSmall),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: AppText(
                                  text: 'Allow location access',
                                  size: AppSizes.heading6,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              const Gap(5),
                              const Divider(),
                              const Gap(5),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                            text:
                                                'This lets us show you which restaurants and stores you can order from'),
                                        Gap(15),
                                        AppText(
                                            text:
                                                'Please go to permissions → Location and allow access'),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    AssetNames.allowLocation,
                                    width: 60,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              AppButton(
                                text: 'Allow',
                                callback: () {},
                              ),
                              const Gap(10),
                              Center(
                                child: AppTextButton(
                                  text: 'Close',
                                  callback: () =>
                                      navigatorKey.currentState!.pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  // navigatorKey.currentState!.push(MaterialPageRoute(
                  //   builder: (context) => const AddressDetailsScreen(),
                  // ));
                },
              ),
            ),
            if (!_firstLogIn)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Gap(10),
                const AppText(
                  size: AppSizes.heading6,
                  text: 'Recent Addresses',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _recentAddresses.length,
                  itemBuilder: (context, index) {
                    final address = _recentAddresses[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.pin_drop,
                      ),
                      title: AppText(
                        text: address.name,
                        size: AppSizes.bodySmall,
                      ),
                      trailing: const Icon(
                        Icons.edit,
                        color: AppColors.neutral500,
                      ),
                      subtitle: AppText(
                        text: address.location,
                        color: AppColors.neutral500,
                      ),
                    );
                  },
                ),
                const Gap(15),
                const AppText(
                  size: AppSizes.heading6,
                  text: 'Time preference',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.watch_later_outlined,
                  ),
                  title: AppText(
                    text: _timePreference == null
                        ? 'Deliver now'
                        : '${AppFunctions.formatDate(_timePreference.toString(), format: 'G:i A')} - ${AppFunctions.formatDate(_timePreference!.add(const Duration(minutes: 30)).toString(), format: 'G:i A')}',
                    size: AppSizes.bodySmall,
                  ),
                  trailing: AppButton2(
                    text: _timePreference == null ? 'Schedule' : 'Deliver now',
                    callback: () async {
                      if (_timePreference == null) {
                        _timePreference = await navigatorKey.currentState!
                            .push(MaterialPageRoute(
                          builder: (context) => const ScheduleDeliveryScreen(),
                        ));
                        setState(() {});
                      } else {
                        setState(() {
                          _timePreference = null;
                        });
                      }
                    },
                  ),
                ),
                const Gap(10),
                const AppText(
                  size: AppSizes.heading5,
                  text: 'Profile',
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                ListTile(
                  onTap: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const PaymentOptionsScreen(),
                    ));
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: AppColors.neutral200,
                    padding: EdgeInsets.zero,
                    thumbColor:
                        _profile == 'Personal' ? Colors.black : Colors.green,
                    children: _profile == 'Personal'
                        ? const {
                            0: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            1: Icon(
                              FontAwesomeIcons.briefcase,
                              size: 15,
                            )
                          }
                        : const {
                            0: Icon(
                              Icons.person,
                              size: 15,
                            ),
                            1: Padding(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Icon(
                                  FontAwesomeIcons.briefcase,
                                  color: Colors.white,
                                  size: 20,
                                ))
                          },
                    groupValue: _profile == 'Personal' ? 0 : 1,
                    onValueChanged: (value) {},
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  title: AppText(
                    text: _profile,
                    size: AppSizes.bodySmall,
                  ),
                ),
              ]),
          ],
        ),
      ),
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
  final Color color;

  const AppButton2({
    required this.text,
    required this.callback,
    this.shape,
    this.color = AppColors.neutral100,
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
          backgroundColor: widget.color, shape: widget.shape),
      child: AppText(
        text: widget.text,
      ),
    );
  }
}
