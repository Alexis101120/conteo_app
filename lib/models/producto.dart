// To parse this JSON data, do
//
//     final producto = productoFromMap(jsonString);

import 'dart:convert';

class Producto {
    Producto({
        this.id,
        this.codigo,
        this.inventarioId,
        this.existencia,
        this.descripcion,
    });

    final int? id;
    final String? codigo;
    final int? inventarioId;
    final int? existencia;
    final String? descripcion;

    factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        id: json["id"],
        codigo: json["codigo"],
        inventarioId: json["inventario_Id"],
        existencia: json["existencia"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codigo": codigo,
        "inventario_Id": inventarioId,
        "existencia": existencia,
        "descripcion": descripcion,
    };
}
