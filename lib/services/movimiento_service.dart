import 'dart:convert';

import 'package:conteo_app/models/movimiento.dart';
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
    print(resp.body);
    if (resp.statusCode == 200) {
      final movimientoMap = json.decode(resp.body);
      final List<dynamic> listaMovimiento = movimientoMap['data'];
      listaMovimiento.forEach((element) {
        final tempMovimiento = Movimiento.fromMap(element);
        movimientos.add(tempMovimiento);
      });
      isLoading = false;
      notifyListeners();
      print(movimientos);
      return movimientos;
    }
    isLoading = false;
    notifyListeners();
    return movimientos;
  }
}
