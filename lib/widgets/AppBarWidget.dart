import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(60);
}

class _MainAppBarState extends State<MainAppBar> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('¡A COMER!'),
      centerTitle: true,
      leading: Container(
        padding: EdgeInsets.only(left: 10),
        child: Image.asset('assets/images/logo.png'),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        Container(
          padding: EdgeInsets.only(top: 10, right: 10),
          child: CircleAvatar(
            maxRadius: 25,
            backgroundImage: NetworkImage(user.photoURL),
          ),
        )
      ],
    );
  }
}
