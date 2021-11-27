// To parse this JSON data, do
//
//     final movimiento = movimientoFromMap(jsonString);

import 'dart:convert';

class Movimiento {
  Movimiento({
    this.id,
    this.codigo,
    this.descripcion,
    this.cantidad,
    this.fechRegistro,
    this.usuario,
    this.inventarioId,
  });

  final int? id;
  final String? codigo;
  final String? descripcion;
  final int? cantidad;
  final DateTime? fechRegistro;
  final String? usuario;
  final int? inventarioId;

  factory Movimiento.fromJson(String str) =>
      Movimiento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Movimiento.fromMap(Map<String, dynamic> json) => Movimiento(
        id: json["id"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        cantidad: json["cantidad"],
        fechRegistro: DateTime.parse(json["fech_Registro"]),
        usuario: json["usuario"],
        inventarioId: json["inventario_Id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "codigo": codigo,
        "descripcion": descripcion,
        "cantidad": cantidad,
        "fech_Registro": fechRegistro!.toIso8601String(),
        "usuario": usuario,
        "inventario_Id": inventarioId,
      };
}
