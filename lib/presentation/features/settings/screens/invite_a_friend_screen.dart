import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../main.dart';
import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../../core/app_colors.dart';
import '../../webview/webview_screen.dart';

class InviteAFriendScreen extends StatelessWidget {
  const InviteAFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webViewcontroller = WebViewControllerPlus();
    const invitationCode = 'eats-46446161664649s';
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Invite a friend, get \$15 off',
          size: AppSizes.body,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AssetNames.inviteFriend),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPaddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Give the gift of food to friends',
                    size: AppSizes.heading3,
                    weight: FontWeight.bold,
                  ),
                  const Gap(10),
                  RichText(
                    text: TextSpan(
                        text:
                            "You both get a promo when your friend makes their first order. ",
                        style: const TextStyle(
                          fontSize: AppSizes.bodySmaller,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'See details',
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    controller: webViewcontroller,
                                    link: Weblinks.uberOneTerms,
                                  ),
                                ));
                              },
                          ),
                        ]),
                  ),
                  const Gap(15),
                  ListTile(
                    title: const AppText(
                      text: 'You get \$15 off',
                      weight: FontWeight.bold,
                    ),
                    subtitle: const AppText(
                      text: '\$25 minimum order',
                      color: AppColors.neutral500,
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset(
                      AssetNames.walletGift,
                      width: 40,
                    ),
                  ),
                  ListTile(
                    title: const AppText(
                      text: 'They get \$40 off',
                      weight: FontWeight.bold,
                    ),
                    subtitle: const AppText(
                      text: '\$20 off 2 orders • \$25 minimum order',
                      color: AppColors.neutral500,
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset(
                      AssetNames.theyGet,
                      width: 40,
                    ),
                  ),
                  const Gap(40),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: const AppText(
                        text: invitationCode,
                        weight: FontWeight.bold,
                      ),
                      trailing: AppButton2(
                        text: 'Copy',
                        callback: () {
                          showInfoToast('Copied', context: context);
                        },
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(40),
                  Center(
                    child: AppButton(
                      borderRadius: 50,
                      height: 35,
                      width: 90,
                      text: 'Email',
                      iconFirst: true,
                      icon: const Icon(
                        Icons.email,
                        size: 20,
                      ),
                      callback: () {},
                      isSecondary: true,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        AppButton(
          text: 'See more options',
          callback: () {},
        )
      ],
    );
  }
}
