import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../environment/environment.dart';
import '../models/login_response.dart';

class AuthService extends ChangeNotifier {

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  loginWithGoogle() async {

    final GoogleSignInAccount? googleSignInAccount;
    final dynamic googleSignInAuthentication;

    try {
      final googleSignIn = GoogleSignIn();

      if (await googleSignIn.isSignedIn()) googleSignIn.disconnect();

      googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) return;

      googleSignInAuthentication = await googleSignInAccount.authentication;
      String accessToken = googleSignInAuthentication.accessToken;

      return loginInPostcron(socialNetworkToken: accessToken, socialNetwork: 'google', device: 'android');

    } catch(e) {
      return false;
    }
  }

  loginInPostcron({required String socialNetworkToken, required String socialNetwork, String device = 'android'}) async {

    LoginResponse loginResponse;
    Map<String, dynamic> body = {
      "social_network": socialNetwork,
      "token": socialNetworkToken,
      "device": device,
    };

    dynamic response = await http.post(
      Uri.parse('${Config.environment().apiUrl}/auth/login/'),
      body: body,
    );

    final responseDecoded = json.decode(response.body);
    
    if (responseDecoded['status'] == 'success') {
      loginResponse = LoginResponse(
        status: responseDecoded['status'],
        token: responseDecoded['result']['token'],
        lang: responseDecoded['result']['user']['language']['lang'],
      );

      String userId = responseDecoded['result']['user']['id'];
      await storage.write(key: 'userId', value: userId);

      return loginResponse;
    }

  }

  Future<void> setUserToStorage(token) async {
    await storage.write(key: 'token', value: token);
  }

}