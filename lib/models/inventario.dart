// To parse this JSON data, do
//
//     final tienda = tiendaFromMap(jsonString);

import 'dart:convert';

class Inventario {
  Inventario({
    required this.id,
    required this.fecha,
    required this.activo,
    required this.usuario,
  });

  final int id;
  final DateTime fecha;
  final bool activo;
  final String usuario;

  factory Inventario.fromJson(String str) =>
      Inventario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Inventario.fromMap(Map<String, dynamic> json) => Inventario(
        id: json["id"],
        fecha: json["fecha"],
        activo: json["activo"],
        usuario: json["usuario"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "fecha": fecha,
        "activo": activo,
        "usuario": usuario,
      };
}
