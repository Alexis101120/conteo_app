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

   int? id;
   String? codigo;
   String? descripcion;
   int? cantidad;
   DateTime? fechRegistro;
   String? usuario;
   int? inventarioId;

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
        "codigo": codigo,
        "descripcion": descripcion,
        "cantidad": cantidad,
        "inventario_Id": inventarioId,
      };
}
