// To parse this JSON data, do
//
//     final tienda = tiendaFromMap(jsonString);

import 'dart:convert';

class Tienda {
  Tienda({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.logoUrl,
  });

  final int id;
  final String nombre;
  final String? descripcion;
  final String? logoUrl;

  factory Tienda.fromJson(String str) => Tienda.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tienda.fromMap(Map<String, dynamic> json) => Tienda(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        logoUrl: json["logo_url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "logo_url": logoUrl,
      };
}
