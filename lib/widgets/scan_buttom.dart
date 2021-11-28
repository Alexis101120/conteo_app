import 'package:conteo_app/models/models.dart';
import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class ScanButon extends StatelessWidget {
  const ScanButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final movimientoService =
        Provider.of<MovimientoService>(context, listen: true);
    final productoService =
        Provider.of<ProductoService>(context, listen: true);
    return FloatingActionButton(
      elevation: 0,
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3d8bef', 'Cancelar', false, ScanMode.BARCODE);
        //TODO: implementar funcion para validar si existe el producto
        String descripcion = barcodeScanRes ==-1 ? '' : await productoService.loadProducto(barcodeScanRes);
        movimientoService.selectedMovimiento = Movimiento(
          cantidad: 0,
          descripcion: descripcion,
          codigo: (barcodeScanRes == -1) ? '' : barcodeScanRes
        );
        Navigator.pushNamed(context, 'conteo');
      },
      child: const Icon(Icons.filter_center_focus),
    );
  }
}
