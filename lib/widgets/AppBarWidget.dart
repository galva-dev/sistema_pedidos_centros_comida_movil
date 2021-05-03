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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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