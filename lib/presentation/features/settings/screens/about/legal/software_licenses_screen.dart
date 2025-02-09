import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uber_eats_clone/presentation/constants/app_sizes.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';

import '../../../../../core/app_text.dart';

class SoftwareLicensesScreen extends StatefulWidget {
  const SoftwareLicensesScreen({super.key});

  @override
  State<SoftwareLicensesScreen> createState() => _SoftwareLicensesScreenState();
}

class _SoftwareLicensesScreenState extends State<SoftwareLicensesScreen> {
  Future<List<License>> _loadLicenses() async =>
      LicenseRegistry.licenses.asyncMap<License>(
        (license) async {
          final title = license.packages.join('\n');
          final text = license.paragraphs.map<String>(
            (paragraph) {
              return paragraph.text;
            },
          ).join('\n\n');
          return License(title, text);
        },
      ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Software Licenses',
          size: AppSizes.heading6,
        ),
      ),
      body: FutureBuilder<List<License>>(
        future: _loadLicenses(),
        builder: (context, snapshot) {
          final licenses = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));

            default:
              if (snapshot.hasError) {
                return Center(
                  child: AppText(
                      text:
                          'An error occured while loading licenses:\n${snapshot.error.toString()}'),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) => const Gap(20),
                  itemCount: licenses!.length,
                  itemBuilder: (context, index) {
                    final license = licenses[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.horizontalPaddingSmall),
                          child: AppText(
                            text: license.title,
                            weight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            size: AppSizes.bodySmall,
                          ),
                        ),
                        const Gap(10),
                        Container(
                          padding: const EdgeInsets.all(
                              AppSizes.horizontalPaddingSmall),
                          color: AppColors.neutral100,
                          width: double.infinity,
                          child: AppText(text: license.text),
                        )
                      ],
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}

class License {
  late String title;
  late String text;

  License(this.title, this.text);

  // License.fromJson(Map<String, dynamic> json) {
  //   title = json['title'];
  //   text = json['text'];
  // }
}
