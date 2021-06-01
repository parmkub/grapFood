import 'package:flutter/material.dart';
import 'package:grapfood/screens/home.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/singout_process.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRider extends StatefulWidget {

  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {

  var name;
  @override
  void initState() {
    findUser();
    // TODO: implement initState
    super.initState();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.get('name').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$name Rider'),
          actions: <Widget>[
            IconButton(onPressed: (){
              SignOutProcess(context);
            }, icon: Icon(Icons.exit_to_app))
          ],

        ),
      drawer: Drawer(
          child: ListView(
            children: <Widget>[
              showHeaderRider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                onTap: ()=>SignOutProcess(context),
              )
            ],
          )
      ),
    );
  }

  UserAccountsDrawerHeader showHeaderRider() {
    return UserAccountsDrawerHeader(
                decoration: MyStyle().myBoxDecoration('rider.jpg'),
                currentAccountPicture: MyStyle().showLogo(),
                accountName: MyStyle().showTitleH1('$name'),
                accountEmail: MyStyle().showTitleH2('$name@gmail.com'));
  }
}
