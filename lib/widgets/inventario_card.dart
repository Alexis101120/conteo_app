import 'package:conteo_app/models/models.dart';
import 'package:flutter/material.dart';

class InventarioCard extends StatelessWidget {
  final Inventario inventario;
  const InventarioCard({Key? key, required this.inventario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: inventario.activo! ? Colors.green.shade50 : Colors.red.shade50,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            leading: inventario.activo!
                ? Icon(Icons.lock_open)
                : Icon(Icons.lock_outline),
            title: Column(
              children: [
                Text(
                  inventario.nombre!,
                  style: const TextStyle(
                      fontSize: 16.0, overflow: TextOverflow.ellipsis),
                ),
                Text(
                  'Usuario : ${inventario.usuario}',
                  style: const TextStyle(
                      fontSize: 16.0, overflow: TextOverflow.ellipsis),
                ),
                Text(
                  '${inventario.fecha!.day}-${inventario.fecha!.month}-${inventario.fecha!.year}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
