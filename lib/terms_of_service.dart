import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meemo/privacy_policy.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:meemo/gen/assets.gen.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    //ローカライズクラスを取得
    final l10n = L10n.of(context);
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://meemo.jp/meemo/terms/'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('progress: $progress');
          },
          onPageStarted: (String url) {
            log('page started: $url');
          },
          onPageFinished: (String url) {
            log('page finished: $url');
          },
          onWebResourceError: (WebResourceError error) {
            log('error: $error');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://meemo.jp/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: Text(
          l10n.service,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
            SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
                    child: Text(
                      l10n.consent,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 50.0),
                    child: Text(
                      l10n.serviceConsent,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: const Color(0xFF096F89),
                      fixedSize: const Size(300, 50),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy(),
                        ),
                      );
                    },
                    child: Text(l10n.next,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
