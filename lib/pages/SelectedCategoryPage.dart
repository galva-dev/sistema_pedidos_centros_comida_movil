import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/pages/DetailsFoodCenterPage.dart';
import 'package:sistema_registro_pedidos/widgets/CardListSubCategories.dart';

class SelectedCategoryPage extends StatelessWidget {
  Category selectedCategory;

  SelectedCategoryPage({this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
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
                                            DetailsFoodCenterPage(
                                              subCategory: this.selectedCategory
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

/*
* child: GridView.count(
                              crossAxisCount: 2,
                              children: List.generate(
                                  this.selectedCategory.subCategories.length,
                                  (index) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          ClipOval(
                                            child: Image.asset(
                                                'assets/images/category/'+this.selectedCategory.subCategories[index].imgName,
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            this.selectedCategory.subCategories[index].nombre,
                                            style: TextStyle(
                                              color: Colors.white,

                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              )
                            ),
* */