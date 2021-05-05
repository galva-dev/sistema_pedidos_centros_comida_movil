import 'package:flutter/material.dart';

class ScannerQRPage extends StatefulWidget {
  const ScannerQRPage({Key key}) : super(key: key);

  @override
  _ScannerQRPageState createState() => _ScannerQRPageState();
}

class _ScannerQRPageState extends State<ScannerQRPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 21, 21, 21),
                Colors.red.shade900,
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 33),
              child: Column(
                children: [
                  Text('SCANNER')
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
