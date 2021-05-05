import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/models/User.dart';

class FoodOrder{
  String fecha;
  String hora;
  int codigo;
  double Total;
  List<Food> comidas;
  User cliente;
  FoodCenter centroComida;
}