import 'package:flutter/cupertino.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/Table.dart';

class FoodCenter{
  String nombre;
  String numero;
  String descripcion;
  String horario;
  double latitud;
  double longitud;
  String direccion;
  String imgName;
  int tipo;
  double rating;
  Color color;
  Icon icon;
  List<Food> Menu;
  List<Board> Mesas;

  FoodCenter(
      this.nombre,
      this.numero,
      this.descripcion,
      this.horario,
      this.latitud,
      this.longitud,
      this.direccion,
      this.imgName,
      this.tipo,
      this.rating,
      this.color,
      this.icon,
      this.Menu,
      this.Mesas);
}