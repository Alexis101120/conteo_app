import 'package:conteo_app/models/inventario.dart';
import 'package:conteo_app/providers/providers.dart';
import 'package:conteo_app/screens/screens.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/widgets/inventario_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventariosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inventarioService =
        Provider.of<InventarioService>(context, listen: true);
    final movimientoService = Provider.of<MovimientoService>(context);
    final productoService = Provider.of<ProductoService>(context, listen: true);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (inventarioService.isLoading) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventarios'),
        actions: [
          IconButton(
              onPressed: () async {
                await authService.logout();
                // Navigator.of(context).pushReplacementNamed('login');
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'login', (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.login_outlined))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: inventarioService.loadInventarios,
        child: Column(
          children: [
           const _SearchWidget(),
          inventarioService.isSearch ? const CircularProgressIndicator() :
            Expanded(
              child: ListView.builder(
                itemCount: inventarioService.inventarios.length,
                itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onLongPress: () {
                    inventarioService.selectedInventario =
                        inventarioService.inventarios[index];
                    Navigator.pushNamed(context, 'inventario');
                  },
                  onDoubleTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final correo = prefs.getString('Correo');
                    Navigator.pushNamed(context, 'correo', arguments: {
                      'correo': correo,
                      'inventarioId': inventarioService.inventarios[index].id
                    });
                  },
                  onTap: () async {
                    if (inventarioService.inventarios[index].activo!) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      final uiProvider =
                          Provider.of<UiProvider>(context, listen: false);
                      uiProvider.selectedMenuOpt = 0;
                      prefs.setInt(
                          'Inventario', inventarioService.inventarios[index].id!);
                      movimientoService.loadMovimientos();
                      productoService.loadProductos();
                      Navigator.pushNamed(context, 'mov_index');
                    } else {
                      NotificationsService.showSnackbar(
                        'Inventario cerrado',
                        colorBg: Colors.yellow.shade700,
                      );
                    }
                  },
                  child: InventarioCard(
                      inventario: inventarioService.inventarios[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          inventarioService.selectedInventario = Inventario(
            activo: false,
            fecha: DateTime.now(),
            nombre: "",
          );
          Navigator.pushNamed(context, 'inventario');
        },
      ),
    );
  }
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
       final inventarioService =
        Provider.of<InventarioService>(context, listen: true);
     
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
          inventarioService.loadInventarios();
        }else{
          inventarioService.filtrarInventarios(value);
        }        
        },
        decoration: InputDecoration(
           icon: const Icon(Icons.search, color: Colors.indigoAccent,),
           suffixIcon: GestureDetector(
              child: const Icon(Icons.close, color: Colors.indigoAccent,),
              onTap: (){
                _controller.clear();
                inventarioService.loadInventarios();
                FocusScope.of(context).requestFocus(FocusNode());
              },
           ),
        ),    
      ),  
    );
  }
}

