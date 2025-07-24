import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';
import '../../network/network_utils.dart';
import '../../utils/colors.dart';

class WebViewScreen extends StatefulWidget {
  final Uri uri;
  final String title;

  const WebViewScreen({
    super.key,
    required this.uri,
    required this.title,
  });

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _webViewController;
  WebResourceError? error;
  bool isLoading = false;

  @override
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    if (widget.uri.toString().isNotEmpty) await _loadContent();
  }

  Future<void> _loadContent() async {
    _webViewController = WebViewController()
      ..setBackgroundColor(Colors.black)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError e) {
            setState(() {
              isLoading = false;
              error = e;
            });
            if (e.errorCode == -2) {
              toast(locale.value.yourInternetIsNotWorking);
            } else {
              toast(e.description);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        widget.uri,
        headers: buildHeaderTokens(),
      );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: isLoading.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBartitleText: widget.title, //local
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            if (_webViewController != null && error == null) WebViewWidget(controller: _webViewController!),
            if (error != null)
              NoDataWidget(
                titleTextStyle: secondaryTextStyle(color: white),
                subTitleTextStyle: primaryTextStyle(color: white),
                title: error?.errorCode == -2 ? locale.value.yourInternetIsNotWorking : error?.description,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () async {
                  error = null;
                  await init();
                },
              ).center(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webViewController?.clearCache();
    super.dispose();
  }
}
