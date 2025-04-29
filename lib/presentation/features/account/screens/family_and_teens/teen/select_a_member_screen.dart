import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:gap/gap.dart';

import 'package:uber_eats_clone/presentation/constants/asset_names.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/core/widgets.dart';

import '../../../../../../main.dart';
import '../../../../../constants/app_sizes.dart';
import '../new_family_contact_screen.dart';

class SelectAMemberScreen extends StatefulWidget {
  final FamilyMemberType memberType;
  const SelectAMemberScreen({
    required this.memberType,
    super.key,
  });

  @override
  State<SelectAMemberScreen> createState() => _SelectAMemberScreenState();
}

class _SelectAMemberScreenState extends State<SelectAMemberScreen> {
  final showSearchFieldNotifier = ValueNotifier(true);
  Timer? _debounce;
  final _textController = TextEditingController();

  List<Contact>? _allContactsOnDevice;

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            bottom: (showSearchFieldNotifier.value)
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.horizontalPaddingSmall),
                      child: AppTextFormField(
                        controller: _textController,
                        hintText: 'Search name or number',
                        prefixIcon: const Icon(Icons.search),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) {
                            _debounce?.cancel();
                          }
                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                  )
                : null,
            title: AppText(
              text: widget.memberType == FamilyMemberType.teen
                  ? 'Select a teen'
                  : 'Select an adult',
              size: AppSizes.body,
            ),
            expandedHeight: 90,
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    right: AppSizes.horizontalPaddingSmall),
                child: GestureDetector(
                    onTap: () async =>
                        await navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => NewFamilyContactScreen(
                            selectedPhoneNumber: null,
                            contact: null,
                            memberType: widget.memberType,
                          ),
                        )),
                    child: const Icon(Icons.person_add)),
              )
            ],
          )
        ],
        body: FutureBuilder(
            future: _getDeviceContacts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Contact> contactsOnDevice = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Visibility(
                          replacement: Transform.translate(
                              offset: const Offset(0, -60),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 300,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AssetNames.noContactQuestionMark,
                                            width: 60,
                                          ),
                                          const AppText(
                                            text: 'No contacts',
                                            weight: FontWeight.bold,
                                            size: AppSizes.bodySmall,
                                          ),
                                          const Gap(10),
                                          const AppText(
                                            textAlign: TextAlign.center,
                                            text:
                                                "Looks like you have no contacts in your device's address book.",
                                            color: AppColors.neutral500,
                                            // size: AppSizes.bodySmall,
                                          ),
                                          const Gap(10),
                                          SizedBox(
                                              width: 145,
                                              child: AppButton(
                                                text: 'New contact',
                                                deactivateExpansion: true,
                                                icon: const Icon(
                                                  Icons.person_add,
                                                  size: 18,
                                                ),
                                                callback: () async {
                                                  await navigatorKey
                                                      .currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewFamilyContactScreen(
                                                      selectedPhoneNumber: null,
                                                      contact: null,
                                                      memberType:
                                                          widget.memberType,
                                                    ),
                                                  ));
                                                },
                                                borderRadius: 50,
                                                isSecondary: true,
                                                iconFirst: true,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          visible: _allContactsOnDevice!.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: contactsOnDevice.isEmpty
                                    ? Transform.translate(
                                        offset: const Offset(0, -60),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                width: 300,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      AssetNames
                                                          .noContactQuestionMark,
                                                      width: 60,
                                                    ),
                                                    const AppText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text:
                                                          "No matching contact found",
                                                      color:
                                                          AppColors.neutral500,
                                                      // size: AppSizes.bodySmall,
                                                    ),
                                                    const Gap(10),
                                                    SizedBox(
                                                      width: 145,
                                                      child: AppButton(
                                                        text: 'New contact',
                                                        deactivateExpansion:
                                                            true,
                                                        icon: const Icon(
                                                          Icons.person_add,
                                                          size: 18,
                                                        ),
                                                        callback: () async {
                                                          await navigatorKey
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewFamilyContactScreen(
                                                              selectedPhoneNumber:
                                                                  null,
                                                              contact: null,
                                                              memberType: widget
                                                                  .memberType,
                                                            ),
                                                          ));
                                                        },
                                                        borderRadius: 50,
                                                        isSecondary: true,
                                                        iconFirst: true,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                    : Scrollbar(
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: contactsOnDevice.length,
                                          itemBuilder: (context, index) {
                                            final contact =
                                                contactsOnDevice[index];
                                            return ListTile(
                                              onTap: () async {
                                                String? selectedPhoneNumber;
                                                if (contact.phones.length ==
                                                    1) {
                                                  selectedPhoneNumber = contact
                                                      .phones.first.number
                                                      .substring(1)
                                                      .replaceAll(' ', '');
                                                } else {
                                                  await showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .all(AppSizes
                                                                  .horizontalPaddingSmall),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Center(
                                                                  child:
                                                                      AppText(
                                                                text:
                                                                    'Select a contact',
                                                                size: AppSizes
                                                                    .bodySmall,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                              )),
                                                              const Gap(10),
                                                              const Divider(),
                                                              const Gap(10),
                                                              ListView.builder(
                                                                itemCount:
                                                                    contact
                                                                        .phones
                                                                        .length,
                                                                shrinkWrap:
                                                                    true,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final phone =
                                                                      contact.phones[
                                                                          index];
                                                                  return ListTile(
                                                                    leading:
                                                                        const Icon(
                                                                      Icons
                                                                          .phone_outlined,
                                                                    ),
                                                                    title: AppText(
                                                                        text: phone
                                                                            .number),
                                                                    onTap: () {
                                                                      selectedPhoneNumber = phone
                                                                          .number
                                                                          .substring(
                                                                              1)
                                                                          .replaceAll(
                                                                              ' ',
                                                                              '');
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  );
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                                if (selectedPhoneNumber !=
                                                    null) {
                                                  await navigatorKey
                                                      .currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewFamilyContactScreen(
                                                      contact: contact,
                                                      memberType:
                                                          widget.memberType,
                                                      selectedPhoneNumber:
                                                          selectedPhoneNumber!,
                                                    ),
                                                  ));
                                                }
                                              },
                                              leading: contact
                                                          .photoOrThumbnail !=
                                                      null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.memory(
                                                          width: 40,
                                                          contact
                                                              .photoOrThumbnail!))
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .neutral200)),
                                                      width: 40,
                                                      height: 40,
                                                      child: const Icon(
                                                          Icons.person_outline),
                                                    ),
                                              title: AppText(
                                                  text: contact.displayName),
                                            );
                                          },
                                        ),
                                      ),
                              ),
                            ],
                          )),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return AppText(text: snapshot.error.toString());
              } else {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                );
              }
            }),
      ),
    );
  }

  Future<List<Contact>> _getDeviceContacts() async {
    if (await FlutterContacts.requestPermission()) {
      _allContactsOnDevice ??= await FlutterContacts.getContacts(
        withPhoto: true,
        withThumbnail: true,
        withProperties: true,
      );
      showSearchFieldNotifier.value = _allContactsOnDevice!.isNotEmpty;
      if (_textController.text.isEmpty) {
        return _allContactsOnDevice!;
      } else {
        return _allContactsOnDevice!
            .where(
              (element) => element.displayName
                  .toLowerCase()
                  .contains(_textController.text.toLowerCase()),
            )
            .toList();
      }
    } else {
      throw Exception('Contacts access denied');
    }
  }
}

enum FamilyMemberType { adult, teen }
