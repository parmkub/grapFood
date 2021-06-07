import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grapfood/model/user_model.dart';
import 'package:grapfood/screens/add_infomation_shop.dart';
import 'package:grapfood/utility/my_constant.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:grapfood/utility/normal_dialog.dart';
import 'package:grapfood/widget/infomation_shop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  var idshop;
  var userModel;
  final picker = ImagePicker();
  var file,nameFile;
  String nameShop = '', address = '', phone = '', uriPicture = '';
  double lat = 0.0, lng = 0.0;

  Location location = Location();

  @override
  void initState() {
    readCurrentInfo();
    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude!;
        lng = event.longitude!;
        //print('lat =======>$lat  lng========>$lng');
      });
    });

    // TODO: implement initState
    super.initState();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idshop = preferences.getString('id');
    print('ID===> $idshop');
    String url =
        '${MyConstant().domain}grapfood/getUserWhereId.php?isAdd=true&id=$idshop';
    Response response = await Dio().get(url);
    var result = jsonDecode(response.data);
    // print('resultAll====> $result');
    for (var map in result) {
      print('map===>$map');
        setState(() {
          userModel = UserModel.fromJson(map);
          nameShop = userModel.nameShop;
          address = userModel.address;
          phone = userModel.phone;
          uriPicture = userModel.uriPicture;
        });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขรายละเอียดร้าน'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              showImageGroup(),
              userModel == null ? MyStyle().showProgress() : showContent(),
              btnEditSubmit(context)
            ],
          ),
        ),
      ),

    );
  }

  Container btnEditSubmit(BuildContext context) {
    return Container(margin: EdgeInsets.only(left: 20.0,right: 20.0),
              width: MediaQuery.of(context).size.width,
              // ignore: deprecated_member_use
              child: RaisedButton.icon(color: MyStyle().primaryColor,
                  onPressed: () {
                    confirmDialog();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text('ปรับปรุง รายละเอียด',style: TextStyle(color: Colors.white),)),
            );
  }

  Container showImageGroup() {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () => {getImageCamera()},
            icon: Icon(Icons.photo_camera),
            iconSize: 36.0,
          ),
          Container(
            width: 250.0,
            child: uriPicture.isEmpty
                ? MyStyle().showProgress()
                : file == null
                    ? Image.network('${MyConstant().domain}$uriPicture')
                    : Image.file(file),
          ),
          IconButton(
            onPressed: () => {getImageFile()},
            icon: Icon(Icons.add_photo_alternate),
            iconSize: 36.0,
          )
        ],
      ),
    );
  }

  Widget showContent() => Column(
        children: <Widget>[
          MyStyle().mySizebox(),
          nameShopForm(),
          MyStyle().mySizebox(),
          addressForm(),
          MyStyle().mySizebox(),
          phoneForm(),
          MyStyle().mySizebox(),
          shopMap(),
        ],
      );

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

  Widget shopMap() {
    print('lat =======>$lat |||||| lng========>$lng');
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );
    return Container(
      padding: EdgeInsets.all(30.0),
      margin: EdgeInsets.only(top: 16.0),
      height: 400,width: 500,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

  Future<Null> editThred()async{
    Random rendom = Random();
    int i = rendom.nextInt(100000);
    setState(() {
       nameFile = 'edt$nameShop$i.jpg';
    });

    Map<String, dynamic> map = Map();
    map['file'] =  await MultipartFile.fromFile(file.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}grapfood/saveShop.php';
    await Dio().post(urlUpload, data: formData).then((value) async{
      uriPicture = 'grapFood/Shop/$nameFile';
    print('nameShop==>$nameShop address===>$address phone====>$phone lat===>$lat lng==>$lng' );
        String url = '${MyConstant().domain}grapfood/editUserWhereId.php/?isAdd=true&id=$idshop&nameshop=$nameShop&address=$address&phone=$phone&uriPicture=$uriPicture&lat=$lat&lng=$lng';
    Response response = await Dio().get(url);
    if(response.toString() == 'true'){
    Navigator.pop(context);
    // print('ชื่อร้านใหม่=====>$nameShop');
    }else{
    normalDialog(context, 'กรุณาลองใหม่อีกครั้งค่ะ');
    }
    });


  }

  Future<Null> getImageCamera() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800.00,
      maxWidth: 800.00,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> getImageFile() async {
    final pickedFile = await picker.getImage(
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

  Future<Null> confirmDialog() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('คุณแน่ใจจะปรับปรุงรายละเอียดร้าน หรือค่ะ'),
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    Navigator.pop(context);
                    editThred();
                  },
                  child: Text('แน่ใจ'),
                ),
                OutlineButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ไม่แน่ใจ'),
                )
              ],
            )
          ],
        ));
  }

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            margin: EdgeInsets.only(top: 16.0),
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ชื่อของร้าน'),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            margin: EdgeInsets.only(top: 16.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่'),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            margin: EdgeInsets.only(top: 16.0),
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เบอร์โทร'),
            ),
          ),
        ],
      );
}
