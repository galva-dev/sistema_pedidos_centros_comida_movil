import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';

class Utils {
  static List<Category> getMockedCategories() {
    return [
      Category("BAR", Icon(FontAwesomeIcons.glassMartiniAlt), Colors.blueAccent,
          'bar.jpg', [
        FoodCenter(
            'Bar pepe',
            '154102859',
            'Los mejores Bares',
            '10 am - 20 pm',
            -16.508288147386104,
            -68.11272586156856,
            "Av. Los alamos #21",
            'bar.jpg',
            1,
            4.5,
            Colors.blueAccent,
            Icon(FontAwesomeIcons.glassMartiniAlt), [], []),
        FoodCenter(
            'Bar alberto',
            '154102859',
            'Los mejores Bares',
            '10 am - 20 pm',
            -16.50722862681776,
            -68.11663115792324,
            "Av. Los alamos #21",
            'bar.jpg',
            1,
            2.5,
            Colors.blueAccent,
            Icon(FontAwesomeIcons.glassMartiniAlt), [], []),
        FoodCenter(
            'Bar juan',
            '154102859',
            'Los mejores Bares',
            '10 am - 20 pm',
            -16.502825896902138,
            -68.11673844628552,
            "Av. Los alamos #21",
            'bar.jpg',
            1,
            1.5,
            Colors.blueAccent,
            Icon(FontAwesomeIcons.glassMartiniAlt), [], []),
        FoodCenter(
            'Bar cristiano',
            '154102859',
            'Los mejores Bares',
            '10 am - 20 pm',
            -16.51116535917371,
            -68.11079145001565,
            "Av. Los alamos #21",
            'bar.jpg',
            1,
            3.5,
            Colors.blueAccent,
            Icon(FontAwesomeIcons.glassMartiniAlt), [], []),
        FoodCenter(
            'Bar messi',
            '154102859',
            'Los mejores Bares',
            '10 am - 20 pm',
            -16.50802069615617,
            -68.11532223993575,
            "Av. Los alamos #21",
            'bar.jpg',
            1,
            5.0,
            Colors.blueAccent,
            Icon(FontAwesomeIcons.glassMartiniAlt), [], []),
      ]),
      Category(
          "CAFE", Icon(FontAwesomeIcons.mugHot), Colors.red, 'cafe.jpg', []),
      Category("COMIDA RAPIDA", Icon(FontAwesomeIcons.hamburger), Colors.brown,
          'comidaRapida.jpg', []),
      Category("POSTRE", Icon(FontAwesomeIcons.iceCream), Colors.cyanAccent,
          'postre.jpg', []),
      Category("RESTAURANTE", Icon(FontAwesomeIcons.utensils), Colors.orange,
          'restaurante.jpg', []),
      Category("RESTAURANTE TEMATICO", Icon(FontAwesomeIcons.cookieBite),
          Colors.purpleAccent, 'restauranteTematico.jpg', []),
    ];
  }
}
