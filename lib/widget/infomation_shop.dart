import 'package:flutter/material.dart';
import 'package:grapfood/screens/add_infomation_shop.dart';
import 'package:grapfood/utility/my_style.dart';

class InfomationShop extends StatefulWidget {

  @override
  _InfomationShopState createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {

  void routerToAddInfo(BuildContext context) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => AddInfomationShop(),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        addAndEditButtom(),
        MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูลด้วยค๋ะ')
      ],

    );
  }

  Row addAndEditButtom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                onPressed: () => routerToAddInfo(context),
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
