import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grapfood/model/user_model.dart';
import 'package:grapfood/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {

  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  late UserModel userModel;


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('รายการอาหารที่สั่งคงค้าง'),
              ],
            ),
          )
        ],
    );
  }
}
