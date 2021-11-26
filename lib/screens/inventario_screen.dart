import 'package:conteo_app/models/inventario.dart';
import 'package:conteo_app/providers/providers.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/ui/inputs_decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inventarioService = Provider.of<InventarioService>(context);
    return ChangeNotifierProvider(
      create: (_) =>
          InventarioFormProvider(inventarioService.selectedInventario),
      child: _InventarioScreen(inventarioService: inventarioService),
    );
  }
}

class _InventarioScreen extends StatelessWidget {
  final InventarioService inventarioService;

  const _InventarioScreen({Key? key, required this.inventarioService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventarioForm = Provider.of<InventarioFormProvider>(context);
    final inventario = inventarioForm.inventario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de inventario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
              decoration: _buildBoxDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Form(
                key: inventarioForm.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: inventario.nombre,
                      onChanged: (value) => inventario.nombre = value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'El nombre es obligatorio';
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Nombre de inventario',
                          labelText: 'Nombre:'),
                    ),
                    SizedBox(height: 30),
                    SwitchListTile.adaptive(
                        value: inventario.activo!,
                        title: Text('Activo'),
                        activeColor: Colors.indigo,
                        onChanged: inventarioForm.updateAvailability),
                    SizedBox(height: 30)
                  ],
                ),
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: FloatingActionButton(
          elevation: 5.0,
          child: inventarioService.isSaving
              ? CircularProgressIndicator(color: Colors.white)
              : Icon(Icons.save_outlined),
          onPressed: inventarioService.isSaving
              ? null
              : () async {
                  FocusScope.of(context).unfocus();

                  if (!inventarioForm.isValidForm()) return;
                  final resp = await inventarioService
                      .crearInventario(inventarioForm.inventario);
                  NotificationsService.showSnackbar(resp.mensaje);
                },
        ),
      ),
    );
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
}
