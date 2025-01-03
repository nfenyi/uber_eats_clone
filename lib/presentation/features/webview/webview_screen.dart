import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  final WebViewControllerPlus controller;
  final String link;
  const WebViewScreen(
      {super.key, required this.controller, required this.link});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          widget.link,
        ),
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) => widget.controller
          ..runJavaScript(
            "document.getElementsByTagName('header')[0].style.display='none'",
          )
          ..runJavaScript(
            "document.getElementsByTagName('footer')[0].style.display='none'",
          ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: widget.controller,
      ),
    );
  }
}
