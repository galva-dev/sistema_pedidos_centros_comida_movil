import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/helpers/Utils.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/provider/GoogleProvider.dart';
import 'package:sistema_registro_pedidos/widgets/CardListCategoriesWidget.dart';
import 'package:http/http.dart' as http;

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key key}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  // List<Category> categories = Utils.getMockedCategories();
  List<Category> categories = [];

  Future _getBD() async {
    final uri = Uri.parse(
        "https://sistemaregistropedidos-default-rtdb.firebaseio.com/CentroComida.json");
    final response = await http.get(uri);
    List<FoodCenter> _bares = [];
    List<FoodCenter> _cafe = [];
    List<FoodCenter> _rapida = [];
    List<FoodCenter> _postre = [];
    List<FoodCenter> _restaurante = [];
    List<FoodCenter> _tematico = [];
    List<Food> _food = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response
          .bodyBytes); // para mostrar caracteres especiales sin simbolos raros
      Map jsonData = json.decode(body);

      // print('ITEMS: ${jsonData['CC1']['Menu']['C1'].length.toString()}');
      // print(jsonData['CC1']['Menu']['C2']);

      for (int i = 1; i <= jsonData.length; i++) {
        _food.clear();
        for (int j = 1; j <= jsonData['CC$i']['Menu'].length; j++) {
          _food.add(Food(
              jsonData['CC$i']['Menu']['C$j']['nombre'],
              double.parse(jsonData['CC$i']['Menu']['C$j']['precio'].toString()),
              jsonData['CC$i']['Menu']['C$j']['descripcion'],
              jsonData['CC$i']['Menu']['C$j']['img']));
        }
        switch(int.parse(jsonData['CC$i']['tipo'].toString())) {
          case 1:
            _bares.add(FoodCenter(
                jsonData['CC$i']['nombre'],
                jsonData['CC$i']['numero'],
                jsonData['CC$i']['descripcion'],
                jsonData['CC$i']['horario'],
                jsonData['CC$i']['latitud'],
                jsonData['CC$i']['longitud'],
                jsonData['CC$i']['direccion'],
                jsonData['CC$i']['logo'],
                jsonData['CC$i']['banner'],
                jsonData['CC$i']['tipo'],
                double.parse(jsonData['CC$i']['rating'].toString()),
                Colors.blueAccent,
                Icon(FontAwesomeIcons.glassMartiniAlt),
                _food));
            break;
          case 2:
            _cafe.add(FoodCenter(
                jsonData['CC$i']['nombre'],
                jsonData['CC$i']['numero'],
                jsonData['CC$i']['descripcion'],
                jsonData['CC$i']['horario'],
                jsonData['CC$i']['latitud'],
                jsonData['CC$i']['longitud'],
                jsonData['CC$i']['direccion'],
                jsonData['CC$i']['logo'],
                jsonData['CC$i']['banner'],
                jsonData['CC$i']['tipo'],
                double.parse(jsonData['CC$i']['rating'].toString()),
                Colors.red,
                Icon(FontAwesomeIcons.mugHot),
                _food));
            break;
          case 3:
            _rapida.add(FoodCenter(
                jsonData['CC$i']['nombre'],
                jsonData['CC$i']['numero'],
                jsonData['CC$i']['descripcion'],
                jsonData['CC$i']['horario'],
                jsonData['CC$i']['latitud'],
                jsonData['CC$i']['longitud'],
                jsonData['CC$i']['direccion'],
                jsonData['CC$i']['logo'],
                jsonData['CC$i']['banner'],
                jsonData['CC$i']['tipo'],
                double.parse(jsonData['CC$i']['rating'].toString()),
                Colors.brown,
                Icon(FontAwesomeIcons.hamburger),
                _food));
            break;
          case 4:
            _postre.add(FoodCenter(
                jsonData['CC$i']['nombre'],
                jsonData['CC$i']['numero'],
                jsonData['CC$i']['descripcion'],
                jsonData['CC$i']['horario'],
                jsonData['CC$i']['latitud'],
                jsonData['CC$i']['longitud'],
                jsonData['CC$i']['direccion'],
                jsonData['CC$i']['logo'],
                jsonData['CC$i']['banner'],
                jsonData['CC$i']['tipo'],
                double.parse(jsonData['CC$i']['rating'].toString()),
                Colors.cyanAccent,
                Icon(FontAwesomeIcons.iceCream),
                _food));
            break;
          case 5:
            _restaurante.add(FoodCenter(
                jsonData['CC$i']['nombre'],
                jsonData['CC$i']['numero'],
                jsonData['CC$i']['descripcion'],
                jsonData['CC$i']['horario'],
                jsonData['CC$i']['latitud'],
                jsonData['CC$i']['longitud'],
                jsonData['CC$i']['direccion'],
                jsonData['CC$i']['logo'],
                jsonData['CC$i']['banner'],
                jsonData['CC$i']['tipo'],
                double.parse(jsonData['CC$i']['rating'].toString()),
                Colors.orange,
                Icon(FontAwesomeIcons.utensils),
                _food));
            break;
          case 6:
            _tematico.add(FoodCenter(
                jsonData['CC$i']['nombre'],
                jsonData['CC$i']['numero'],
                jsonData['CC$i']['descripcion'],
                jsonData['CC$i']['horario'],
                jsonData['CC$i']['latitud'],
                jsonData['CC$i']['longitud'],
                jsonData['CC$i']['direccion'],
                jsonData['CC$i']['logo'],
                jsonData['CC$i']['banner'],
                jsonData['CC$i']['tipo'],
                double.parse(jsonData['CC$i']['rating'].toString()),
                Colors.purpleAccent,
                Icon(FontAwesomeIcons.cookieBite),
                _food));
            break;
        }
      }

      categories.add(Category("BAR", Icon(FontAwesomeIcons.glassMartiniAlt), Colors.blueAccent,
          'bar.jpg', _bares));
      categories.add(Category(
          "CAFE", Icon(FontAwesomeIcons.mugHot), Colors.red, 'cafe.jpg', _cafe));
      categories.add(Category("COMIDA RAPIDA", Icon(FontAwesomeIcons.hamburger), Colors.brown,
          'comidaRapida.jpg', _rapida));
      categories.add(Category("POSTRE", Icon(FontAwesomeIcons.iceCream), Colors.cyanAccent,
          'postre.jpg', _postre));
      categories.add(Category("RESTAURANTE", Icon(FontAwesomeIcons.utensils), Colors.orange,
          'restaurante.jpg', _restaurante));
      setState(() {
        categories.add(Category("RESTAURANTE TEMATICO", Icon(FontAwesomeIcons.cookieBite),
            Colors.purpleAccent, 'restauranteTematico.jpg', _tematico));
      });

    } else {
      print('ERRRRRRRROOOOOOOORRRRRRRRRRRRRR');
    }
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
              'No hay datos',
              style: TextStyle(color: Colors.white),
            ),
          )
              : _Expanded()
        ],
      ),
    );
  }

  Widget _Expanded() {
    return Expanded(
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
                      builder: (context) =>
                          SelectedCategoryPage(
                            selectedCategory: this.categories[index],
                          )));
            },
          );
        },
      ),
    );
  }
}
