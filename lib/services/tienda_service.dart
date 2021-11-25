import 'dart:convert';

import 'package:conteo_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class TiendaService extends ChangeNotifier {
  final storage = FlutterSecureStorage();
  List<Tienda> tiendas = [];
  late Tienda selectedTienda;

  bool isLoading = true;
  bool isSaving = false;

  TiendaService() {
    loadTiendas();
  }

  Future<List<Tienda>> loadTiendas() async {
    final token = await storage.read(key: 'token');
    this.isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://192.168.0.11:9090/api/Tiendas');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final tiendasMap = json.decode(resp.body);
    final List<dynamic> listaTienda = tiendasMap['data'];
    listaTienda.forEach((element) {
      final tempTienda = Tienda.fromMap(element);
      final noExiste =
          tiendas.where((element) => element.id == tempTienda.id).isEmpty;
      if (noExiste) {
        tiendas.add(tempTienda);
      }
    });
    isLoading = false;
    notifyListeners();
    return tiendas;
  }
}
