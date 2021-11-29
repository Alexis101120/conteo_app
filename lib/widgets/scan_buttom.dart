import 'package:conteo_app/models/models.dart';
import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ScanButon extends StatelessWidget {
  const ScanButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movimientoService =
        Provider.of<MovimientoService>(context, listen: true);
    final productoService = Provider.of<ProductoService>(context, listen: true);
    return FloatingActionButton(
      elevation: 0,
      onPressed: () async {
        try {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  '#3d8bef', 'Cancelar', true, ScanMode.BARCODE)
              .then((value) async {
            bool canVibrate = await Vibrate.canVibrate;
            Vibrate.vibrate();
            return value;
          });

          //TODO: implementar funcion para validar si existe el producto
          String descripcion = barcodeScanRes == -1
              ? ''
              : await productoService.loadProducto(barcodeScanRes);
          movimientoService.selectedMovimiento = Movimiento(
              cantidad: 0,
              descripcion: descripcion,
              codigo: (barcodeScanRes == -1) ? '' : barcodeScanRes);
          Navigator.pushNamed(context, 'conteo');
        } catch (e) {
          NotificationsService.showSnackbar(
            '$e',
            colorBg: Colors.yellow.shade200,
          );
        }
      },
      child: const Icon(Icons.filter_center_focus),
    );
  }
}
