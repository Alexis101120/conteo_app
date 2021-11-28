import 'package:conteo_app/providers/providers.dart';
import 'package:conteo_app/screens/inventarios_screen.dart';
import 'package:conteo_app/screens/screens.dart';
import 'package:conteo_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TiendaService()),
        ChangeNotifierProvider(create: (_) => InventarioService()),
        ChangeNotifierProvider(create: (_) => ProductoService()),
        ChangeNotifierProvider(create: (_) => UiProvider()),
        ChangeNotifierProvider(create: (_) => MovimientoService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conteo App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'inventarios': (_) => InventariosScreen(),
        'inventario': (_) => InventarioScreen(),
        'mov_index': (_) => MovimientosIndex(),
        'conteo' : (_) => ConteoScreen()
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
