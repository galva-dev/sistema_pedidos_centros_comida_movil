import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(duration: 3, goToPage: WelcomePage(),),
      )

  );
}

class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  SplashPage({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: this.duration),(){
      Navigator.push(context, MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 21, 21, 21),
        alignment: Alignment.center,
        child: Center(
          child: Column(
            children: [
              Spacer(),
              ImageSplash(),
              // TitleSplash(),
              Spacer()
            ],
          )
        ),
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
          color: Colors.white,
          fontSize: 30,
          fontFamily: 'Freshman'
      ),
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

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text('Gelloa'),
      ),
    );
  }
}

