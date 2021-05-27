import 'package:flutter/cupertino.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';

class MiPedido with ChangeNotifier {
  List<Food> miPedido = [];
  FoodCenter foodCenter;
  String emailUsuario;
  String nombreUsuario;
  String ciRecepcionista = "";
  String codigo = "";
  String estado = "";
  String fecha = "";
  String hora = "";
  String valorQR = "";
  double tiempo = 0;
  double total = 0;

  String get getValorQR => this.valorQR;

  set setValorQR(String valorQR){
    this.valorQR = valorQR;
  }

  String get getEmailUsuario => this.emailUsuario;

  set setEmailUsuario(String emailUsuario) => this.emailUsuario = emailUsuario;

  get getNombreUsuario => this.nombreUsuario;

  set setNombreUsuario(nombreUsuario) => this.nombreUsuario = nombreUsuario;

  List<Food> get getMiPedido => this.miPedido;

  set setMiPedido(List<Food> miPedido) => this.miPedido = miPedido;

  get getCiRecepcionista => this.ciRecepcionista;

  set setCiRecepcionista(ciRecepcionista) => this.ciRecepcionista = ciRecepcionista;

  get getCodigo => this.codigo;

  set setCodigo(codigo) => this.codigo = codigo;

  get getEstado => this.estado;

  set setEstado(estado) => this.estado = estado;

  get getFecha => this.fecha;

  set setFecha(fecha) => this.fecha = fecha;

  get getHora => this.hora;

  set setHora(hora) => this.hora = hora;

  get getTiempo => this.tiempo;

  set setTiempo(tiempo) => this.tiempo = tiempo;

  get getTotal => this.total;

  set setTotal(total) => this.total = total;
}
