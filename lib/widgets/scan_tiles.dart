import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanTiles extends StatelessWidget {
  const ScanTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movimientoService =
        Provider.of<MovimientoService>(context, listen: true);
    final productoService =
        Provider.of<ProductoService>(context, listen: false);
    return RefreshIndicator(
      onRefresh: movimientoService.loadMovimientos,
      child: Column(

        children: [
          _SearchWidget(),
          movimientoService.isSearch ? CircularProgressIndicator() :
          Expanded(
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
                                onPressed: () async {
                                  final resp =
                                      await movimientoService.eliminarMovimiento(
                                          movimientoService.movimientos[i].id!);
                                  Navigator.of(context).pop(true);
                                  if (resp.success) {
                                    NotificationsService.showSnackbar(resp.mensaje,
                                        colorBg: Colors.green.shade500);
                                    productoService.loadProductos();
                                  } else {
                                    NotificationsService.showSnackbar(resp.mensaje,
                                        colorBg: Colors.red.shade500);
                                  }
                                },
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
                        Text(movimientoService.movimientos[i].usuario ?? ''),
                        const Divider()
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _style() => const TextStyle(
        fontSize: 17,
        color: Colors.black,
      );
}




class _SearchWidget extends StatefulWidget {
  const _SearchWidget({ Key? key }) : super(key: key);

  @override
  State<_SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<_SearchWidget> {
  final _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
       final movimientoService =
        Provider.of<MovimientoService>(context, listen: false);
     
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),     
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: _controller,
        onChanged: (value){
        if(value.isEmpty){
          movimientoService.loadMovimientos();
        }else{
          movimientoService.filtarMovimientos(value);
        }        
        },
        decoration: InputDecoration(
           icon: const Icon(Icons.search, color: Colors.indigoAccent,),
           suffixIcon: GestureDetector(
              child: const Icon(Icons.close, color: Colors.indigoAccent,),
              onTap: (){
                _controller.clear();
                movimientoService.loadMovimientos();
                FocusScope.of(context).requestFocus(FocusNode());
              },
           ),
        ),    
      ),  
    );
  }
}
