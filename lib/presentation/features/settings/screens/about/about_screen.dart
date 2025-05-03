import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:uber_eats_clone/presentation/features/settings/screens/about/legal/legal_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../main.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../constants/weblinks.dart';
import '../../../webview/webview_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPaddingSmall,
            ),
            child: AppText(
              text: 'About',
              weight: FontWeight.bold,
              size: AppSizes.heading4,
            ),
          ),
          ListTile(
            onTap: () async {
              String url;

              if (Platform.isAndroid) {
                url = "market://details?id=com.ubercab.eats"; // Android
              } else if (Platform.isIOS) {
                url =
                    "itms-apps://itunes.apple.com/app/uber-eats-food-delivery/id1058959277"; // iOS.  Replace with your app name and ID
              } else {
                url = "https://www.ubereats.com/";
              }

              Uri uri = Uri.parse(url);

              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                throw 'Could not launch $url';
              }
            },
            title: AppText(
                text:
                    'Rate us in ${Platform.isAndroid ? 'Google Play' : 'App Store'}'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(Uri.parse(Weblinks.uberEatsFacebookPage));
            },
            title: const AppText(text: 'Like us on Facebook'),
          ),
          ListTile(
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => const LegalScreen(),
              ));
            },
            title: const AppText(text: 'Legal'),
          ),
          ListTile(
            onTap: () async {
              await launchUrl(Uri.parse(Weblinks.uberEatsWebApp));
            },
            title: const AppText(text: 'UberEats.com'),
          ),
        ],
      ),
    );
  }
}
