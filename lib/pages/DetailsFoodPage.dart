import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/models/Table.dart';
import 'package:sistema_registro_pedidos/pages/MapPage.dart';
import 'package:sistema_registro_pedidos/pages/ScannerQRPage.dart';
import 'package:sistema_registro_pedidos/widgets/ThemeButton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsFoodPage extends StatefulWidget {
  FoodCenter foodCenter;

  DetailsFoodPage({this.foodCenter});

  @override
  _DetailsFoodPageState createState() => _DetailsFoodPageState();
}

class _DetailsFoodPageState extends State<DetailsFoodPage> {
  final Location location = Location();
  PermissionStatus _permissionGranted;
  List<Board> _mesas = [];
  int _nroMesasDisponibles = 0;

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult = await location.requestPermission();
    }
  }

  Future _getMesas() async {
    _mesas.clear();
    _nroMesasDisponibles = 0;
    final uri =
        Uri.parse("https://sistemaregistropedidos-default-rtdb.firebaseio.com/CentroComida.json");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      String body =
          utf8.decode(response.bodyBytes); // para mostrar caracteres especiales sin simbolos raros
      Map jsonData = json.decode(body);

      for (int i = 1; i <= jsonData.length; i++) {
        if (jsonData['CC$i']['longitud'] == this.widget.foodCenter.longitud &&
            jsonData['CC$i']['latitud'] == this.widget.foodCenter.latitud) {
          for (int j = 1; j <= jsonData['CC$i']['Mesas'].length; j++) {
            _mesas.add(Board(
              jsonData['CC$i']['Mesas']['M$j']['nro'],
              jsonData['CC$i']['Mesas']['M$j']['disponible'],
            ));
            if (jsonData['CC$i']['Mesas']['M$j']['disponible'] == 1) {
              setState(() {
                _nroMesasDisponibles++;
              });
            }
          }
        }
      }
      if (_nroMesasDisponibles == 0) {
        setState(() {
          _nroMesasDisponibles = 0;
        });
      }
    } else {
      print('ERRRRRRRROOOOOOOORRRRRRRRRRRRRR');
    }
  }

  @override
  void initState() {
    super.initState();
    _permissionGranted == PermissionStatus.granted ? null : _requestPermission();
    _getMesas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
              child: Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.network(this.widget.foodCenter.banner).image,
                            fit: BoxFit.cover)),
                  ),
                  Positioned.fill(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.8), Colors.transparent]))),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(this.widget.foodCenter.logo),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(this.widget.foodCenter.nombre,
                                    style: TextStyle(color: Colors.white, fontSize: 30)),
                                SizedBox(height: 10),
                                Text(this.widget.foodCenter.descripcion,
                                    style: TextStyle(color: Colors.orange, fontSize: 20)),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                            child: Text(
                          '¡Disfrute de nuestro exquisito menú!',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                        )),
                      ),
                      Container(
                        height: 320,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: this.widget.foodCenter.menu.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(15),
                                        width: 250,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  this.widget.foodCenter.menu[index].img),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  offset: Offset.zero,
                                                  blurRadius: 10)
                                            ]),
                                      ),
                                      Positioned(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/images/price.png'),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  this
                                                      .widget
                                                      .foodCenter
                                                      .menu[index]
                                                      .precio
                                                      .toString(),
                                                  style: TextStyle(fontSize: 25),
                                                ),
                                                Text('Bs.')
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            ),
                                          ),
                                        ),
                                        right: 10,
                                        bottom: 10,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Text(
                                      this.widget.foodCenter.menu[index].nombre,
                                      style: TextStyle(color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      this.widget.foodCenter.menu[index].descripcion,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      ThemeButton(
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPage(
                                foodCenter: this.widget.foodCenter,
                              ),
                            ),
                          );
                        },
                        label: "Ver ubicacion en el mapa",
                        icon: Icon(FontAwesomeIcons.mapMarkedAlt),
                        color: Colors.green,
                        highlight: Colors.green.shade900,
                      ),
                      (_nroMesasDisponibles == 0) ? _NoMesasDisponibles() : _bottomScannerQR()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _NoMesasDisponibles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ThemeButton(
          onClick: () {},
          label: "No hay mesas disponibles",
          icon: Icon(
            FontAwesomeIcons.sadCry,
            color: Colors.white,
          ),
          color: Colors.grey.shade700,
          highlight: Colors.black,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _getMesas();
              },
              child: ClipOval(
                child: Container(
                  child: Icon(
                    FontAwesomeIcons.redoAlt,
                    size: 30,
                    color: Colors.white,
                  ),
                  height: 50,
                  width: 50,
                  color: Colors.yellow.shade700,
                  padding: EdgeInsets.all(5),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ],
    );
  }

  Widget _bottomScannerQR() {
    return ThemeButton(
      onClick: () {
        if (_nroMesasDisponibles > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScannerQRPage(
                        foodCenter: this.widget.foodCenter,
                        mesas: _mesas,
                      )));
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("ALERTA"),
              content: Text('No hay mesas disponibles'),
            ),
          );
        }
      },
      label: "Escanear codigo QR",
      icon: Icon(FontAwesomeIcons.qrcode),
      color: Colors.red.shade500,
      highlight: Colors.red.shade900,
    );
  }
}
