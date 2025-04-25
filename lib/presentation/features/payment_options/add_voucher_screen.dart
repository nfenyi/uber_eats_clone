import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';

import '../../../app_functions.dart';
import '../../../main.dart';
import '../../../models/voucher/voucher_model.dart';
import '../../constants/app_sizes.dart';
import '../../core/app_colors.dart';
import '../../core/widgets.dart';
import '../../services/sign_in_view_model.dart';

class AddVoucherScreen extends StatefulWidget {
  const AddVoucherScreen({super.key});

  @override
  State<AddVoucherScreen> createState() => _AddVoucherScreenState();
}

class _AddVoucherScreenState extends State<AddVoucherScreen> {
  final _searchController = TextEditingController();
  Voucher? _searchedVoucher;

  String? _searchedVoucherId;

  bool _isLoading = false;

  DocumentReference<Map<String, dynamic>>? _searchedVoucherRef;

  @override
  void dispose() {
    _searchController.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: 'Add voucher code',
                  size: AppSizes.heading6,
                ),
                const Gap(10),
                AppTextFormField(
                  constraintWidth: 40,
                  controller: _searchController,
                  radius: 10,
                  textInputAction: TextInputAction.search,
                  // prefixIcon: const Iconify(La.tag),
                  hintText: 'Enter voucher code',
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            if (_searchController.text.isNotEmpty) {
                              _searchController.clear();
                              setState(() {});
                            }
                          },
                          child: const Icon(
                            Icons.cancel,
                          ),
                        )
                      : null,
                ),
                const Gap(10),
                const AppText(
                    color: AppColors.neutral500,
                    size: AppSizes.bodySmallest,
                    text:
                        'Enter the code in order to claim and use your voucher'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  isLoading: _isLoading,
                  text: 'Continue',
                  callback: _searchController.text.isEmpty
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          _searchedVoucherRef = FirebaseFirestore.instance
                              .collection(FirestoreCollections.vouchers)
                              .doc(_searchController.text.trim());
                          final voucherSnapshot =
                              await _searchedVoucherRef!.get();

                          if (!voucherSnapshot.exists) {
                            setState(() {
                              _searchedVoucherRef = null;
                            });
                            showInfoToast('Voucher not found',
                                context: navigatorKey.currentContext);
                            return;
                          }

                          final temp =
                              Voucher.fromJson(voucherSnapshot.data()!);
                          if (temp.claimed) {
                            setState(() {
                              _searchedVoucher = null;
                            });
                            showInfoToast('Voucher card already claimed',
                                context: navigatorKey.currentContext);
                            return;
                          }
                          _searchedVoucher =
                              Voucher.fromJson(voucherSnapshot.data()!);

                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.giftCardsAnkasa)
                              .doc(_searchedVoucher!.id)
                              .update({'claimed': true});
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.users)
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'redeemedVouchers':
                                FieldValue.arrayUnion([_searchedVoucherId])
                          });
                          await AppFunctions.getOnlineUserInfo();
                          showInfoToast('Voucher claimed',
                              context: navigatorKey.currentContext);
                          _searchController.clear();

                          setState(() {
                            _isLoading = false;
                          });
                        },
                ),
                const Gap(10)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
