import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_registro_pedidos/pages/CategoryListPage.dart';
import 'package:sistema_registro_pedidos/provider/GoogleProvider.dart';
import 'package:sistema_registro_pedidos/widgets/WelcomeWidget.dart';

class WelcomePage extends StatelessWidget {

  Widget buildLoading() => Center(
        child: Center(child: CircularProgressIndicator()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);
            if (provider.isSigningIn) {
              print('SIGO CARGANDO');
              return buildLoading();
            } else if (snapshot.hasData) {
              print('ME VOY A LA PAGINA');
              return CategoryListPage();
            } else {
              print('ME MANTENGO EN LA PAGINA');
              return WelcomeWidget();
            }
          },
        ),
      ),
    );
  }
}
