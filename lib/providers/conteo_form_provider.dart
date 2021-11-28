
import 'package:conteo_app/models/models.dart';

import 'package:flutter/material.dart';

class ConteoFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Movimiento movimiento;

  ConteoFormProvider(this.movimiento);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
