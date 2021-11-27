import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanTiles extends StatelessWidget {
  const ScanTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movimientoService =
        Provider.of<MovimientoService>(context, listen: true);
    final authService = Provider.of<AuthService>(context, listen: false);
    return RefreshIndicator(
      onRefresh: movimientoService.loadMovimientos,
      child: ListView.builder(
        itemCount: movimientoService.movimientos.length,
        itemBuilder: (_, i) => Dismissible(
            direction: DismissDirection.horizontal,
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirmación"),
                    content: const Text(
                        "Deseas eliminar el movimiento? será afectado el conteo"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Si eliminar")),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancelar"),
                      ),
                    ],
                  );
                },
              );
            },
            background: Container(
              color: Colors.red.shade300,
              child: const Center(
                heightFactor: 100,
                widthFactor: 100,
                child: Text(
                  'Eliminar',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            key: UniqueKey(),
            child: ListTile(
              leading:
                  const Icon(Icons.arrow_right_sharp, color: Colors.indigo),
              title: Text(movimientoService.movimientos[i].codigo ?? '',
                  style: _style()),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movimientoService.movimientos[i].descripcion ??
                        'Sin descripción',
                    style: _style(),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                      'Cantidad : ${movimientoService.movimientos[i].cantidad}',
                      style: _style()),
                  Text(
                    '${movimientoService.movimientos[i].fechRegistro!.day}-${movimientoService.movimientos[i].fechRegistro!.month}-${movimientoService.movimientos[i].fechRegistro!.year}',
                    // '${inventario.fecha!.day}-${inventario.fecha!.month}-${inventario.fecha!.year}',
                    style: _style(),
                    textAlign: TextAlign.start,
                  ),
                  Text(movimientoService.movimientos[i].usuario ?? '')
                ],
              ),
            )),
      ),
    );
  }

  TextStyle _style() => const TextStyle(
        fontSize: 18,
        color: Colors.black,
      );
}
