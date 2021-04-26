import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';

class CardListCategories extends StatelessWidget {

  Category category;
  Function onCardClick;

  CardListCategories({this.category, this.onCardClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(20),
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                child: Image.asset('assets/images/category/'+this.category.imgName, fit: BoxFit.cover),
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
                          Colors.black.withOpacity(0.7),
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
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        child: Icon(this.category.icon.icon, size: 25, color: Colors.white,),
                        color: this.category.color,
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      this.category.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: (){
        this.onCardClick();
      },
    );
  }
}
