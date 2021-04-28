import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/helpers/Utils.dart';
import 'package:sistema_registro_pedidos/pages/CategoryListPage.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/pages/SplashScreenPage.dart';
import 'package:sistema_registro_pedidos/pages/WelcomePage.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Bree'),
        debugShowCheckedModeBanner: false,
        home: SplashPage(duration: 4500, goToPage: WelcomePage(),),
      )
  );
}


