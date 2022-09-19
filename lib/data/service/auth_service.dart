// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter_desctop/core/enums.dart';
// import 'package:flutter_desctop/core/extensions.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2/oauth2.dart' as oauth2;
// import 'package:window_to_front/window_to_front.dart';
// import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
//
// class AuthService extends DesktopLoginManager {
//   final AuthType loginProvider;
//
//   AuthService({required this.loginProvider}) : super();
//
//   void login() async {
//     await redirectServer?.close();
//     // Bind to an ephemeral port on localhost
//     redirectServer = await HttpServer.bind('localhost', 0);
//     final redirectURL = 'http://localhost:${redirectServer!.port}/auth';
//     var authenticatedHttpClient =
//         await _getOAuth2Client(Uri.parse(redirectURL));
//     print("CREDENTIALS ${authenticatedHttpClient.credentials}");
//     // Logger().i(authenticatedHttpClient.credentials);
//
//     /// HANDLE SUCCESSFULL LOGIN RESPONSE HERE
//     return;
//   }
//
//   Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
//     var grant = oauth2.AuthorizationCodeGrant(
//       loginProvider.clientId,
//       Uri.parse(loginProvider.authorizationEndpoint),
//       Uri.parse(loginProvider.tokenEndpoint),
//       httpClient: _JsonAcceptingHttpClient(),
//       secret: loginProvider.clientSecret,
//     );
//     var authorizationUrl =
//         grant.getAuthorizationUrl(redirectUrl, scopes: loginProvider.scopes);
//
//     await redirect(authorizationUrl);
//     var responseQueryParameters = await listen();
//     var client =
//         await grant.handleAuthorizationResponse(responseQueryParameters);
//     return client;
//   }
// }
//
// class DesktopLoginManager {
//   HttpServer? redirectServer;
//   oauth2.Client? client;
//
//   // Launch the URL in the browser using url_launcher
//   Future<void> redirect(Uri authorizationUrl) async {
//     var url = authorizationUrl.toString();
//     if (await UrlLauncherPlatform.instance.canLaunch(url)) {
//       await UrlLauncherPlatform.instance.launch(
//         url,
//         useSafariVC: false,
//         useWebView: false,
//         enableJavaScript: false,
//         enableDomStorage: false,
//         universalLinksOnly: false,
//         headers: <String, String>{},
//       );
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Future<Map<String, String>> listen() async {
//     var request = await redirectServer!.first;
//     var params = request.uri.queryParameters;
//     await WindowToFront.activate();
//     request.response.statusCode = 200;
//     request.response.headers.set('content-type', 'text/plain');
//     request.response.writeln('Authenticated! You can close this tab.');
//     await request.response.close();
//     await redirectServer!.close();
//     redirectServer = null;
//     return params;
//   }
// }
//
// class _JsonAcceptingHttpClient extends http.BaseClient {
//   final _httpClient = http.Client();
//
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     request.headers['Accept'] = 'application/json';
//     return _httpClient.send(request);
//   }
// }
