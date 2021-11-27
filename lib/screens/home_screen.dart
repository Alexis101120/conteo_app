import 'package:conteo_app/screens/screens.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/widgets/tienda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tiendaService = Provider.of<TiendaService>(context, listen: true);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (tiendaService.isLoading == true) {
      return const LoadingScreen();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Tiendas'),
          actions: [
            IconButton(
                onPressed: () async {
                  await authService.logout();
                  Navigator.of(context).pushReplacementNamed('login');
                },
                icon: Icon(Icons.login_outlined))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: tiendaService.loadTiendas,
          child: ListView.builder(
            itemCount: tiendaService.tiendas.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt('Tienda', tiendaService.tiendas[index].id);
                Navigator.pushNamed(context, 'inventarios');
              },
              child: TiendaCard(tienda: tiendaService.tiendas[index]),
            ),
          ),
        ));
  }
}
