import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebApp extends StatefulWidget {
  final String url;

  const WebApp({super.key, required this.url});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000));

  @override
  void initState() {
    super.initState();
    _controller.loadRequest(Uri.parse(widget.url)); // Acceder a url aquí
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}