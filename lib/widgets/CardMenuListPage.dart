import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/models/Food.dart';
import 'package:sistema_registro_pedidos/models/FoodCenter.dart';

class CardMenuList extends StatelessWidget {

  Food food;
  Function onCardClick;

  CardMenuList({this.food, this.onCardClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                child: Opacity(child: Image.network(this.food.img, fit: BoxFit.cover,), opacity: 0.8,),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            Positioned(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent
                        ]
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
                ),
              ),
              bottom: 0,
              left: 0,
              right: 0,
            ),
            Positioned.fill(
              top: 95,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text(
                            this.food.nombre,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                            )
                        ),
                        Text(
                          this.food.descripcion,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      this.food.precio.toString()+" Bs.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        this.onCardClick();
      },
    );
  }
}