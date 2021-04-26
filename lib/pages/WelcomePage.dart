import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sistema_registro_pedidos/pages/CategoryListPage.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 300,
                      height: 250,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      splashColor: Colors.red.withOpacity(0.6),
                      highlightColor: Colors.black.withOpacity(0.9),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryListPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3
                          ),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: Icon(FontAwesomeIcons.google, color: Colors.red,size: 20,),
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  'Continuar con Google',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Lora'
                                  ),
                                ),
                              ],
                            )
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}