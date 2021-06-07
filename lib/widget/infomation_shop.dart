import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grapfood/model/user_model.dart';
import 'package:grapfood/screens/add_infomation_shop.dart';
import 'package:grapfood/screens/edit_infomation_shop.dart';
import 'package:grapfood/utility/my_constant.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfomationShop extends StatefulWidget {
  @override
  _InfomationShopState createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {
  var userModel;
  double lat = 0.0;
  double lng = 0.0;
  @override
  void initState() {
    readData();
    // TODO: implement initState
    super.initState();
  }

  void routerToAddInfo(BuildContext context) {
    Widget widget =
        userModel.nameShop.isEmpty ? AddInfomationShop() : EditInfoShop();
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, route).then((value) => readData());
  }

  Future<Null> readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('id');

    String url =
        '${MyConstant().domain}grapfood/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel.nameShop.isEmpty
                ? showNodata(context)
                : showListInfoShop(),
        addAndEditButtom(),
      ],
    );
  }

  Widget showListInfoShop() => Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyStyle()
                        .showTitleH2('รายละเอียดร้าน ${userModel.nameShop}'),
                  ],
                ),
              ),
              MyStyle().showTitleH2('เบอร์โทร: ${userModel.phone}'),
              MyStyle().mySizebox(),
              MyStyle().showTitleH2('ที่อยู่ร้าน : ${userModel.address}'),
              MyStyle().mySizebox(),
              showImage(),
              MyStyle().mySizebox(),
              shopMap()
            ],
          ),
        ),
      );

  Container showImage() {
    var url;
    url = '${MyConstant().domain}${userModel.uriPicture}';
    print(url);
    return Container(
      width: 300.0,
      child: Image.network(url),
    );
  }

  Widget shopMap() {
    lat = double.parse(userModel.lat);
    lng = double.parse(userModel.lng);
    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Container(
      padding: EdgeInsets.all(10.0),
      height: 400.0,width: 500,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'ร้านของคุณ', snippet: 'ละติจูด =$lat , ลองติจูด =$lng'),
      )
    ].toSet();
  }

  Widget showNodata(BuildContext context) =>
      MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูลด้วยค๋ะ');

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
