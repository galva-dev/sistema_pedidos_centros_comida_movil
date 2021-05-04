import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/pages/MapPage.dart';
import 'package:sistema_registro_pedidos/widgets/ThemeButton.dart';

class DetailsFoodPage extends StatefulWidget {
  FoodCenter foodCenter;

  DetailsFoodPage({this.foodCenter});

  @override
  _DetailsFoodPageState createState() => _DetailsFoodPageState();
}

class _DetailsFoodPageState extends State<DetailsFoodPage> {
  final Location location = Location();
  PermissionStatus _permissionGranted;

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
      await location.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    _permissionGranted == PermissionStatus.granted ? null : _requestPermission();
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
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              child: Stack(
                children: [
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.network(this.widget.foodCenter.banner)
                                .image,
                            fit: BoxFit.cover)),
                  ),
                  Positioned.fill(
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent
                        ]))),
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
                                      image: NetworkImage(
                                          this.widget.foodCenter.logo),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(this.widget.foodCenter.nombre,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 50)),
                                SizedBox(height: 10),
                                Text(this.widget.foodCenter.descripcion,
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 20)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Text(
                      '¡Disfrute de nuestro exquisito menú!',
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 20),
                    )),
                  ),
                  Container(
                    height: 320,
                    child: ListView.builder(
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
                                          image: NetworkImage(this
                                              .widget
                                              .foodCenter
                                              .menu[index]
                                              .img),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
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
                                            image: AssetImage(
                                                'assets/images/price.png'),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              Container(
                                child: Text(
                                  this
                                      .widget
                                      .foodCenter
                                      .menu[index]
                                      .descripcion,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
                    },
                    label: "Ver ubicacion en el mapa",
                    icon: Icon(FontAwesomeIcons.mapMarkedAlt),
                    color: Colors.green,
                    highlight: Colors.green.shade900,
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
