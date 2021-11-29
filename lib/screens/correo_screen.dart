import 'package:conteo_app/providers/providers.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/ui/inputs_decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CorreoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> args =
        ModalRoute.of(context)!.settings.arguments! as Map;
    String? correo = args['correo'];
    int? inventarioId = args["inventarioId"];
    final inventarioService = Provider.of<InventarioService>(context);
    return ChangeNotifierProvider(
        create: (_) => CorreoFormProvider(inventarioId!, correo ?? ''),
        child: _CorreoScreen(inventarioService: inventarioService));
  }
}

class _CorreoScreen extends StatelessWidget {
  final InventarioService inventarioService;

  const _CorreoScreen({Key? key, required this.inventarioService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final correoForm = Provider.of<CorreoFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envio de inventario'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          decoration: _buildBoxDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Form(
            key: correoForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              initialValue: correoForm.correo,
              onChanged: (value) => correoForm.correo = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'correo@ejemplo.com', labelText: 'Correo:'),
            ),
          ),
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: FloatingActionButton(
          elevation: 5.0,
          child: inventarioService.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.send),
          onPressed: inventarioService.isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();

                  if (!correoForm.isValidForm()) return;
                  final resp = await inventarioService.enviarInventario(
                      correoForm.inventarioId!, correoForm.correo);
                  if (resp.success) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final correo = prefs.setString('Correo', correoForm.correo);
                    NotificationsService.showSnackbar(resp.mensaje,
                        colorBg: Colors.green.shade500);
                  } else {
                    NotificationsService.showSnackbar(resp.mensaje,
                        colorBg: Colors.red.shade400);
                  }
                },
        ),
      ),
    );
  }
}

BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ]);
