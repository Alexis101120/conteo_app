import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductoTiles extends StatelessWidget {
  const ProductoTiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productoService = Provider.of<ProductoService>(context, listen: true);
    return RefreshIndicator(
      onRefresh: productoService.loadProductos,
      child: Column(
        children: [
          _SearchWidget(),
          productoService.isSearch ? CircularProgressIndicator() :
          Expanded(
            child: ListView.builder(
              itemCount: productoService.productos.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.arrow_right_sharp, color: Colors.indigo),
                title:
                    Text(productoService.productos[i].codigo ?? '', style: _style()),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productoService.productos[i].descripcion ?? 'Sin descripción',
                      style: _style(),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text('Cantidad : ${productoService.productos[i].existencia}',
                        style: _style()),
                    const Divider()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _style() => const TextStyle(
        fontSize: 18,
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
    final productoService = Provider.of<ProductoService>(context, listen: true);     
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
          productoService.loadProductos();
        }else{
          productoService.filtarProductos(value);
        }
        },
        decoration: InputDecoration(
           icon: const Icon(Icons.search, color: Colors.indigoAccent,),
           suffixIcon: GestureDetector(
              child: const Icon(Icons.close, color: Colors.indigoAccent,),
              onTap: (){
                _controller.clear();
                productoService.loadProductos();
                FocusScope.of(context).requestFocus(FocusNode());
              },
           ),
        ),    
      ),  
    );
  }
}

