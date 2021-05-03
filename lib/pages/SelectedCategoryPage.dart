import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/pages/DetailsFoodPage.dart';
import 'package:sistema_registro_pedidos/pages/MenuListFoodCenterPage.dart';
import 'package:sistema_registro_pedidos/widgets/AppBarWidget.dart';
import 'package:sistema_registro_pedidos/widgets/CardListSubCategoriesWidget.dart';

class SelectedCategoryPage extends StatelessWidget {
  Category selectedCategory;

  SelectedCategoryPage({this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
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
                                  selectedCategory.icon.icon, size: 25,
                                  color: Colors.white,),
                                color: selectedCategory.color,
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Text(
                              selectedCategory.name,
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
                              itemCount: selectedCategory.subCategories.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return CardListSubCategories(
                                  category: selectedCategory
                                      .subCategories[index],
                                  onCardClick: () {
                                    //TODO navigate to details page
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsFoodPage(
                                              foodCenter: this.selectedCategory
                                                  .subCategories[index],)));
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