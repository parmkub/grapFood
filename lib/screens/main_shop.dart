import 'package:flutter/material.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/singout_process.dart';
import 'package:grapfood/widget/infomation_shop.dart';
import 'package:grapfood/widget/list_food_menu_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {

  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  var currentWidget;
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
      name = preferences.getString('name')!;
      print(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentWidget,
      appBar: AppBar(
        title: Text('$name Shop'),
        actions: <Widget>[
          IconButton(onPressed: (){
            SignOutProcess(context);
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            showHead(),
            homeMenu(),
            footMenu(),
            infomationMunu(),
            signOutMenu()
          ],
        ),

      ),

    );
  }

  UserAccountsDrawerHeader showHead() {
    return
      UserAccountsDrawerHeader(
          currentAccountPicture: MyStyle().showLogo(),
          decoration: MyStyle().myBoxDecoration('shop.jpg'),
          accountName: MyStyle().showTitleH1('$name@shop'),
          accountEmail: MyStyle().showTitleH2('$name@mail.com'));
  }

  ListTile homeMenu() {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('รายการอาหารที่ลูกค้าสั่ง'),
      subtitle: Text('รายการอาหารที่ยังไม่ได้ทำส่ง'),
      onTap: () {
        setState(() {
           //currentWidget = OrderListShop();
        });
        Navigator.pop(context);
      },
    );
  }
  ListTile footMenu() {
    return
      ListTile(
          leading: Icon(Icons.fastfood),
          title: Text('รายการอาหาร'),
          subtitle: Text('รายการอาหาร ของร้าน'),
          onTap: () {
            setState(() {
              currentWidget = ListFoodMenuShop();
            });
            Navigator.pop(context);
          });
  }
  ListTile infomationMunu() {
    return ListTile(
        leading: Icon(Icons.map),
        title: Text('รายละเอียดของร้าน'),
        subtitle: Text('รายละเอียดของร้านพร้อม Edit'),
        onTap: () {
          setState(() {
            currentWidget = InfomationShop();
          });
          Navigator.pop(context);
        });
  }
  ListTile signOutMenu() {
    return ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('ออกจากระบบ'),
        onTap: () => SignOutProcess(context));
  }
}


