import 'package:flutter/material.dart';

import 'classes/app_route.dart';
import 'pages/add_page.dart';
import 'pages/edit_page.dart';
import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Consumo de API',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        routes: {
          AppRoutes.HOME_PAGE: (_) => HomePage(),
          AppRoutes.ADD_PAGE: (_) => AddPage(),
          AppRoutes.EDIT_PAGE: (_) => EditPage()
        });
  }
}
