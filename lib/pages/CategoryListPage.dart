import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/helpers/Utils.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/widgets/CardList.dart';

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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: 50,
              child: Image.asset('assets/images/logo.png'),
            ),
            Spacer(),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 0),
            padding: EdgeInsets.all(5),
            child: ClipOval(
              child: Container(
                color: Colors.black,
                width: 45,
                height: 40,
                child: Image(
                  image: Image.asset('assets/images/category/postre.jpg').image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
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
                )
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                        itemBuilder: (BuildContext ctx, int index){
                          return CardList(
                            category: categories[index],
                            onCardClick: (){
                              //TODO navigate to another page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:(context) => SelectedCategoryPage()
                                )
                              );
                            },
                          );
                        },
                      )
                  )
                ],
              ),
            ),
            /*Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                padding: EdgeInsets.only(bottom: 5, top: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 20, 20, 20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset.zero
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.red.withOpacity(0.6),
                        highlightColor: Colors.white.withOpacity(0.9),
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.all(10),
                           child: Icon(FontAwesomeIcons.utensils, color: Colors.red,),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.red.withOpacity(0.6),
                        highlightColor: Colors.white.withOpacity(0.9),
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(FontAwesomeIcons.shoppingCart, color: Colors.red,),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.red.withOpacity(0.6),
                        highlightColor: Colors.white.withOpacity(0.9),
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.red,),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.red.withOpacity(0.6),
                        highlightColor: Colors.white.withOpacity(0.9),
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(FontAwesomeIcons.newspaper, color: Colors.red,),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),*/
          ],
        )
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        animationDuration: Duration(milliseconds: 500),
        curve: Curves.easeInBack,
        selectedIndex: currentIndex,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        onItemSelected: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(FontAwesomeIcons.utensils,),
            title: Text('       Menus'),
            activeColor: Colors.orange,
            inactiveColor: Colors.blueGrey
          ),
          BottomNavyBarItem(
              icon: Icon(FontAwesomeIcons.shoppingCart,),
              title: Text('       Pedido'),
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.blueGrey
          ),
          BottomNavyBarItem(
              icon: Icon(FontAwesomeIcons.mapMarkedAlt,),
              title: Text('       Mapa'),
              activeColor: Colors.green,
              inactiveColor: Colors.blueGrey
          ),
          BottomNavyBarItem(
              icon: Icon(FontAwesomeIcons.newspaper,),
              title: Text('       Noticias'),
              activeColor: Colors.red,
              inactiveColor: Colors.blueGrey
          ),
        ],
      ),
    );
  }
}
