import 'dart:convert';
import 'dart:math';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/provider/MiPedido.dart';
import 'package:sistema_registro_pedidos/widgets/MyOrderPage.dart';
import 'package:intl/intl.dart';

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
  double totalMiPedido = 0;

  Future _getBebidas() async {
    bebidas.clear();
    final uri =
        Uri.parse("https://sistemaregistropedidos-default-rtdb.firebaseio.com/CentroComida.json");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      String body =
          utf8.decode(response.bodyBytes); // para mostrar caracteres especiales sin simbolos raros
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
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
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
              onPressed: () async {
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
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    miPedido.add(Food(bebidas[index].nombre, bebidas[index].precio,
                        bebidas[index].descripcion, bebidas[index].img,
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
                await _getPrecioTotal().then((value) => Navigator.of(context).pop());
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
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
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
              onPressed: () async {
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
                await _getPrecioTotal().then((value) => Navigator.of(context).pop());
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
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
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
              onPressed: () async {
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
                await _getPrecioTotal().then((value) => Navigator.of(context).pop());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarPedido(BuildContext context) async {
    final miPedidoProvider = Provider.of<MiPedido>(context, listen: false);
    Random rnd = new Random(100);
    var now = new DateTime.now();
    var formatter = DateFormat('yMd');
    String fecha = formatter.format(now);
    formatter = DateFormat.jm();
    String hora = formatter.format(now);

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
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
                miPedidoProvider.foodCenter = this.widget.food;
                miPedidoProvider.ciRecepcionista = "";
                miPedidoProvider.emailUsuario = user.email;
                miPedidoProvider.nombreUsuario = user.displayName;
                miPedidoProvider.codigo = rnd.nextInt(9999).toString();
                miPedidoProvider.estado = "Pendiente";
                miPedidoProvider.fecha = fecha;
                miPedidoProvider.hora = hora;
                miPedidoProvider.miPedido = miPedido;
                miPedidoProvider.tiempo = -1;
                miPedidoProvider.total = totalMiPedido;
                miPedidoProvider.valorQR = this.widget.valorQR;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOrderPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getPrecioTotal() async {
    double nuevoPrecio = 0;
    miPedido.forEach((element) {
      nuevoPrecio += (element.cantidad * element.precio);
    });
    setState(() {
      totalMiPedido = double.parse(nuevoPrecio.toStringAsFixed(2));
    });
    print('precioTotal: $nuevoPrecio bs.');
  }

  @override
  void initState() {
    super.initState();
    _getBebidas();
    print(this.widget.valorQR);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  stretch: true,
                  pinned: true,
                  floating: true,
                  forceElevated: value,
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(text: "TOTAL: ",style: TextStyle(color: Colors.white)),
                        TextSpan(text: "${totalMiPedido.toStringAsFixed(2)}", style: TextStyle(color: Colors.yellow)),
                        TextSpan(text: " Bs.",style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  centerTitle: true,
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
                buildMiPedido(context),
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
              physics: BouncingScrollPhysics(),
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
                                          image: NetworkImage(this.widget.food.menu[index].img),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.orange.withOpacity(0.8),
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
                                            image: AssetImage('assets/images/price.png'),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              this.widget.food.menu[index].precio.toString(),
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
                                  this.widget.food.menu[index].nombre,
                                  style: TextStyle(color: Colors.white, fontSize: 30),
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
              physics: BouncingScrollPhysics(),
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
                                          image: NetworkImage(bebidas[index].img),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.purpleAccent.withOpacity(0.9),
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
                                            image: AssetImage('assets/images/price.png'),
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
                                  bebidas[index].nombre,
                                  style: TextStyle(color: Colors.white, fontSize: 30),
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

  Widget buildMiPedido(BuildContext context) => Container(
        height: double.infinity,
        width: double.infinity,
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
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: miPedido.length == 0 ? 1 : miPedido.length,
              itemBuilder: (context, index) {
                return Container(
                  child: miPedido.length == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Image.asset(
                                'assets/images/logo.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Tu pedido esta vacio',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        )
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
                                          image: NetworkImage(miPedido[index].img),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.cyanAccent.withOpacity(0.8),
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
                                            image: AssetImage('assets/images/price.png'),
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
                                  miPedido[index].nombre,
                                  style: TextStyle(color: Colors.white, fontSize: 30),
                                ),
                              ),
                              Container(
                                child: Text(
                                  miPedido[index].descripcion,
                                  style: TextStyle(color: Colors.yellow, fontSize: 25),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Cantidad: " + miPedido[index].cantidad.toString(),
                                  style: TextStyle(color: Colors.blue.shade300, fontSize: 25),
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
                        _confirmarPedido(context);
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
