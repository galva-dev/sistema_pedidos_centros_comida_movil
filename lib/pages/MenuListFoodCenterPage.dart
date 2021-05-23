import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';
import 'package:sistema_registro_pedidos/pages/DetailsFoodPage.dart';
import 'package:sistema_registro_pedidos/widgets/AppBarWidget.dart';
import 'package:sistema_registro_pedidos/widgets/CardListSubCategoriesWidget.dart';
import 'package:sistema_registro_pedidos/widgets/CardMenuListPage.dart';

class MenuListFoodCenterPage extends StatefulWidget {
  FoodCenter subCategory;
  MenuListFoodCenterPage({this.subCategory});

  @override
  _MenuListFoodCenterPageState createState() => _MenuListFoodCenterPageState();
}

class _MenuListFoodCenterPageState extends State<MenuListFoodCenterPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
          color: Colors.black,
          child: Stack(
              children: [
                Positioned.fill(
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        'assets/images/background.jpg',
                        fit: BoxFit.cover,
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              child: Icon(
                                this.widget.subCategory.icon.icon, size: 25,
                                color: Colors.white,),
                              color: this.widget.subCategory.color,
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text(
                            this.widget.subCategory.nombre,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 25,),
                      Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 20),
                            itemCount: this.widget.subCategory.menu.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return CardMenuList(
                                food: this.widget.subCategory
                                    .menu[index],
                                onCardClick: () {

                                },
                              );
                            },
                          )
                      )
                    ],
                  ),
                )
              ]
          )
      )
    );
  }
}
