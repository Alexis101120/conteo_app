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
    final token = await storage.read(key: 'token');
    isLoading = true;
    inventarios = [];
    notifyListeners();
    final url = Uri.parse(
        'http://13.65.191.65:9095/api/Inventarios/ObtenTodo/$tiendaId');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
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

  Future<Respuesta> crearOactualizarInventario(Inventario inventario) async{
    isSaving = true;
    notifyListeners();

    if(inventario.id == null){
      final resp = await crearInventario(inventario);
      isSaving=false;
      notifyListeners();
      return resp;
    }else{
      final resp = await actualizarInventario(inventario);
      isSaving=false;
      notifyListeners();
      return resp;
    }
  }

  Future<Respuesta> crearInventario(Inventario inventario) async {
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

          return Respuesta(true, decodedData['mensaje']);
        } else {
          return Respuesta(false, decodedData['mensaje']);
        }
      } else {
        return Respuesta(false, 'Ocurrio un error en el servidor');
      }
    } catch (ex) {
      return Respuesta(false, 'Ocurrio un error en el servidor');
    }
  }

  Future<Respuesta> actualizarInventario(Inventario inventario) async {
    try {
      final token = await storage.read(key: 'token');
      final url = Uri.parse('http://13.65.191.65:9095/api/Inventarios/InventarioId:int?InventarioId=${inventario.id}');
      final inventario_envio = await inventario.toJsonCrear();
      print(url);
      print(inventario_envio);
      final resp = await http.put(url, body: inventario_envio, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (resp.statusCode == 200) {
        final decodedData = json.decode(resp.body);
        if (decodedData['success'] == true) {

          return Respuesta(true, decodedData['mensaje']);
        } else {
          return Respuesta(false, decodedData['mensaje']);
        }
      } else {
        return Respuesta(false, 'Ocurrio un error en el servidor');
      }
    } catch (ex) {
      return Respuesta(false, 'Ocurrio un error en el servidor');
    }
  }

}
