import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sistema_registro_pedidos/helpers/BouncyPageRoute.dart';

class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  SplashPage({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: this.duration), () {
      Navigator.pushAndRemoveUntil(context, BouncyPageRoute(widget: goToPage),
          (Route<dynamic> route) => false);
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Center(
          child: Lottie.asset('assets/lottie/splash2.json'),
        ),
      ),
    );
  }
}
