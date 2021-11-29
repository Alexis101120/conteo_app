import 'package:conteo_app/providers/providers.dart';
import 'package:conteo_app/screens/screens.dart';
import 'package:conteo_app/services/services.dart';
import 'package:conteo_app/widgets/custom_navigator_bar.dart';
import 'package:conteo_app/widgets/scan_buttom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovimientosIndex extends StatelessWidget {
  const MovimientosIndex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inventario'),
          actions: [
            IconButton(
                onPressed: () async {
                  await authService.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'login', (Route<dynamic> route) => false);
                },
                icon: Icon(Icons.login_outlined))
          ],
        ),
        body: const _HomePageBody(),
        bottomNavigationBar: const CustomNavigationBar(),
        floatingActionButton: const ScanButon(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;
    switch (currentIndex) {
      case 0:
        return MovimientosScreen();
      case 1:
        return ProductosScreen();
      default:
        return MovimientosScreen();
    }
  }
}
