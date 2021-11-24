import 'package:conteo_app/models/models.dart';
import 'package:flutter/material.dart';

class InventarioCard extends StatelessWidget {
  final Inventario inventario;
  const InventarioCard({Key? key, required this.inventario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Fecha :${inventario.fecha}'),
              subtitle: Text('Usuario : ${inventario.usuario}'))
        ],
      ),
    );
  }
}
