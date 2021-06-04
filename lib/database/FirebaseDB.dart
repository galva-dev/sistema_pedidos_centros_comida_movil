import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/provider/MiPedido.dart';
import 'package:sistema_registro_pedidos/widgets/MyOrderPage.dart';

class FirebaseDB {
  static final db = FirebaseDatabase.instance.reference().child('CentroComida');

  static Future actualizarEstado(BuildContext context) async {
    final miPedidoProvider = Provider.of<MiPedido>(context, listen: false);

    await db
        .child(miPedidoProvider.centroComidaKey)
        .child('Pedidos')
        .child(miPedidoProvider.pedidoKey)
        .once()
        .then((value) {
      Map datos = value.value;
      if (datos['estado'] != miPedidoProvider.estado) {
        miPedidoProvider.estado = datos['estado'];
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black54,
              title: Text(
                '¡Actualizacion de tu pedido! :D',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Su pedido se encuentra ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                            text: '${miPedidoProvider.estado}',
                            style: miPedidoProvider.estado == 'Recibido'
                                ? TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)
                                : TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.solidSmileWink,
                      color: Colors.blue,
                      size: 20,
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('¡GRACIAS!'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidLaughBeam,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            miPedidoProvider.estado == 'Recibido' ? Text(
                              "¡Tu pedido esta cerca!",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ) : Text(
                              "¡Muchas gracias por confiar en nostros!",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      if (datos['tiempo'] != miPedidoProvider.tiempo) {
        miPedidoProvider.tiempo = datos['tiempo'];
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black54,
              title: Text(
                '¡Actualizacion de tu pedido! :D',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Su pedido estará listo en  ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                            text: '${miPedidoProvider.tiempo} min',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      FontAwesomeIcons.solidSmileWink,
                      color: Colors.blue,
                      size: 20,
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('¡GRACIAS!'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidLaughBeam,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            miPedidoProvider.estado == 'Recibido' ? Text(
                              "¡Tu pedido esta cerca!",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ) : Text(
                              "¡Muchas gracias por confiar en nostros!",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  static Future enviarPedido(BuildContext context) async {
    final miPedidoProvider = Provider.of<MiPedido>(context, listen: false);

    var jsonPedido = {};
    DatabaseReference idPedido;
    String centroComidaKey = "";

    for (var i = 0; i < miPedidoProvider.miPedido.length; i++) {
      jsonPedido.addAll({
        "C$i": {
          "cantidad": miPedidoProvider.miPedido[i].cantidad,
          "descripcion": miPedidoProvider.miPedido[i].descripcion.toString(),
          "img": miPedidoProvider.miPedido[i].img.toString(),
          "nombre": miPedidoProvider.miPedido[i].nombre.toString(),
          "precio": double.parse(miPedidoProvider.miPedido[i].precio.toString())
        }
      });
    }

    db.once().then((value) {
      Map datos = value.value;
      datos.forEach((key, value) async {
        if (value['latitud'] == miPedidoProvider.foodCenter.latitud &&
            value['longitud'] == miPedidoProvider.foodCenter.longitud) {
          idPedido = await db.child(key.toString()).child('Pedidos').push();
          centroComidaKey = key;
          await db.child(key.toString()).child('Pedidos').child(idPedido.key).set({
            'ciRecepcionista': miPedidoProvider.ciRecepcionista,
            'codigo': miPedidoProvider.codigo,
            'emailCliente': miPedidoProvider.emailUsuario,
            'estado': miPedidoProvider.estado,
            'fecha': miPedidoProvider.fecha,
            'hora': miPedidoProvider.hora,
            'nombreCliente': miPedidoProvider.nombreUsuario,
            'nroMesa': miPedidoProvider.valorQR.toString(),
            'tiempo': miPedidoProvider.tiempo,
            'total': miPedidoProvider.total,
            'Comidas': jsonPedido,
          }).then((value) async {
            await db
                .child(key.toString())
                .child('Mesas')
                .child('M${miPedidoProvider.valorQR}')
                .update({'disponible': 0});
          }).then((value) {
            miPedidoProvider.centroComidaKey = centroComidaKey;
            miPedidoProvider.pedidoKey = idPedido.key;
          });
        }
      });
    }).then((value) {
      print('El pedidos fue enviado');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyOrderPage(),
        ),
      );
    });
  }
}
