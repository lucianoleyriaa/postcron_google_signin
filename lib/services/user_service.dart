import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';

// Plugins
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../environment/environment.dart';

class UserService extends ChangeNotifier {
  static final StreamController<int> _messageStreamController = StreamController.broadcast();
  static Stream<int> get getUserInfo => _messageStreamController.stream;

  FlutterSecureStorage storage = const FlutterSecureStorage();

  late Response response;

  Future<void> getMe(BuildContext context) async {
    try {
      response = await http.get(
        Uri.parse('${Config.environment().apiUrl}/user/me/'),
        headers: { 'token': '${await storage.read(key: 'token')}' }
      ); 

      final responseDecoded = json.decode(response.body);

    } catch (e) {
      // In case of error return 0 to avoid crash
      return _messageStreamController.add(0);
    }
  }

}