import 'package:flutter/material.dart';
import 'package:grapfood/screens/main_rider.dart';
import 'package:grapfood/screens/main_shop.dart';
import 'package:grapfood/screens/main_user.dart';
import 'package:grapfood/screens/signin.dart';
import 'package:grapfood/screens/signup.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {
  var chooseType ;

  @override
  void initState() {
    checkPreference();
    // TODO: implement initState
    super.initState();

  }

  Future<Null> checkPreference() async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      chooseType = preferences.get('ChooseType');
      if(chooseType != null && chooseType.isNotEmpty){
        if(chooseType == 'User'){
          routToService(MainUser());
        }else if(chooseType == 'Shop'){
          routToService(MainShop());
        }else if(chooseType == 'Rider'){
          routToService(MainRider());
        }
      }

    }catch (e){


    }
  }
  void routToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          showHeadDrawer(),
          ListTile(
            leading: Icon(Icons.android),
            title: Text('Sign Up'),
            onTap: () {
              Navigator.pop(context);
              MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => SignUp());
              Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: Icon(Icons.android),
            title: Text('Login'),
            onTap: () {
              Navigator.pop(context);
              MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => SignIn());
              Navigator.push(context, route);
            },
          )
        ]),
      ),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('guest.jpg'),
        accountName: Text('Guest'),
        accountEmail: Text('user@mail.com'));
  }
}
