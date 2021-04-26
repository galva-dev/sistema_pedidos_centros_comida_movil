import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  SplashPage({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            ImageSplash(),
            Spacer(),
            //TitleSplash(),
          ],
        )),
      ),
    );
  }
}

class TitleSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'UNIVERSIDAD DEL VALLE',
      style: TextStyle(
          color: Colors.black26, fontSize: 30, fontFamily: 'Freshman'),
    );
  }
}

class ImageSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Image.asset('assets/images/logo.png'),
    );
  }
}
