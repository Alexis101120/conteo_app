import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductoTiles extends StatelessWidget {
  const ProductoTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(context, listen: true);
    final authService = Provider.of<AuthService>(context, listen: false);
    return RefreshIndicator(
      onRefresh: productoService.loadProductos,
      child: ListView.builder(
        itemCount: productoService.productos.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.arrow_right_sharp, color: Colors.indigo),
          title:
              Text(productoService.productos[i].codigo ?? '', style: _style()),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productoService.productos[i].descripcion ?? 'Sin descripción',
                style: _style(),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text('Cantidad : ${productoService.productos[i].existencia}',
                  style: _style()),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _style() => const TextStyle(
        fontSize: 18,
        color: Colors.black,
      );
}
