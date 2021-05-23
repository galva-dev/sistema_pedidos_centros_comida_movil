import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/pages/HomePage.dart';
import 'package:sistema_registro_pedidos/pages/MapPage.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/pages/SplashScreenPage.dart';
import 'package:sistema_registro_pedidos/pages/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Bree', primaryColor: Colors.black),
    debugShowCheckedModeBanner: false,
    home: SplashPage(
      duration: 4300,
      goToPage: WelcomePage(),
    ),
  ));
}
