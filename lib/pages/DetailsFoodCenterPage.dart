import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';

class DetailsFoodCenterPage extends StatelessWidget {

  FoodCenter subCategory;
  DetailsFoodCenterPage({this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: 50,
              child: Image.asset('assets/images/logo.png'),
            ),
            Spacer(),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 0),
            padding: EdgeInsets.all(5),
            child: ClipOval(
              child: Container(
                color: Colors.black,
                width: 45,
                height: 40,
                child: Image(
                  image:
                  Image
                      .asset('assets/images/category/postre.jpg')
                      .image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Text(this.subCategory.nombre),
      ),
    );
  }
}
