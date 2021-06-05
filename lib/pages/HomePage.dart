import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/pages/CategoryListPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/pages/FoodCentersMapPage.dart';
import 'package:sistema_registro_pedidos/pages/ProfilePage.dart';
import 'package:sistema_registro_pedidos/widgets/AppBarWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int currentIndex = 0;
  List listBottomBar = [CategoryListPage(), FoodCentersMapPage(), ProfilePage()];
  int indexProvider = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: listBottomBar[indexProvider],
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 500),
        curve: Curves.easeInBack,
        selectedIndex: indexProvider,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        onItemSelected: (index) {
          setState(() {
            indexProvider = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.utensils,
              ),
              title: Text('       Menu'),
              activeColor: Colors.orange,
              inactiveColor: Colors.blueGrey),
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.mapMarkedAlt,
              ),
              title: Text('       Mapa'),
              activeColor: Colors.green,
              inactiveColor: Colors.blueGrey),
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.userAlt,
              ),
              title: Text('       Mi perfil'),
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.blueGrey),
        ],
      ),
    );
  }
}
