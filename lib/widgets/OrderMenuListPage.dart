import 'dart:convert';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/models/FoodOrder.dart';
import 'package:sistema_registro_pedidos/pages/MyOrderPage.dart';
import 'package:sistema_registro_pedidos/provider/SelectedPageProvider.dart';

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
  final user = FirebaseAuth.instance.currentUser;

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
                  double.parse(
                      jsonData['CC$i']['Bebidas']['B$j']['precio'].toString()),
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

  Future<void> _showMyDialog(int index, int tipo) async {
    int cantidad = 1;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            'Mi pedido',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Seleccione la cantidad deseada. <- Desliza ->',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.transparent,
                  height: 100,
                  width: double.infinity,
                  child: CircleListScrollView(
                    itemExtent: 100,
                    axis: Axis.horizontal,
                    physics: CircleFixedExtentScrollPhysics(),
                    children: List.generate(
                      10,
                      (index) {
                        return Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 90,
                              height: 90,
                              color: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 75,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        cantidad = index + 1;
                      });
                    },
                    radius: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidThumbsDown,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "¡Cancelado!",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                if (tipo == 0) {
                  setState(() {
                    miPedido.add(Food(
                        this.widget.food.menu[index].nombre,
                        this.widget.food.menu[index].precio,
                        this.widget.food.menu[index].descripcion,
                        this.widget.food.menu[index].img,
                        cantidad: cantidad));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidThumbsUp,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "¡Añadido correctamente!",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    miPedido.add(Food(
                        bebidas[index].nombre,
                        bebidas[index].precio,
                        bebidas[index].descripcion,
                        bebidas[index].img,
                        cantidad: cantidad));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidThumbsUp,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "¡Añadido correctamente!",
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _actualizarCantMiPedido(int index) async {
    int cantidad = 1;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            'Actualizar mi pedido',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Seleccione la nueva cantidad deseada.',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.transparent,
                  height: 100,
                  width: double.infinity,
                  child: CircleListScrollView(
                    itemExtent: 100,
                    axis: Axis.horizontal,
                    physics: CircleFixedExtentScrollPhysics(),
                    children: List.generate(
                      10,
                      (index) {
                        return Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 90,
                              height: 90,
                              color: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 75,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        cantidad = index + 1;
                      });
                    },
                    radius: MediaQuery.of(context).size.width * 0.6,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidThumbsDown,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "¡Cancelado!",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                setState(() {
                  miPedido[index].cantidad = cantidad;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidThumbsUp,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "¡Actualizado correctamente!",
                          style: TextStyle(color: Colors.green),
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

  Future<void> _eliminarMiPedido(int index) async {
    int cantidad = 1;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            'Eliminar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '¿Estas seguro que desea eliminar este elemento de tu pedido?',
                  style: TextStyle(color: Colors.redAccent),
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  FontAwesomeIcons.exclamationTriangle,
                  color: Colors.redAccent,
                  size: 20,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidThumbsDown,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "¡Cancelado!",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                setState(() {
                  miPedido.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidThumbsUp,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "¡Eliminado correctamente!",
                          style: TextStyle(color: Colors.green),
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

  Future<void> _confirmarPedido() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            '¡Mi pedido esta listo! :D',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Su pedido será enviado.¿Está seguro de realizar el pedido?',
                  style: TextStyle(color: Colors.blue),
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
              child: Text('Echaré un ultimo vistazo'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidLaughBeam,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "¡Echa un vistazo más!",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Enviar mi pedido'),
              onPressed: () {
                setState(
                  () {

                    //TODO AQUI VA EL ENVIO DE LOS DATOS A FIREBASE

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyOrderPage(
                    //       miPedido: FoodOrder(
                    //         comidas: ,
                    //         centroComida: ,
                    //         cliente: ,
                    //         codigo: ,
                    //         estado: "pendiente",
                    //         fecha: ,
                    //         hora: ,
                    //         nroMesa: ,
                    //         Total: ,
                    //         valueQR: ,
                    //       ),
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            ),
          ],
        );
      },
    );
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
                          onTap: () {
                            _showMyDialog(index, 0);
                          },
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
                                              color: Colors.orange
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
                          onTap: () {
                            _showMyDialog(index, 1);
                          },
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
                                              color: Colors.purpleAccent
                                                  .withOpacity(0.9),
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
                crossAxisCount: 1,
              ),
              itemCount: miPedido.length == 0 ? 1 : miPedido.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 300,
                  width: double.infinity,
                  child: miPedido.length == 0
                      ? Center(
                          child: Text(
                          'Tu pedido esta vacio',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                      : GestureDetector(
                          onLongPress: () {
                            _eliminarMiPedido(index);
                          },
                          onTap: () {
                            _actualizarCantMiPedido(index);
                          },
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
                                  style: TextStyle(
                                      color: Colors.yellow, fontSize: 25),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Cantidad: " +
                                      miPedido[index].cantidad.toString(),
                                  style: TextStyle(
                                      color: Colors.blue.shade600,
                                      fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
            (miPedido.length != 0)
                ? Positioned(
                    right: 10,
                    bottom: 50,
                    child: FloatingActionButton(
                      onPressed: () {
                        _confirmarPedido();
                      },
                      backgroundColor: Colors.green,
                      child: Icon(FontAwesomeIcons.check),
                    ),
                  )
                : Container()
          ],
        ),
      );
}
