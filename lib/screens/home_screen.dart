import 'package:conteo_app/screens/screens.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/widgets/tienda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tiendaService = Provider.of<TiendaService>(context, listen: true);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (tiendaService.isLoading == true) {
      return const LoadingScreen();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Tiendas'),
            actions: [
              IconButton(
                  onPressed: () async {
                    await authService.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'login', (Route<dynamic> route) => true);
                  },
                  icon: Icon(Icons.login_outlined))
            ],
          ),
          body: RefreshIndicator(
            onRefresh: tiendaService.loadTiendas,
            child: ListView.builder(
              itemCount: tiendaService.tiendas.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {},
                child: TiendaCard(tienda: tiendaService.tiendas[index]),
              ),
            ),
          ));
    }
    return Container();
  }
}
