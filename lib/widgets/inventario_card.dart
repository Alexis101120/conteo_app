import 'package:conteo_app/models/models.dart';
import 'package:flutter/material.dart';

class InventarioCard extends StatelessWidget {
  final Inventario inventario;
  const InventarioCard({Key? key, required this.inventario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 13.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Column(
              children: [
                Text(
                  inventario.nombre!,
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'Usuario : ${inventario.usuario}',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  '${inventario.fecha!.day}-${inventario.fecha!.month}-${inventario.fecha!.year}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
