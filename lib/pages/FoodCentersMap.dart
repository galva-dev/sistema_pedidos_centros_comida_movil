import 'package:flutter/material.dart';

class FoodCentersMapPage extends StatefulWidget {
  const FoodCentersMapPage({Key key}) : super(key: key);

  @override
  _FoodCentersMapPageState createState() => _FoodCentersMapPageState();
}

class _FoodCentersMapPageState extends State<FoodCentersMapPage> {
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
                Colors.green.shade900,
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
                  Text('MAPA')
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
