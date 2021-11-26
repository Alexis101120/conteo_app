// To parse this JSON data, do
//
//     final tienda = tiendaFromMap(jsonString);

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Inventario {
  Inventario({this.id, this.fecha, this.activo, this.usuario, this.nombre});

  int? id;
  DateTime? fecha;
  bool? activo;
  String? usuario;
  String? nombre;

  factory Inventario.fromJson(String str) =>
      Inventario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Future<String> toJsonCrear() async => json.encode(await toMapCrear());

  factory Inventario.fromMap(Map<String, dynamic> json) => Inventario(
      id: json["id"],
      fecha: DateTime.parse(json["fecha"]),
      activo: json["activo"],
      usuario: json["usuario"],
      nombre: json["nombre"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "fecha": fecha,
        "activo": activo,
        "usuario": usuario,
        "nombre": nombre
      };

  Future<Map<String, dynamic>> toMapCrear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tiendaId = await prefs.getInt('Tienda');
    return {"activo": activo, "nombre": nombre, "tienda_id": tiendaId};
  }

  Inventario copy() => Inventario(
        activo: this.activo,
        nombre: this.nombre,
        fecha: this.fecha,
      );
}
