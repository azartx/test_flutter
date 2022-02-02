import 'dart:async';
import 'dart:convert' as convert;

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'H.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool isLoading = true;
  String bannerUrl = "";
  String plugUrl = "https://vilianre-play.xyz";

  @override
  void initState() {
    useFullScreen();
    WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initConfig();
    return Scaffold(
        backgroundColor: Colors.green,
        body: isLoading
            ? const CircularProgressIndicator()
            : WebView(
            initialUrl: bannerUrl == "" ? plugUrl : bannerUrl,
          javascriptMode: JavascriptMode.unrestricted
        )
    );
  }

  void initConfig() async {
    try {
      await FirebaseRemoteConfig.instance
          .setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      final isActivate = await FirebaseRemoteConfig.instance.fetchAndActivate();

        if (isActivate) {
          String urlFromFirebase = FirebaseRemoteConfig.instance.getString("key1");

          var deviceInfo = await DeviceInfoPlugin().androidInfo;
          var bid = deviceInfo.id;
          bid ??= "";
          var country = "";
          //country ??= "";
          var device = deviceInfo.device;
          device ??= "";

          String fullUrl = urlFromFirebase +
              "?bid=" + bid +
              "&country=" + country +
              "&device=" + device;

          // var url = Uri.https('base_url', 'endpoint', {'bid' : 'someBid', 'country' : 'someCountry', 'device' : 'someDevice'});
          var url = Uri.parse(fullUrl);
          var response = await http.get(url);
          if (response.statusCode == 200) {

            var fromJson = (convert.jsonDecode(response.body) as Map<String, String>);

            fromJson.forEach((key, value) {
              setState(() {
              if(key == "banner_url" && value.isNotEmpty) {

                  isLoading = false;
                  bannerUrl = value;
              } else {
                isLoading = false;
                bannerUrl = "";
              }
              });
            });
          }
        } else {
          isLoading = false;
          bannerUrl = "";
        }

    } catch (exception) {
      setState(() {
        isLoading = false;
        bannerUrl = "";
      });
    }
  }
}
