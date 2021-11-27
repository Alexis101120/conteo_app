import 'package:conteo_app/screens/screens.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/widgets/scan_tiles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovimientosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movimientoService =
        Provider.of<MovimientoService>(context, listen: true);

    if (movimientoService.isLoading) {
      return Center(child: const CircularProgressIndicator());
    }
    return const ScanTiles();
  }
}
