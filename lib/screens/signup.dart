import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grapfood/utility/my_constant.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/normal_dialog.dart';
import 'package:grapfood/utility/singout_process.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var name, user, password,chooseType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          showLogo(),
          nameForm(),
          MyStyle().mySizebox(),
          userForm(),
          MyStyle().mySizebox(),
          passwordForm(),
          MyStyle().mySizebox(),
          userRedio(),
          riderRedio(),
          shopRedio(),
          Container(
            width: 250.0,
            // ignore: deprecated_member_use
            child: RaisedButton(

              child: Text('SignUP',style: TextStyle(color: Colors.white),),
              color: MyStyle().darkColor,
              onPressed: () {
                print('Name = $name  User = $user Password =$password ChooseType = $chooseType');
                if (name == null ||
                    name.toString().isEmpty ||
                    user == null ||
                    user.toString().isEmpty ||
                    password == null || password.toString().isEmpty)  {
                  normalDialog(context, 'กรุณากรอกข้อมูลให้ครบด้วยค่ะ');

                }else{
                  checkUser();
                }
              },
            ),
          )
        ],
      ),
    );
  }
  Row userRedio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 'User',
          groupValue: chooseType,
          onChanged: (value) {
            setState(() {
              chooseType = value;
            });
          },
        ),
        Text('User')
      ],
    );
  }

  Row shopRedio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 'Shop',
          groupValue: chooseType,
          onChanged: (value) {
            setState(() {
              chooseType = value;
            });
          },
        ),
        Text('Shop')
      ],
    );
  }

  Row riderRedio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 'Rider',
          groupValue: chooseType,
          onChanged: (value) {
            setState(() {
              chooseType = value;
            });
          },
        ),
        Text('Rider')
      ],
    );
  }

  Container nameForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.face,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(fontSize: 20.0, color: MyStyle().darkColor),
          labelText: 'Name',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primaryColor)),
        ),
      ),
    );
  }

  Container userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(fontSize: 20.0, color: MyStyle().darkColor),
          labelText: 'User',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primaryColor)),
        ),
      ),
    );
  }

  Container passwordForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: MyStyle().darkColor,
          ),
          labelStyle: TextStyle(fontSize: 20.0, color: MyStyle().darkColor),
          labelText: 'Password',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primaryColor)),
        ),
      ),
    );
  }

  Row showLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[MyStyle().showLogo()],
    );
  }

  Future<Null> checkUser() async{
    String url = '${MyConstant().domain}grapfood/getUserWhereUser.php?isAdd=true&User=$user';
    Response response = await Dio().get(url);
    try{
      if(response.toString()== 'null'){
        registerThread();
      }else{
        normalDialog(context, 'มีชื่อ User นี้ในระบบแล้วกรุณาเปลี่ยน User ใหม่');
      }
    }catch (e){

    }
  }

  Future<Null> registerThread() async{
    String url = '${MyConstant().domain}grapfood/addUser.php?isAdd=true&ChooseType=$chooseType&Name=$name&User=$user&Password=$password';
    Response response = await Dio().get(url);
    try{
     if(response.toString()== 'true'){
       normalDialog(context, 'สมัครสมาชิกเรียบร้อยแล้วค่ะ');
       SignOutProcess(context);

     }else{
       normalDialog(context, 'ไม่สามารถสมัครได้ กรุณาลองใหม่ค่ะ');
     }
    }catch (e){
      normalDialog(context, 'ไม่สามารถติดต่อ Server ได้ค่ะ กรุณาลองใหม่ภายหลัง');
    }
  }
}
