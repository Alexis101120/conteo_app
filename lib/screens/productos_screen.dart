import 'dart:async';

import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/widgets/productos_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productoService =
        Provider.of<ProductoService>(context, listen: true);
    if(productoService.isLoading){
       return Center(child: const CircularProgressIndicator());
    }
    return const ProductoTiles();
  }
}
