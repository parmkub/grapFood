import 'package:flutter/material.dart';
import 'package:grapfood/screens/home.dart';
import 'package:grapfood/utility/my_style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: Home(),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('guest.jpg'),
        accountName: Text('Guest'),
        accountEmail: Text('user@mail.com'));
  }
}


