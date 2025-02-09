import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uber_eats_clone/presentation/core/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../../../main.dart';
import '../../../../../constants/app_sizes.dart';
import '../../../../../constants/weblinks.dart';
import '../../../../webview/webview_screen.dart';
import 'software_licenses_screen.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webViewcontroller = WebViewControllerPlus();

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
              text: 'Legal',
              weight: FontWeight.bold,
              size: AppSizes.heading4,
            ),
          ),
          ListTile(
            dense: true,
            onTap: () async {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  controller: webViewcontroller,
                  link: Weblinks.copyrightInfringement,
                  // showHeader: true,
                ),
              ));
            },
            title: const AppText(text: 'Copyright'),
          ),
          const Divider(),
          ListTile(
            dense: true,
            onTap: () async {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  controller: webViewcontroller,
                  link: Weblinks.termsOfUse,
                  // showHeader: true,
                ),
              ));
            },
            title: const AppText(text: 'Terms & Conditions'),
          ),
          const Divider(),
          ListTile(
            dense: true,
            onTap: () async {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  controller: webViewcontroller,
                  link: Weblinks.privacyPolicy,
                  // showHeader: true,
                ),
              ));
            },
            title: const AppText(text: 'Privacy Policy'),
          ),
          const Divider(),
          ListTile(
            dense: true,
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const SoftwareLicensesScreen()));
            },
            title: const AppText(text: 'Software licenses'),
          ),
          const Divider(),
          ListTile(
            dense: true,
            onTap: () {
              navigatorKey.currentState!.push(MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  controller: webViewcontroller,
                  link: Weblinks.pricing,
                  showHeader: true,
                ),
              ));
            },
            title: const AppText(text: 'Pricing'),
          ),
        ],
      ),
    );
  }
}
