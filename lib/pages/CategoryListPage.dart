import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/helpers/Utils.dart';
import 'package:sistema_registro_pedidos/models/Category.dart';
import 'package:sistema_registro_pedidos/pages/SelectedCategoryPage.dart';
import 'package:sistema_registro_pedidos/provider/GoogleProvider.dart';
import 'package:sistema_registro_pedidos/widgets/CardListCategoriesWidget.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key key}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Category> categories = Utils.getMockedCategories();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            )),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Seleccione una categoria',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: categories.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return CardListCategories(
                        category: categories[index],
                        onCardClick: () {
                          //TODO navigate to another page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectedCategoryPage(
                                        selectedCategory:
                                            this.categories[index],
                                      )));
                        },
                      );
                    },
                  ))
                ],
              ),
            ),
          ],
        ));
  }
}
