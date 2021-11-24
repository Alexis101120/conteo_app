import 'dart:convert';

import 'package:conteo_app/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TiendaService extends ChangeNotifier {
  List<Tienda> tiendas = [];
  late Tienda selectedTienda;

  bool isLoading = true;
  bool isSaving = false;

  TiendaService() {
    loadTiendas();
  }

  Future<List<Tienda>> loadTiendas() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://192.168.0.11:9090/api/Tiendas');
    final resp = await http.get(url);
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
