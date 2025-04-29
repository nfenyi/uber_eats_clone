import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/models/family_profile/family_profile_model.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';
import 'package:uber_eats_clone/presentation/services/sign_in_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../main.dart';
import '../../../../constants/weblinks.dart';
import '../../../main_screen/screens/main_screen_wrapper.dart';

class TermsForFamilyProfilesScreen extends StatefulWidget {
  final FamilyMemberInvite familyMemberInvite;
  const TermsForFamilyProfilesScreen(
      {super.key, required this.familyMemberInvite});

  @override
  State<TermsForFamilyProfilesScreen> createState() =>
      _TermsForFamilyProfilesScreenState();
}

class _TermsForFamilyProfilesScreenState
    extends State<TermsForFamilyProfilesScreen> {
  bool? _hasAgreed = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Terms for Family Profiles',
          size: AppSizes.heading6,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(5),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPaddingSmall),
                child: AppText(
                    text:
                        'To maintain a Family profile and add your teen, you must:'),
              ),
              const Gap(15),
              const ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: AppText(
                  text:
                      "Understand that members you add may request rides and place orders, and you may revoke members' access by removing them",
                  weight: FontWeight.bold,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: AppText(
                  text:
                      "Accept responsibility for all rides and orders for members of your Family profile",
                  weight: FontWeight.bold,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: AppText(
                  text:
                      "Provide a payment method that will be used for all charges to the Family profile",
                  weight: FontWeight.bold,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: AppText(
                  text:
                      "Agree to prevent unauthorized minors from using the Family profile",
                  weight: FontWeight.bold,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: AppText(
                  text:
                      "Obtain permission to share members' personal information with Uber",
                  weight: FontWeight.bold,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: AppText(
                  text: "Have legal authority to act on your teen's behalf",
                  weight: FontWeight.bold,
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                ),
                title: AppText(
                  text: "Agree Uber may communicate directly with your teen",
                  weight: FontWeight.bold,
                ),
              ),
              const Gap(20),
              CheckboxListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _hasAgreed = value;
                  });
                },
                value: _hasAgreed,
                title: RichText(
                  text: TextSpan(
                      text:
                          "By checking the box, I have reviewed and agree to these Family Terms of Use, ",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: 'Teen Account Terms of Use,',
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(Uri.parse(Weblinks.uberOneTerms));
                            },
                        ),
                        const TextSpan(
                          text: ' and acknowledge the ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Privacy Notice',
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(
                                  Uri.parse(Weblinks.privacyPolicy));
                            },
                        ),
                      ]),
                ),
              ),
              const Gap(40),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPaddingSmall),
            child: Column(
              children: [
                AppButton(
                  isLoading: _isLoading,
                  text: 'Send invite',
                  callback: (_hasAgreed == true)
                      ? () async {
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection(FirestoreCollections.familyInvites)
                                .doc(widget.familyMemberInvite.id)
                                .set(widget.familyMemberInvite.toJson());
                            showInfoToast(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                'Invite sent to ${widget.familyMemberInvite.name} ',
                                context: navigatorKey.currentContext);

                            await navigatorKey.currentState!.pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MainScreenWrapper()), (r) {
                              return false;
                            });
                          } on Exception catch (e) {
                            setState(() {
                              _isLoading = true;
                            });
                            await showAppInfoDialog(
                                navigatorKey.currentContext!,
                                description: e.toString());
                          }
                        }
                      : null,
                ),
                const Gap(15)
              ],
            ),
          )
        ],
      ),
    );
  }
}
