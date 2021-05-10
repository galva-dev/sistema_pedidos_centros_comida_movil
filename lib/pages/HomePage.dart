import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/helpers/Utils.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/pages/CategoryListPage.dart';
import 'package:sistema_registro_pedidos/pages/FoodCentersMapPage.dart';
import 'package:sistema_registro_pedidos/pages/ProfilePage.dart';
import 'package:sistema_registro_pedidos/pages/ScannerQRPage.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/provider/GoogleProvider.dart';
import 'package:sistema_registro_pedidos/widgets/AppBarWidget.dart';
import 'package:sistema_registro_pedidos/widgets/CardListCategoriesWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List listBottomBar = [
    CategoryListPage(),
    ScannerQRPage(),
    FoodCentersMapPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(),
      appBar: MainAppBar(),
      body: listBottomBar[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        animationDuration: Duration(milliseconds: 500),
        curve: Curves.easeInBack,
        selectedIndex: currentIndex,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
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
                FontAwesomeIcons.shoppingCart,
              ),
              title: Text('       Pedido'),
              activeColor: Colors.red,
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
