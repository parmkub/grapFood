import 'package:flutter/material.dart';
import 'package:grapfood/model/food_model.dart';

class EditFoodMenu extends StatefulWidget {
  final foodModel;

   EditFoodMenu({this.foodModel}) : super();

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  var foodModel;

  @override
  void initState() {
    // TODO: implement initState
    foodModel = widget.foodModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('ปรับปรุงเมนู ${foodModel.nameFood}'),),);
  }
}
