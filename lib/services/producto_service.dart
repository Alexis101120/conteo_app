import 'dart:convert';
import 'package:conteo_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductoService extends ChangeNotifier {
  final storage = FlutterSecureStorage();
  List<Producto> productos = [];
  late Producto selectedMovimiento;

  bool isLoading = true;
  bool isSaving = false;

  ProductoService() {
    loadProductos();
  }

  Future<List<Producto>> loadProductos() async {
    isLoading = true;
    productos = [];
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await storage.read(key: 'token');
    final inventarioId = await prefs.getInt('Inventario');
    final url = Uri.parse(
        'http://13.65.191.65:9095/api/ProductosInventario/ObtenTodos/${inventarioId}');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (resp.statusCode == 200) {
      final productoMap = json.decode(resp.body);
      final List<dynamic> listaProductos = productoMap['data'];
      listaProductos.forEach((element) {
        final tempProducto = Producto.fromMap(element);
        productos.add(tempProducto);
      });
      isLoading = false;
      notifyListeners();
      return productos;
    } else {
      isLoading = false;
      notifyListeners();
      return productos;
    }
  }

  Future<String> loadProducto(String codigo) async {
    isLoading = true;
    notifyListeners();
    final token = await storage.read(key: 'token');
    final url =
        Uri.parse('http://13.65.191.65:9095/api/Productos/ByCodigo/$codigo');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (resp.statusCode == 200) {
      final productoMap = json.decode(resp.body);
      final data = productoMap['data'];
      if (data == null) {
        isLoading = false;
        notifyListeners();
        return '';
      } else {
        isLoading = false;
        notifyListeners();
        return data['descripcion'];
      }
    } else {
      isLoading = false;
      notifyListeners();
      return '';
    }
  }
}
