import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grapfood/model/food_model.dart';
import 'package:grapfood/screens/add_food_menu.dart';
import 'package:grapfood/screens/edit_food_menu.dart';
import 'package:grapfood/utility/my_constant.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenuShop extends StatefulWidget {
  @override
  _ListFoodMenuShopState createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  var idShop;
  bool status = true;
  bool statusLoad = true;
  List<FoodModel> foodModels = [];

  @override
  void initState() {
    ReadDataFood();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        statusLoad ? MyStyle().showProgress() : showContent(),
        addMenuButtom(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget showListFood() {
    return ListView.builder(
      itemCount: foodModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            child: Image.network(
              '${MyConstant().domain}${foodModels[index].patchImage}',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyStyle().showTitle(foodModels[index].nameFood),
                  Text(
                    'ราคา ${foodModels[index].price} บาท',
                    style: MyStyle().mainTitle,
                  ),
                  MyStyle().mySizebox(),
                  Text(
                    'รายละเอียดอาหาร : ${foodModels[index].detail}',
                    style: MyStyle().mainTitleH2Title,
                  ),
                  MyStyle().mySizebox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditFoodMenu(
                                    foodModel: foodModels[index],
                                  ));
                          Navigator.push(context, route)
                              .then((value) => ReadDataFood());
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteFoodButtom(foodModels[index]);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 30.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> ReadDataFood() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.get('id');

    String path =
        '${MyConstant().domain}grapfood/getFoodWhereID.php?isAdd=true&idshop=$idShop';

    await Dio().get(path).then((value) {
      var result = json.decode(value.data);
      print('result===> $result');
      setState(() {
        statusLoad = false;
      });

      if (result != null) {
        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          print(foodModel);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  Future<Null> deleteFoodButtom(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle()
            .showTitleH2('คุณต้องการลบเมนู${foodModel.nameFood}นี้หรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  String path =
                      "${MyConstant().domain}grapfood/deleteFood.php?isDelete=true&idfood=${foodModel.id}";
                  await Dio().get(path).then((value) {
                    if (value.toString() == 'true') {
                      Navigator.pop(context);
                      normalDialog(context, 'ลบข้อมูลเรียบร้อยแล้ว');
                      ReadDataFood();
                    } else {
                      normalDialog(context, 'ไม่สามารถลบข้อมูลได้');
                    }
                  });
                },
                child: Text(
                  'ยืนยัน',
                  style: MyStyle().mainTitleH2Title,
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ยกเลิก',
                  style: MyStyle().mainTitleH2Title,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget addMenuButtom() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route =
                        MaterialPageRoute(builder: (context) => AddFoodMenu());
                    Navigator.push(context, route)
                        .then((value) => ReadDataFood());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
