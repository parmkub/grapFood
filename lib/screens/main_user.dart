import 'package:flutter/material.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/singout_process.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              SignOutProcess(context);
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: MyStyle().showTitleH1('Name'),
              accountEmail: MyStyle().showTitleH2('name@gmail.com'),
              decoration: MyStyle().myBoxDecoration('user.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
