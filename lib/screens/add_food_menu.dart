import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grapfood/utility/my_constant.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  ImagePicker picked = ImagePicker();
  var file;

  var foodDetail, nameFood, priceFood, shopName;

  var nameImage, idShop;

  @override
  void initState() {
    getPreferentce();
    // TODO: implement initState
    super.initState();
  }

  Future<Null> getPreferentce() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopName = preferences.get('name');
    idShop = preferences.get('id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการเมนูอาหาร'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              gropImage(),
              MyStyle().mySizebox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyStyle().showTitle('รายละเอียดอาหาร'),
                ],
              ),
              MyStyle().mySizebox(),
              menuName(),
              MyStyle().mySizebox(),
              menuDetail(),
              MyStyle().mySizebox(),
              menuPrice(),
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              saveFoodMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Container saveFoodMenu(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        // ignore: deprecated_member_use
        child: RaisedButton.icon(
            onPressed: () {
              addMenuFood();
            },
            color: MyStyle().primaryColor,
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            )));
  }

  Future<Null> addMenuFood() async {
    if (nameFood.isEmpty ||
        nameFood == null ||
        foodDetail.isEmpty ||
        priceFood.isEmpty ||
        priceFood == null) {
      normalDialog(context, 'กรุณากรอกข้อมูลให้ครับ');
    } else if (file == null) {
      normalDialog(context, 'กรุณาเลือกรูปภาพ');
    } else {
      upLoadImage();
    }
  }

  Future<Null> inSertData() async {
    print('idShop==>$idShop NameFood ==> $nameFood');
    String path =
        '${MyConstant().domain}grapfood/addFood.php?isAdd=true&idShop=$idShop&NameFood=$nameFood&PathImage=grapfood/Food/$nameImage&Price=$priceFood&Detail=$foodDetail';
    Response response = await Dio().get(path);
    if (response.toString() == 'true') {
      Navigator.pop(context);
    } else {
      normalDialog(context, 'ไม่สามารถบันทึกข้อมูลได้');
    }
  }

  Widget menuName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => nameFood = value,
            decoration: InputDecoration(
                labelText: 'ชื่อเมนูอาหาร',
                prefixIcon: Icon(Icons.restaurant_menu),
                border: OutlineInputBorder()),
          ),
        )
      ],
    );
  }

  Widget menuDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            onChanged: (value) => foodDetail = value,
            decoration: InputDecoration(
                labelText: 'รายละเอียดของอาหาร',
                prefixIcon: Icon(Icons.fastfood),
                border: OutlineInputBorder()),
          ),
        )
      ],
    );
  }

  Widget menuPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => priceFood = value,
            decoration: InputDecoration(
                labelText: 'ราคา',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder()),
          ),
        )
      ],
    );
  }

  Row gropImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            getImageCamera();
          },
          icon: Icon(Icons.camera_alt),
          iconSize: 36.0,
        ),
        Container(
          width: 220.0,
          child: file == null
              ? Image.asset('images/myimge.png')
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () {
            getImageFile();
          },
          icon: Icon(Icons.photo_album),
          iconSize: 36.0,
        )
      ],
    );
  }

  Future<Null> getImageFile() async {
    final pickedFile = await picked.getImage(
      source: ImageSource.gallery,
      maxHeight: 800.0,
      maxWidth: 800.0,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> upLoadImage() async {
    String patch = '${MyConstant().domain}grapfood/saveFood.php';
    Random random = Random();
    int i = random.nextInt(100000);
    nameImage = '$shopName-$nameFood-$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);

      await Dio().post(patch, data: formData).then((value) {
        print('Response ====>> $value');
        inSertData();
      });
    } catch (e) {}
  }

  Future<Null> getImageCamera() async {
    final pickedFile = await picked.getImage(
      source: ImageSource.camera,
      maxHeight: 800.0,
      maxWidth: 800.0,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
