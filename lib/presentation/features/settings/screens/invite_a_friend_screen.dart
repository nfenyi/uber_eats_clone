import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/asset_names.dart';
import '../../../constants/weblinks.dart';
import '../../../core/app_colors.dart';

class InviteAFriendScreen extends StatefulWidget {
  const InviteAFriendScreen({super.key});

  @override
  State<InviteAFriendScreen> createState() => _InviteAFriendScreenState();
}

class _InviteAFriendScreenState extends State<InviteAFriendScreen> {
  bool _isLoadingEmail = false;
  late final DynamicLinkParameters _dynamicLinkParams;

  late String _invitationCode;

  bool _isLoadingSeeMoreOptions = false;

  @override
  void initState() {
    super.initState();
    _invitationCode = 'eats-${const Uuid().v4().substring(24)}';
    _dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "https://uber-eats-clone-d792a.firebaseapp.com/invitation?id=$_invitationCode"),
      uriPrefix: "https://ubereatsclone.page.link",
      androidParameters: const AndroidParameters(
        packageName: 'com.example.uber_eats_clone',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.uberEatsClone',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Invite a friend, get \$15 off',
          size: AppSizes.bodySmall,
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
                              ..onTap = () async {
                                await launchUrl(
                                    Uri.parse(Weblinks.uberOneTerms));
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
                      title: AppText(
                        text: _invitationCode,
                        weight: FontWeight.bold,
                      ),
                      trailing: AppButton2(
                        text: 'Copy',
                        callback: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _invitationCode));
                        },
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(40),
                  Center(
                    child: SizedBox(
                      width: 100,
                      child: AppButton(
                        isLoading: _isLoadingEmail,
                        deactivateExpansion: true,
                        borderRadius: 50,
                        height: 35,
                        width: 90,
                        text: 'Email',
                        iconFirst: true,
                        icon: const Icon(
                          Icons.email,
                          size: 20,
                        ),
                        callback: () async {
                          setState(() {
                            _isLoadingEmail = true;
                          });
                          try {
                            final dynamicLink = await FirebaseDynamicLinks
                                .instance
                                .buildLink(_dynamicLinkParams);
                            // final toEmail = 'recipient@gmail.com';
                            // final message =
                            //     'Get \$20 off your first two orders using the code below:\n\n${dynamicLink.toString()}';
                            // final subject =
                            //     ' '${FirebaseAuth.instance.currentUser!.displayName} invites you to Uber Eats!';
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              // Optional: Specify recipient(s), subject, and body
                              path: 'recepient@gmail.com',
                              queryParameters: {
                                'subject':
                                    '${FirebaseAuth.instance.currentUser!.displayName} invites you to Uber Eats!',
                                'body':
                                    'Get \$20 off your first two orders using the code below:\n\n${dynamicLink.toString()}'
                              },
                            );
                            // final Uri emailLaunchUri = Uri.parse(
                            //     'mailto:test@example.org?subject=Greetings&body=Hello%20World');
                            // logger.d(emailLaunchUri);
                            // final Uri emailLaunchUri =
                            //     'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';
                            if (await canLaunchUrl(emailLaunchUri)) {
                              await launchUrl(emailLaunchUri);
                            } else {
                              await showAppInfoDialog(
                                  navigatorKey.currentContext!,
                                  description: 'No email app found.');
                              setState(() {
                                _isLoadingEmail = false;
                              });
                            }
                          } on Exception catch (e) {
                            setState(() {
                              _isLoadingEmail = false;
                            });
                            await showAppInfoDialog(
                                navigatorKey.currentContext!,
                                description: e.toString());
                          }
                        },
                        isSecondary: true,
                      ),
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
          isLoading: _isLoadingSeeMoreOptions,
          text: 'See more options',
          callback: () async {
            setState(() {
              _isLoadingSeeMoreOptions = true;
            });
            final dynamicLink = await FirebaseDynamicLinks.instance
                .buildLink(_dynamicLinkParams);
            await Share.share(
                'Get \$20 off your first two orders using the code below:\n\n${dynamicLink.toString()}',
                subject:
                    '${FirebaseAuth.instance.currentUser!.displayName} invites you to Uber Eats!');
            setState(() {
              _isLoadingSeeMoreOptions = false;
            });
          },
        )
      ],
    );
  }
}
