import 'package:flutter/material.dart';
import 'dart:io';

// Plugins
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

// Configurations
import '../environment/environment.dart';

// Services
import '../services/auth_service.dart';
import '../services/user_service.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // late PostcronNotification postData;

  // Webview controllers
  final String device = Platform.isAndroid ? 'android' : 'ios';
  late InAppWebViewController _webViewController;
  late PullToRefreshController _pullToRefreshController;
  Map<String, dynamic> webViewCustomController = {};

  @override
  void initState() {
    super.initState();

    // Refresh controller
    _pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.orange,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController.reload();
        } else if (Platform.isIOS) {
          _webViewController.loadUrl(
              urlRequest: URLRequest(url: await _webViewController.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0), // here the desired height
          child: AppBar()
      ),

      body: InAppWebView(
        initialUrlRequest:
          URLRequest(url: Uri.parse('${Config.environment().webViewUrl}app/auth/?user_token=${args['token']}&mobile=true&device=$device')),
        onWebViewCreated: (InAppWebViewController controller) async {
          _webViewController = controller;
          _webViewController.addJavaScriptHandler(
            handlerName: 'showLogin',
            callback: (args) async {
              Navigator.pushReplacementNamed(context, 'login');
              return true;
            }
          );
          authService.setUserToStorage(args['token']);
        },
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
            )
        ),

        pullToRefreshController: _pullToRefreshController,
      ),
    );;
  }
}
