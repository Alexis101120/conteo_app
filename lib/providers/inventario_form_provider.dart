import 'package:conteo_app/models/models.dart';
import 'package:flutter/material.dart';

class InventarioFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Inventario inventario;

  InventarioFormProvider(this.inventario);

  updateAvailability(bool value) {
    inventario.activo = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
