import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';

class Category{
  String name;
  Icon icon;
  Color color;
  String imgName;
  List<FoodCenter> subCategories;

  Category(this.name, this.icon, this.color, this.imgName, this.subCategories);
}