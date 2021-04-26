import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';

class Utils{
  static List<Category> getMockedCategories(){
    return[
      Category(
          "BAR",
          Icon(FontAwesomeIcons.glassMartiniAlt),
          Colors.blueAccent,
          'bar.jpg',
          []
      ),
      Category(
          "CAFE",
          Icon(FontAwesomeIcons.mugHot),
          Colors.red,
          'cafe.jpg',
          []
      ),
      Category(
          "COMIDA RAPIDA",
          Icon(FontAwesomeIcons.hamburger),
          Colors.brown,
          'comidaRapida.jpg',
          []
      ),
      Category(
          "POSTRE",
          Icon(FontAwesomeIcons.iceCream),
          Colors.cyanAccent,
          'postre.jpg',
          []
      ),
      Category(
          "RESTAURANTE",
          Icon(FontAwesomeIcons.utensils),
          Colors.orange,
          'restaurante.jpg',
          []
      ),
      Category(
          "RESTAURANTE TEMATICO",
          Icon(FontAwesomeIcons.cookieBite),
          Colors.purpleAccent,
          'restauranteTematico.jpg',
          []
      ),
    ];
  }
}