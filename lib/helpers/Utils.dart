import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
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
            'https://gobiznext.com/wp-content/uploads/2019/10/1-7.jpg',
            'https://cdn-3.expansion.mx/dims4/default/ab991e0/2147483647/strip/true/crop/800x450+0+0/resize/800x450!/quality/90/?url=https%3A%2F%2Fcherry-brightspot.s3.amazonaws.com%2F9d%2F1e%2F1a02bddd42cfa3ba090095301c95%2Ffotoluz.jpg',
            1,
            4.5,
            Colors.blueAccent,
            Icon(FontAwesomeIcons.glassMartiniAlt),
            [
              Food('Pollo 1', 21.50, 'Descripcion del pollo 1', 'https://cdn.pixabay.com/photo/2014/01/24/04/05/fried-chicken-250863_960_720.jpg'),
              Food('Pollo 2', 22.50, 'Descripcion del pollo 2', 'https://cdn.pixabay.com/photo/2016/08/30/18/45/grilled-1631727_960_720.jpg'),
              Food('Pollo 3', 23.50, 'Descripcion del pollo 3', 'https://cdn.pixabay.com/photo/2016/07/31/18/00/chicken-1559579_960_720.jpg'),
              Food('Pollo 4', 24.50, 'Descripcion del pollo 4', 'https://cdn.pixabay.com/photo/2018/10/28/19/44/schnitzel-3779726_960_720.jpg'),
              Food('Pollo 5', 25.50, 'Descripcion del pollo 5', 'https://cdn.pixabay.com/photo/2014/12/30/09/55/chicken-583761_960_720.jpg'),
            ], []),
        FoodCenter(
            'Bar alberto',
            '154102859',
            'Los mejores Bares',
            '10 am - 20 pm',
            -16.50722862681776,
            -68.11663115792324,
            "Av. Los alamos #21",
            'https://static-cse.canva.com/blob/211878/07-50-logotipos-que-te-inspiraran.5f3e4ec9.jpg',
            'https://retailnewstrends.me/wp-content/uploads/2018/08/starbucks-princi-5.jpg',
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
            'https://static-cse.canva.com/blob/211890/14-50-logotipos-que-te-inspiraran.4462c088.jpg',
            'https://buenavibra.es/wp-content/uploads/2018/08/rsz_inclusion_laboral.jpg',
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
            'https://static-cse.canva.com/blob/211896/16-50-logotipos-que-te-inspiraran.9c18fb31.png',
            'https://www.eoi.es/blogs/embatur/files/2015/01/claves-del-exito-starbucks.png',
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
            'https://static-cse.canva.com/blob/211898/17-50-logotipos-que-te-inspiraran.9495ce10.jpg',
            'https://cdn-pro.elsalvador.com/wp-content/uploads/2017/06/26173908/Starbuckt.jpg',
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
