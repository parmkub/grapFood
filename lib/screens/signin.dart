import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grapfood/model/user_model.dart';
import 'package:grapfood/screens/main_rider.dart';
import 'package:grapfood/screens/main_shop.dart';
import 'package:grapfood/screens/main_user.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var user,password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SingIn'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: <Color>[Colors.white, MyStyle().primaryColor],
                radius: 1.0,
                center: Alignment(0, -0.4))),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().showTitle('GrapFood'),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                btnLogin(),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Container userForm() {
    return Container(
      width: 250,
      child: TextField(
        onChanged: (value) => {user = value.trim()},
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)
            )
        ),
      ),
    );
  }
  Container passwordForm() {
    return Container(
      width: 250,
      child: TextField(
        onChanged: (value) => {password = value.trim()},
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'Password',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().darkColor),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)
            )
        ),
      ),
    );
  }
  Container btnLogin() {
    return Container(
      width: 250.0,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: MyStyle().darkColor,
        onPressed: (){
          if(user == null || user.isEmpty || password == null || password.isEmpty){
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบค่ะ');
          }else{
            checkAuthens();
          }
        },
        child: Text('Login',
          style: TextStyle(color: Colors.white),),
      ),
    );
  }
  Future<Null> checkAuthens() async {
    String url = 'http://61.7.142.47:8080/grapfood/getUserWhereUser.php?isAdd=true&User=$user';
    try{
       Response response = await Dio().get(url);
       if(response.toString() == 'null'){
         normalDialog(context, 'ไม่มี User ในระบบ');
       }else {
         var resutl = json.decode(response.data);
         for (var map in resutl) {
           UserModel userModel = UserModel.fromJson(map);
           String view = userModel.password;
           if (view == password) {
             if (userModel.chooseType == 'User') {
               routerToService(MainUser(), userModel);
             } else if (userModel.chooseType == 'Shop') {
               routerToService(MainShop(), userModel);
             } else if (userModel.chooseType == 'Rider') {
               routerToService(MainRider(), userModel);
             }
           } else {
             normalDialog(context, 'Password ผิดกรุณากรอกใหม่');
           }
         }
       }

    }catch (e){

    }
  }
  Future<Null> routerToService(Widget myWidget,UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id);
    preferences.setString('ChooseType', userModel.chooseType);
    preferences.setString('name', userModel.name);

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
