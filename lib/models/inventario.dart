// To parse this JSON data, do
//
//     final tienda = tiendaFromMap(jsonString);

import 'dart:convert';

class Inventario {
  Inventario({this.id, this.fecha, this.activo, this.usuario, this.nombre});

  final int? id;
  final DateTime? fecha;
  final bool? activo;
  final String? usuario;
  final String? nombre;

  factory Inventario.fromJson(String str) =>
      Inventario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

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

  Inventario copy() => Inventario(
        activo: this.activo,
        nombre: this.nombre,
        fecha: this.fecha,
      );
}
