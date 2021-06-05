import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:sistema_registro_pedidos/models/Table.dart';
import 'package:sistema_registro_pedidos/pages/OrderMenuListPage.dart';

class ScannerQRPage extends StatefulWidget {
  FoodCenter foodCenter;
  List<Board> mesas;

  ScannerQRPage({this.foodCenter, this.mesas});

  @override
  _ScannerQRPageState createState() => _ScannerQRPageState();
}

class _ScannerQRPageState extends State<ScannerQRPage> {
  String _valueQR = '';
  bool codigoValido = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionCamera();
  }

  void _checkPermissionCamera() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }

  void _qrScan() async {
    if (await Permission.camera.isGranted) {
      String read = await scanner.scan();
      try {
        if (int.parse(read) <= this.widget.mesas.length) {
          _valueQR += read;
          setState(() {
            codigoValido = true;
          });
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("ALERTA"),
              content: Text('El codigo QR escaneado es incorrecto'),
            ),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("ALERTA"),
            content: Text('El codigo QR escaneado es incorrecto'),
          ),
        );
      }
    } else {
      _showMyDialog();
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Permisos',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Para poder escanear el codigo QR debes permitir el acceso a la camara'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '¿Quieres activar los permisos de la camara?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Si'),
              onPressed: () {
                _checkPermissionCamera();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        child: Center(
            child: codigoValido
                ? OrderMenuListPage(
                    food: this.widget.foodCenter,
                    valorQR: _valueQR,
                  )
                : _bottomScanner()),
      ),
    );
  }

  Widget _bottomScanner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(''),
        SizedBox(
          height: 80,
        ),
        Column(
          children: [
            Text(
              '¡Estamos esperando tu pedido!',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: Offset.zero,
                    blurRadius: 50)
              ]),
              child: InkWell(
                onTap: () {
                  _qrScan();
                },
                child: ClipOval(
                  child: Container(
                    color: Colors.white.withOpacity(0.9),
                    padding: EdgeInsets.all(35),
                    child: Icon(
                      FontAwesomeIcons.qrcode,
                      size: 150,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 70,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: NetworkImage(this.widget.foodCenter.logo),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset.zero,
                        blurRadius: 10)
                  ]),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              this.widget.foodCenter.nombre,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ],
        )
      ],
    );
  }
}
