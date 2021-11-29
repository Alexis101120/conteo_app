import 'package:flutter/material.dart';

class CorreoFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  int? inventarioId;
  String correo;

  CorreoFormProvider(this.inventarioId, this.correo);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
