import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';

import '../../../../../main.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../core/app_text.dart';

class SelectACountryScreen extends StatefulWidget {
  const SelectACountryScreen({super.key});

  @override
  State<SelectACountryScreen> createState() => _SelectACountryScreenState();
}

class _SelectACountryScreenState extends State<SelectACountryScreen> {
  bool _showSearchField = false;

  final _controller = TextEditingController();
  late final List<Country> _countries;

  late List<Country> _countriesToDisplay;

  @override
  void initState() {
    super.initState();
    _countries = Country.values
        .where(
          (country) => !(country.name.toLowerCase().contains('satellite') ||
              country.name.toLowerCase().contains('network')),
        )
        .toList();
    _countriesToDisplay = _countries;
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = 'A';
    return Scaffold(
      appBar: AppBar(
        title: Visibility(
          visible: _showSearchField,
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search countries',
            ),
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  _countriesToDisplay = _countries
                      .where(
                        (country) => country.name
                            .toLowerCase()
                            .contains(value.toLowerCase()),
                      )
                      .toList();
                } else {
                  _countriesToDisplay = _countries;
                }
              });
            },
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: AppSizes.horizontalPaddingSmall),
            child: GestureDetector(
                onTap: () {
                  if (_controller.text.isNotEmpty) {
                    _controller.clear();
                    setState(() {
                      _countriesToDisplay = _countries;
                    });

                    return;
                  }

                  setState(() {
                    _showSearchField = !_showSearchField;
                  });
                },
                child: Icon(_showSearchField ? Icons.close : Icons.search)),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: AppSizes.horizontalPaddingSmall),
            sliver: SliverToBoxAdapter(
              child: Visibility(
                visible: !_showSearchField,
                child: const AppText(
                  text: 'Select a Country',
                  weight: FontWeight.bold,
                  size: AppSizes.heading5,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: _countriesToDisplay.isNotEmpty &&
                  _countriesToDisplay.first.name[0] == 'A',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: AppSizes.horizontalPaddingSmall),
                color: AppColors.neutral100,
                child: const AppText(text: 'A'),
              ),
            ),
          ),
          _countriesToDisplay.isNotEmpty
              ? SliverList.separated(
                  itemBuilder: (context, index) {
                    final country = _countriesToDisplay[index];
                    return ListTile(
                      onTap: () => navigatorKey.currentState!.pop(country),
                      leading: CountryFlag.fromCountryCode(
                        country.code,
                        width: 40,
                        height: 25,
                      ),
                      title:
                          AppText(text: '${country.name}(${country.dialCode})'),
                    );
                  },
                  separatorBuilder: (context, index) {
                    final country = _countriesToDisplay[index + 1];
                    if (country.name[0] != firstLetter) {
                      firstLetter = country.name[0];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: AppSizes.horizontalPaddingSmall),
                        color: AppColors.neutral100,
                        child: AppText(text: country.name[0]),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  itemCount: _countriesToDisplay.length)
              : const SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPaddingSmall),
                  sliver: SliverToBoxAdapter(
                    child: AppText(text: 'No matches'),
                  ))
        ],
      ),
    );
  }
}
