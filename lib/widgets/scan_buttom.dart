import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanButon extends StatelessWidget {
  const ScanButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3d8bef', 'Cancelar', false, ScanMode.BARCODE);
        NotificationsService.showSnackbar(barcodeScanRes);
      },
      child: const Icon(Icons.filter_center_focus),
    );
  }
}
