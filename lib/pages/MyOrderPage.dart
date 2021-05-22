import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/FoodOrder.dart';

class MyOrderPage extends StatefulWidget {
  FoodOrder miPedido;

  MyOrderPage({this.miPedido});

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
            itemCount: this.widget.miPedido.comidas.length == 0
                ? 1
                : this.widget.miPedido.comidas.length,
            itemBuilder: (context, index) {
              return Container(
                height: 300,
                width: double.infinity,
                child: this.widget.miPedido.comidas.length == 0
                    ? Center(
                        child: Text(
                        'No has realizado ningun pedido',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                    : GestureDetector(
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
                                        image: NetworkImage(this
                                            .widget
                                            .miPedido
                                            .comidas[index]
                                            .img),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.cyanAccent
                                                .withOpacity(0.8),
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
                                                .miPedido
                                                .comidas[index]
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
                                this.widget.miPedido.comidas[index].nombre,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                            Container(
                              child: Text(
                                this.widget.miPedido.comidas[index].descripcion,
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 25),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Cantidad: " +
                                    this
                                        .widget
                                        .miPedido
                                        .comidas[index]
                                        .cantidad
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.blue.shade600, fontSize: 25),
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
    ));
  }
}
