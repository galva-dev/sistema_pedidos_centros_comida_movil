import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/models/User.dart';

class FoodOrder{
  List<Food> comidas;
  FoodCenter centroComida;
  User cliente;
  int codigo;
  String nroMesa;
  double total;
  String fecha;
  String hora;
  String estado;
  String valueQR;

  FoodOrder({
      this.comidas,
      this.centroComida,
      this.cliente,
      this.codigo,
      this.nroMesa,
      this.total,
      this.fecha,
      this.hora,
      this.estado,
      this.valueQR});
}