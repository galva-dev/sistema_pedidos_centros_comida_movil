import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';

class OrderMenuListPage extends StatefulWidget {
  FoodCenter food;
  String valorQR;

  OrderMenuListPage({this.food, this.valorQR});

  @override
  _OrderMenuListPageState createState() => _OrderMenuListPageState();
}

class _OrderMenuListPageState extends State<OrderMenuListPage> {
  List<Food> miPedido = [];
  List<Food> bebidas = [];

  Future _getBebidas() async {
    bebidas.clear();
    final uri = Uri.parse(
        "https://sistemaregistropedidos-default-rtdb.firebaseio.com/CentroComida.json");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      String body = utf8.decode(response
          .bodyBytes); // para mostrar caracteres especiales sin simbolos raros
      Map jsonData = json.decode(body);

      for (int i = 1; i <= jsonData.length; i++) {
        if (jsonData['CC$i']['longitud'] == this.widget.food.longitud &&
            jsonData['CC$i']['latitud'] == this.widget.food.latitud) {
          for (int j = 1; j <= jsonData['CC$i']['Bebidas'].length; j++) {
            setState(() {
              bebidas.add(Food(
                  jsonData['CC$i']['Bebidas']['B$j']['nombre'],
                  double.parse(jsonData['CC$i']['Bebidas']['B$j']['precio'].toString()),
                  jsonData['CC$i']['Bebidas']['B$j']['descripcion'],
                  jsonData['CC$i']['Bebidas']['B$j']['img']));
            });
          }
        }
      }
    } else {
      print('ERRRRRRRROOOOOOOORRRRRRRRRRRRRR');
    }
  }

  @override
  void initState() {
    super.initState();
    _getBebidas();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  title: Text('Estamos esperando tu pedido :D'),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                          icon: Icon(
                            Icons.restaurant_menu,
                            color: Colors.orange,
                          ),
                          text: 'Menu'),
                      Tab(
                          icon: Icon(
                            FontAwesomeIcons.wineBottle,
                            color: Colors.deepPurpleAccent,
                          ),
                          text: 'Bebidas'),
                      Tab(
                          icon: Icon(
                            FontAwesomeIcons.listAlt,
                            color: Colors.cyanAccent.shade700,
                          ),
                          text: 'Mi Pedido'),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                buildMenu(),
                buildBebidas(),
                buildMiPedido(),
              ],
            ),
          ),
        ),
      );

  Widget buildMenu() => Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: this.widget.food.menu.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  child: this.widget.food.menu.length == 0
                      ? Center(
                          child: Text(
                          'No hay menu disponible',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                      : GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    width: 300,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              this.widget.food.menu[index].img),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.orange.withOpacity(0.8),
                                              offset: Offset.zero,
                                              blurRadius: 50)
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
                                                  .food
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
                                  this.widget.food.menu[index].nombre,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                              Container(
                                child: Text(
                                  this.widget.food.menu[index].descripcion,
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      );

  Widget buildBebidas() => Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: bebidas.length == 0 ? 1 : bebidas.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  child: bebidas.length == 0
                      ? Center(
                          child: Text(
                          'No hay bebidas disponibles',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                      : GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    width: 250,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(bebidas[index].img),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.purpleAccent.withOpacity(0.9),
                                              offset: Offset.zero,
                                              blurRadius: 50)
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
                                              bebidas[index].precio.toString(),
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
                                  bebidas[index].nombre,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                              Container(
                                child: Text(
                                  bebidas[index].descripcion,
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      );

  Widget buildMiPedido() => Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: miPedido.length == 0 ? 1 : miPedido.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  child: miPedido.length == 0
                      ? Center(
                          child: Text(
                          'Tu pedido esta vacio',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                      : GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    width: 250,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(miPedido[index].img),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.cyanAccent.withOpacity(0.8),
                                              offset: Offset.zero,
                                              blurRadius: 50)
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
                                              miPedido[index].precio.toString(),
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
                                  miPedido[index].nombre,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                              Container(
                                child: Text(
                                  miPedido[index].descripcion,
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Cantidad: "+miPedido[index].cantidad.toString(),
                                  style: TextStyle(color: Colors.redAccent.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
            Positioned(
              right: 10,
              bottom: 50,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.green,
                child: Icon(FontAwesomeIcons.check),
              ),
            )
          ],
        ),
      );
}
