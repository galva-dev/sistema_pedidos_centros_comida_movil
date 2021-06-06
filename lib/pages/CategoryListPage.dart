import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/widgets/CardListCategoriesWidget.dart';
import 'package:http/http.dart' as http;

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key key}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Category> categories = [];

  Future _getBD() async {
    List<FoodCenter> _bares = [];
    List<FoodCenter> _cafe = [];
    List<FoodCenter> _rapida = [];
    List<FoodCenter> _postre = [];
    List<FoodCenter> _restaurante = [];
    List<FoodCenter> _tematico = [];
    List<Food> _food = [];

    final db = FirebaseDatabase.instance.reference().child('CentroComida');
    await db.once().then((value) {
      Map jsonData = value.value;
      jsonData.forEach((keyCC, valueCC) async {
        _food.clear();
        await db.child(keyCC.toString()).child('Menu').once().then((value) {
          Map comidas = value.value;
          comidas.forEach((keyC, valueC) {
            _food.add(Food(valueC['nombre'], double.parse(valueC['precio'].toString()),
                valueC['descripcion'], valueC['img']));
          });
        }).then((value) async {
          switch (int.parse(valueCC['tipo'].toString())) {
            case 1:
              _bares.add(FoodCenter(
                  valueCC['nombre'],
                  valueCC['numero'],
                  valueCC['descripcion'],
                  valueCC['horario'],
                  valueCC['latitud'],
                  valueCC['longitud'],
                  valueCC['direccion'],
                  valueCC['logo'],
                  valueCC['banner'],
                  valueCC['tipo'],
                  double.parse(valueCC['rating'].toString()),
                  Colors.blueAccent,
                  Icon(FontAwesomeIcons.glassMartiniAlt),
                  _food));
              break;
            case 2:
              _cafe.add(FoodCenter(
                  valueCC['nombre'],
                  valueCC['numero'],
                  valueCC['descripcion'],
                  valueCC['horario'],
                  valueCC['latitud'],
                  valueCC['longitud'],
                  valueCC['direccion'],
                  valueCC['logo'],
                  valueCC['banner'],
                  valueCC['tipo'],
                  double.parse(valueCC['rating'].toString()),
                  Colors.red,
                  Icon(FontAwesomeIcons.mugHot),
                  _food));
              break;
            case 3:
              _rapida.add(FoodCenter(
                  valueCC['nombre'],
                  valueCC['numero'],
                  valueCC['descripcion'],
                  valueCC['horario'],
                  valueCC['latitud'],
                  valueCC['longitud'],
                  valueCC['direccion'],
                  valueCC['logo'],
                  valueCC['banner'],
                  valueCC['tipo'],
                  double.parse(valueCC['rating'].toString()),
                  Colors.brown,
                  Icon(FontAwesomeIcons.hamburger),
                  _food));
              break;
            case 4:
              _postre.add(FoodCenter(
                  valueCC['nombre'],
                  valueCC['numero'],
                  valueCC['descripcion'],
                  valueCC['horario'],
                  valueCC['latitud'],
                  valueCC['longitud'],
                  valueCC['direccion'],
                  valueCC['logo'],
                  valueCC['banner'],
                  valueCC['tipo'],
                  double.parse(valueCC['rating'].toString()),
                  Colors.cyanAccent,
                  Icon(FontAwesomeIcons.iceCream),
                  _food));
              break;
            case 5:
              _restaurante.add(FoodCenter(
                  valueCC['nombre'],
                  valueCC['numero'],
                  valueCC['descripcion'],
                  valueCC['horario'],
                  valueCC['latitud'],
                  valueCC['longitud'],
                  valueCC['direccion'],
                  valueCC['logo'],
                  valueCC['banner'],
                  valueCC['tipo'],
                  double.parse(valueCC['rating'].toString()),
                  Colors.orange,
                  Icon(FontAwesomeIcons.utensils),
                  _food));
              break;
            case 6:
              _tematico.add(FoodCenter(
                  valueCC['nombre'],
                  valueCC['numero'],
                  valueCC['descripcion'],
                  valueCC['horario'],
                  valueCC['latitud'],
                  valueCC['longitud'],
                  valueCC['direccion'],
                  valueCC['logo'],
                  valueCC['banner'],
                  valueCC['tipo'],
                  double.parse(valueCC['rating'].toString()),
                  Colors.purpleAccent,
                  Icon(FontAwesomeIcons.cookieBite),
                  _food));
              break;
          }

          categories.add(Category(
              "BAR", Icon(FontAwesomeIcons.glassMartiniAlt), Colors.blueAccent, 'bar.jpg', _bares));
          categories
              .add(Category("CAFE", Icon(FontAwesomeIcons.mugHot), Colors.red, 'cafe.jpg', _cafe));
          categories.add(Category("COMIDA RAPIDA", Icon(FontAwesomeIcons.hamburger), Colors.brown,
              'comidaRapida.jpg', _rapida));
          categories.add(Category(
              "POSTRE", Icon(FontAwesomeIcons.iceCream), Colors.cyanAccent, 'postre.jpg', _postre));
          categories.add(Category("RESTAURANTE", Icon(FontAwesomeIcons.utensils), Colors.orange,
              'restaurante.jpg', _restaurante));
          setState(() {
            categories.add(Category("RESTAURANTE TEMATICO", Icon(FontAwesomeIcons.cookieBite),
                Colors.purpleAccent, 'restauranteTematico.jpg', _tematico));
          });
          
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getBD();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 80),
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
              ],
            ),
          ),
          (categories == null || categories.length == 0)
              ? Center(
                  child: Text(
                    'Cargando tus lugares favoritos ...',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : _Expanded()
        ],
      ),
    );
  }

  Widget _Expanded() {
    return Container(
      padding: EdgeInsets.only(top: 130, bottom: 60),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 20),
        itemCount: categories.length,
        itemBuilder: (BuildContext ctx, int index) {
          return CardListCategories(
            category: categories[index],
            onCardClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectedCategoryPage(
                    selectedCategory: this.categories[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
