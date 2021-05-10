import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';

class FoodCenter{
  String nombre;
  String numero;
  String descripcion;
  String horario;
  double latitud;
  double longitud;
  String direccion;
  String logo;
  String banner;
  int tipo;
  double rating;
  Color color;
  Icon icon;
  List<Food> menu;

  FoodCenter.fromJson(Map<dynamic,dynamic> json){
    this.nombre = json['nombre'];
    this.numero = json['numero'];
    this.descripcion = json['descripcion'];
    this.horario = json['horario'];
    this.latitud = json['latitud'];
    this.longitud = json['longitud'];
    this.direccion = json['direccion'];
    this.logo = json['logo'];
    this.banner = json['banner'];
    this.tipo = json['tipo'];
    this.rating = json['rating'];
    setIconColor();
  }

  void setIconColor(){
    switch (this.tipo) {
      case 1:
        this.icon = Icon(FontAwesomeIcons.glassMartiniAlt);
        this.color = Colors.blueAccent;
        break;
      case 2:
        this.icon = Icon(FontAwesomeIcons.mugHot);
        this.color = Colors.red;
        break;
      case 3:
        this.icon = Icon(FontAwesomeIcons.hamburger);
        this.color = Colors.brown;
        break;
      case 4:
        this.icon = Icon(FontAwesomeIcons.iceCream);
        this.color = Colors.cyanAccent;
        break;
      case 5:
        this.icon = Icon(FontAwesomeIcons.utensils);
        this.color = Colors.orange;
        break;
      case 6:
        this.icon = Icon(FontAwesomeIcons.cookieBite);
        this.color = Colors.purpleAccent;
        break;
      default:
        this.icon = Icon(FontAwesomeIcons.windowClose);
        this.color = Colors.grey;
        break;
    }
  }

  FoodCenter(
      this.nombre,
      this.numero,
      this.descripcion,
      this.horario,
      this.latitud,
      this.longitud,
      this.direccion,
      this.logo,
      this.banner,
      this.tipo,
      this.rating,
      this.color,
      this.icon,
      this.menu);
}