import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tractian_challenge/app/controllers/assets_controller.dart';
import 'package:tractian_challenge/app/views/assets_page.dart';

import 'app/views/home_page.dart';

GetIt getIt = GetIt.I;

void main() {
  getIt.registerSingleton<AssetsController>(AssetsController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Routes routes = Routes();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF17192D), secondary: Color(0xFF2188FF)),
          fontFamily: 'Roboto'),
      initialRoute: routes.initial,
      routes: Routes.list,
      navigatorKey: Routes.navigatorKey,
    );
  }
}

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (context) => const HomePage(),
    '/assets': (context) => const AssetsPage(),
  };

  String initial = '/home';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
