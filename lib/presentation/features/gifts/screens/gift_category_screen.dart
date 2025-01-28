import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/address/screens/addresses_screen.dart';

import '../../../../main.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/asset_names.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets.dart';
import '../../home/home_screen.dart';
import '../../home/screens/search_screen.dart';
import '../../main_screen/state/bottom_nav_index_provider.dart';
import '../state/gift_type_state.dart';

class GiftCategoryScreen extends ConsumerStatefulWidget {
  const GiftCategoryScreen({
    super.key,
  });

  @override
  ConsumerState<GiftCategoryScreen> createState() => _GiftCategoryScreenState();
}

class _GiftCategoryScreenState extends ConsumerState<GiftCategoryScreen> {
  late String _type;

  @override
  void initState() {
    super.initState();
    _type = ref.read(giftTypeStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) =>
          ref.read(bottomNavIndexProvider.notifier).showGiftScreen(),
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                // surfaceTintColor: const Color.fromARGB(255, 254, 243, 240),
                floating: true,

                backgroundColor: _type == 'Alcohol'
                    ? const Color.fromARGB(255, 245, 228, 223)
                    : _type == 'Sweets'
                        ? const Color.fromARGB(255, 165, 71, 131)
                        : _type == 'Retail'
                            ? const Color.fromARGB(255, 71, 70, 191)
                            : const Color.fromARGB(255, 202, 149, 105),
                pinned: true,
                expandedHeight: 200,
                leading: InkWell(
                  onTap: () {
                    ref
                        .read(bottomNavIndexProvider.notifier)
                        .showGiftCategoryScreen();
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(FontAwesomeIcons.arrowLeft),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 55, bottom: 14),
                  background: Image.asset(
                    _type == 'Alcohol'
                        ? AssetNames.giftAlcoholBg
                        : _type == 'Sweets'
                            ? AssetNames.giftSweetsBg
                            : _type == 'Retail'
                                ? AssetNames.giftRetailBg
                                : AssetNames.giftBirthdayBg,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                  title: AppText(
                    text: _type,
                    color: innerBoxIsScrolled ? Colors.black : Colors.white,
                    weight: FontWeight.w600,
                    size: AppSizes.heading4,
                  ),
                ),
              ),
            ];
          },
          body: Column(),
        ),
      ),
    );
  }
}
