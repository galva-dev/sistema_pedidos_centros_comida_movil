import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/pages/SplashScreenPage.dart';
import 'package:sistema_registro_pedidos/pages/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sistema_registro_pedidos/provider/GoogleProvider.dart';
import 'package:sistema_registro_pedidos/provider/MiPedido.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => MiPedido()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Bree', primaryColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: SplashPage(
          duration: 4300,
          goToPage: WelcomePage(),
        ),
      ),
    ),
  );
}
