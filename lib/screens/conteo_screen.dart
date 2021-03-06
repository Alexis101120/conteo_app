import 'package:conteo_app/providers/conteo_form_provider.dart';
import 'package:conteo_app/providers/providers.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/ui/inputs_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConteoScreen extends StatelessWidget {
  const ConteoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movimientoService = Provider.of<MovimientoService>(context);
    final productoService = Provider.of<ProductoService>(context);

    return ChangeNotifierProvider(
      create: (_) => ConteoFormProvider(movimientoService.selectedMovimiento),
      child: _InventarioScreen(
        movimientoService: movimientoService,
        productoService: productoService,
      ),
    );
  }
}

class _InventarioScreen extends StatelessWidget {
  final MovimientoService movimientoService;
  final ProductoService productoService;
  const _InventarioScreen(
      {Key? key,
      required this.movimientoService,
      required this.productoService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final conteoForm = Provider.of<ConteoFormProvider>(context);
    final movimiento = conteoForm.movimiento;
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
                key: conteoForm.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      initialValue: movimiento.codigo,
                      onChanged: (value) => movimiento.codigo = value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'El codigo es obligatorio';
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Codigo', labelText: 'Codigo:'),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      autofocus: (movimiento.descripcion=="" ? true : false),
                      initialValue: movimiento.descripcion,
                      onChanged: (value) => movimiento.descripcion = value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'La descripcion es obligatoria';
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Ingrese descripci??n',
                          labelText: 'Descripci??n:'),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      autofocus: (movimiento.descripcion=="" ? false : true),
                      initialValue: '${movimiento.cantidad}',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^-?(\d+)?\.?\d{0,2}'))
                      ],
                      onChanged: (value) {
                        if (int.tryParse(value) == null) {
                          movimiento.cantidad = 0;
                        } else {
                          movimiento.cantidad = int.parse(value);
                        }
                      },
                      validator: ( value ) {
                         if (int.tryParse(value!) == null) {
                           return 'EL numero es obligatorio';
                        }
                      },
                      keyboardType: const TextInputType.numberWithOptions(signed: true),
                      decoration: InputDecorations.authInputDecoration(
                          hintText: '0', labelText: 'Cantidad:'),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FloatingActionButton(
          elevation: 5.0,
          child: movimientoService.isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.save_outlined),
          onPressed: movimientoService.isSaving
              ? null
              : () async {
                  FocusScope.of(context).unfocus();

                  if (!conteoForm.isValidForm()) return;
                  final resp = await movimientoService
                      .crearOactualizarInventario(conteoForm.movimiento);
                  if (resp.success) {
                    await movimientoService.loadMovimientos();
                    await productoService.loadProductos();
                    await NotificationsService.showSnackbar(resp.mensaje,
                        colorBg: Colors.green.shade500);
                    Navigator.pop(context);
                  } else {
                    NotificationsService.showSnackbar(resp.mensaje,
                        colorBg: Colors.red.shade400);
                  }
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
