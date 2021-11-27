import 'package:conteo_app/models/inventario.dart';
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
                Navigator.of(context).pushReplacementNamed('login');
              },
              icon: const Icon(Icons.login_outlined))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: inventarioService.loadInventarios,
        child: ListView.builder(
          itemCount: inventarioService.inventarios.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onLongPress: () =>
                NotificationsService.showSnackbar('Tap sostenido'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt(
                  'Inventario', inventarioService.inventarios[index].id!);
              Navigator.pushNamed(context, 'mov_index');
            },
            child: InventarioCard(
                inventario: inventarioService.inventarios[index]),
          ),
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
