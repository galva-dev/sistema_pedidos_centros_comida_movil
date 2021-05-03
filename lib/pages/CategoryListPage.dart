import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/helpers/Utils.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/provider/GoogleProvider.dart';
import 'package:sistema_registro_pedidos/widgets/AppBarWidget.dart';
import 'package:sistema_registro_pedidos/widgets/CardListCategoriesWidget.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  int currentIndex = 0;
  List<Category> categories = Utils.getMockedCategories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: MainAppBar(),
      body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                ),
              )),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final provider =
                        Provider.of<GoogleSignInProvider>(context, listen: false);
                        provider.logout();
                      },
                      child: Text('Logout'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        'Seleccione una categoria',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      itemCount: categories.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CardListCategories(
                          category: categories[index],
                          onCardClick: () {
                            //TODO navigate to another page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectedCategoryPage(
                                          selectedCategory:
                                              this.categories[index],
                                        )));
                          },
                        );
                      },
                    ))
                  ],
                ),
              ),
            ],
          )),
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
              title: Text('       Menus'),
              activeColor: Colors.orange,
              inactiveColor: Colors.blueGrey),
          BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.shoppingCart,
              ),
              title: Text('       Pedido'),
              activeColor: Colors.blueAccent,
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
                FontAwesomeIcons.newspaper,
              ),
              title: Text('       Noticias'),
              activeColor: Colors.red,
              inactiveColor: Colors.blueGrey),
        ],
      ),
    );
  }
}
