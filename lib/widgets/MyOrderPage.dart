import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/database/FirebaseDB.dart';
import 'package:sistema_registro_pedidos/provider/MiPedido.dart';

class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  Timer _timer;

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Colors.black54,
                  title: Text(
                    '¡Cuidado!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'Podras salir de esta pantalla cuando pagues el pedido',
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
                      child: Text('Okay!'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ))) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      FirebaseDB.actualizarEstado(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var miPedidoProvider = Provider.of<MiPedido>(context, listen: true);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  'Tu pedido fue enviado :D',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              leading: Container(),
              centerTitle: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Image.network(miPedidoProvider.foodCenter.banner).image,
                                fit: BoxFit.cover)),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.9), Colors.transparent]),
                          ),
                        ),
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
                                        image: NetworkImage(miPedidoProvider.foodCenter.logo),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(text: 'Usuario: \n'),
                                      TextSpan(
                                          text: '${miPedidoProvider.nombreUsuario}',
                                          style: TextStyle(color: Colors.yellow)),
                                    ]),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(text: 'Mesa: '),
                                      TextSpan(
                                          text: '${miPedidoProvider.valorQR}',
                                          style: TextStyle(color: Colors.yellow)),
                                    ]),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(text: 'Codigo: '),
                                      TextSpan(
                                          text: '${miPedidoProvider.codigo}',
                                          style: TextStyle(color: Colors.yellow)),
                                    ]),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(text: 'Fecha: '),
                                      TextSpan(
                                          text: '${miPedidoProvider.fecha}',
                                          style: TextStyle(color: Colors.yellow)),
                                    ]),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(text: 'Hora: '),
                                      TextSpan(
                                          text: '${miPedidoProvider.hora}',
                                          style: TextStyle(color: Colors.yellow)),
                                    ]),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(text: 'Total: '),
                                      TextSpan(
                                          text: '${miPedidoProvider.total}',
                                          style: TextStyle(color: Colors.yellow)),
                                    ]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: ListaPedido(miPedidoProvider: miPedidoProvider),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            exit(0);
          },
          splashColor: Colors.greenAccent,
          child: Center(
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ListaPedido extends StatelessWidget {
  const ListaPedido({
    Key key,
    @required this.miPedidoProvider,
  }) : super(key: key);

  final MiPedido miPedidoProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/mipedido.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          GridView.builder(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            itemCount: miPedidoProvider.miPedido.length == 0 ? 1 : miPedidoProvider.miPedido.length,
            itemBuilder: (context, index) {
              return Container(
                child: miPedidoProvider.miPedido.length == 0
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
                        onLongPress: () {},
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
                                      image: NetworkImage(miPedidoProvider.miPedido[index].img),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.cyanAccent.withOpacity(0.8),
                                          offset: Offset.zero,
                                          blurRadius: 50)
                                    ],
                                  ),
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
                                            miPedidoProvider.miPedido[index].precio.toString(),
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
                                miPedidoProvider.miPedido[index].nombre,
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            ),
                            Container(
                              child: Text(
                                miPedidoProvider.miPedido[index].descripcion,
                                style: TextStyle(color: Colors.yellow, fontSize: 25),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Cantidad: " + miPedidoProvider.miPedido[index].cantidad.toString(),
                                style: TextStyle(color: Colors.blue.shade300, fontSize: 25),
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
  }
}
