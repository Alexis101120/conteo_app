import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  Future<String?> login(String userName, String password) async {
    try {
      final Map<String, dynamic> authData = {
        'userName': userName,
        'password': password,
      };

      final url = Uri.parse('http://192.168.0.11:9090/api/Acceso/LogIn');
      final resp = await http.post(url, body: json.encode(authData), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      });
      if (resp.statusCode != 200) {
        return 'Usuario y/o contraseña incorrectos';
      }
      final Map<String, dynamic> decodeResp = json.decode(resp.body);
      if (decodeResp.containsKey('token')) {
        await storage.write(key: 'token', value: decodeResp['token']);
        return null;
      } else {
        return ('Usuario y/o contrseña incorrectos');
      }
    } catch (e) {
      print(e);
      return (e.toString());
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }
}
