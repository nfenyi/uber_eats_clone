import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uber_eats_clone/main.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../constants/app_sizes.dart';
import '../../../services/sign_in_view_model.dart';

class NameEditScreen extends StatefulWidget {
  const NameEditScreen({super.key});

  @override
  State<NameEditScreen> createState() => _NameEditScreenState();
}

class _NameEditScreenState extends State<NameEditScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late final String _initialFirstName;
  late final String _initialLastName;

  @override
  void initState() {
    super.initState();
    final userInfo = Hive.box(AppBoxes.appState).get(BoxKeys.userInfo);
    final String displayName = userInfo['displayName'];
    final names = displayName.split(' ');
    _firstNameController.text =
        names.length == 2 ? names.first : "${names.first} ${names[1]}";
    _lastNameController.text = displayName.split(' ').last;
    _initialFirstName = _firstNameController.text;
    _initialLastName = _lastNameController.text;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AppText(
            text: 'Uber Account',
            size: AppSizes.bodySmall,
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
                suffixIcon: _firstNameController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          if (_firstNameController.text.isNotEmpty) {
                            setState(() {
                              _firstNameController.clear();
                            });
                          }
                        },
                        child: const Icon(Icons.cancel))
                    : null,
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
                suffixIcon: _lastNameController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          if (_lastNameController.text.isNotEmpty) {
                            setState(() {
                              _lastNameController.clear();
                            });
                          }
                        },
                        child: const Icon(Icons.cancel))
                    : null,
              ),
              const Gap(100),
              AppButton(
                text: 'Update',
                callback: ((_firstNameController.text == _initialFirstName &&
                            _lastNameController.text == _initialLastName) ||
                        _firstNameController.text.isEmpty ||
                        _lastNameController.text.isEmpty)
                    ? null
                    : () async {
                        try {
                          showInfoToast('Updating name..',
                              context: context,
                              icon: const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                ),
                              ));
                          final newDisplayName =
                              '${_firstNameController.text} ${_lastNameController.text}';

                          final userCredential =
                              FirebaseAuth.instance.currentUser!;
                          await userCredential
                              .updateDisplayName(newDisplayName);

                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.users)
                              .doc(userCredential.uid)
                              .update({
                            'displayName': newDisplayName,
                          });
                          String udid = await FlutterUdid.consistentUdid;
                          final deviceUsersDetails = await FirebaseFirestore
                              .instance
                              .collection(FirestoreCollections.devices)
                              .doc(udid)
                              .get();
                          final deviceUserDetails =
                              deviceUsersDetails.data()![userCredential.uid];
                          deviceUserDetails['name'] = newDisplayName;
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.devices)
                              .doc(udid)
                              .update({
                            userCredential.uid: deviceUserDetails,
                          });
                          showInfoToast(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              'Name updated',
                              context: navigatorKey.currentContext);
                          if (context.mounted) Navigator.pop(context);
                        } on Exception catch (e) {
                          if (context.mounted) {
                            await showAppInfoDialog(
                                description: e.toString(), context);
                          }
                        }
                      },
              )
            ],
          ),
        ));
  }
}
