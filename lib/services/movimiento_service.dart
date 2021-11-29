import 'dart:convert';

import 'package:conteo_app/models/movimiento.dart';
import 'package:conteo_app/models/respuesta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MovimientoService extends ChangeNotifier {
  final storage = FlutterSecureStorage();
  List<Movimiento> movimientos = [];
  late Movimiento selectedMovimiento;

  bool isLoading = true;
  bool isSaving = false;

  MovimientoService() {
    loadMovimientos();
  }

  Future<List<Movimiento>> loadMovimientos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await storage.read(key: 'token');
    final inventarioId = await prefs.getInt('Inventario');
    isLoading = true;
    movimientos = [];
    notifyListeners();
    final url = Uri.parse(
        'http://13.65.191.65:9095/api/Movimientos/ObtenTodos/${inventarioId!}');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (resp.statusCode == 200) {
      final movimientoMap = json.decode(resp.body);
      final List<dynamic> listaMovimiento = movimientoMap['data'];
      listaMovimiento.forEach((element) {
        final tempMovimiento = Movimiento.fromMap(element);
        movimientos.add(tempMovimiento);
      });
      isLoading = false;
      notifyListeners();
      return movimientos;
    }
    isLoading = false;
    notifyListeners();
    return movimientos;
  }

  Future<Respuesta> crearOactualizarInventario(Movimiento movimiento) async {
    isSaving = true;
    notifyListeners();

    if (movimiento.id == null) {
      final resp = await crearMovimiento(movimiento);
      isSaving = false;
      notifyListeners();
      return resp;
    } else {
      final resp = await actualizarMovimiento(movimiento);
      isSaving = false;
      notifyListeners();
      return resp;
    }
  }

  Future<Respuesta> crearMovimiento(Movimiento movimiento) async {
    try {
      print(movimiento);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = await storage.read(key: 'token');
      final url = Uri.parse('http://13.65.191.65:9095/api/Movimientos');
      movimiento.inventarioId = prefs.getInt('Inventario');
      final movimientoEnvio = movimiento.toJson();
      final resp = await http.post(url, body: movimientoEnvio, headers: {
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

  Future<Respuesta> actualizarMovimiento(Movimiento movimiento) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = await storage.read(key: 'token');
      final url = Uri.parse('http://13.65.191.65:9095/api/Movimientos');
      movimiento.inventarioId = await prefs.getInt('Inventario');
      final movimiento_envio = await movimiento.toJson();
      final resp = await http.post(url, body: movimiento_envio, headers: {
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
      return Respuesta(false, '$ex');
    }
  }

  Future<Respuesta> eliminarMovimiento(int movimiento) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = await storage.read(key: 'token');
      final url =
          Uri.parse('http://13.65.191.65:9095/api/Movimientos/$movimiento');
      final resp = await http.delete(url, headers: {
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
    } catch (e) {
      return Respuesta(false, '$e');
    }
  }
}
