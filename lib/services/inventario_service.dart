import 'dart:convert';

import 'package:conteo_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventarioService extends ChangeNotifier {
  final storage = FlutterSecureStorage();
  List<Inventario> inventarios = [];
  late Inventario selectedInventario;

  bool isLoading = true;
  bool isSaving = false;

  InventarioService() {
    loadInventarios();
  }

  Future<List<Inventario>> loadInventarios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tiendaId = await prefs.getInt('Tienda');
    print('Tienda id $tiendaId');
    final token = await storage.read(key: 'token');
    this.isLoading = true;
    notifyListeners();
    final url = Uri.parse(
        'http://13.65.191.65:9095/api/Inventarios/ObtenTodo/$tiendaId');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(resp.statusCode);
    if (resp.statusCode == 200) {
      final inventariosMap = json.decode(resp.body);
      final List<dynamic> listaInventario = inventariosMap['data'];
      listaInventario.forEach((element) {
        final tempInventario = Inventario.fromMap(element);
        final noExiste = inventarios
            .where((element) => element.id == tempInventario.id)
            .isEmpty;
        if (noExiste) {
          inventarios.add(tempInventario);
        }
      });

      isLoading = false;
      notifyListeners();
      return inventarios;
    }
    isLoading = false;
    notifyListeners();
    return [];
  }

  Future<Respuesta> crearInventario(Inventario inventario) async {
    isSaving = true;
    notifyListeners();
    try {
      final token = await storage.read(key: 'token');
      final url = Uri.parse('http://13.65.191.65:9095/api/Inventarios');
      final inventario_envio = await inventario.toJsonCrear();
      final resp = await http.post(url, body: inventario_envio, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        if (decodedData['success'] == true) {
          isSaving = false;
          notifyListeners();
          return Respuesta(true, decodedData['mensaje']);
        } else {
          isSaving = false;
          notifyListeners();
          return Respuesta(false, decodedData['mensaje']);
        }
      } else {
        isSaving = false;
        notifyListeners();
        return Respuesta(false, 'Ocurrio un error en el servidor');
      }
    } catch (ex) {
      isSaving = false;
      notifyListeners();
      return Respuesta(false, 'Ocurrio un error en el servidor');
    }
  }
}
