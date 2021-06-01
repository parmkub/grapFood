import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grapfood/utility/my_style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AddInfomationShop extends StatefulWidget {
  @override
  _AddInfomationShopState createState() => _AddInfomationShopState();
}

class _AddInfomationShopState extends State<AddInfomationShop> {
  double lat = 0.0;
  double lng = 0.0;
  var nameShop, address, phone;
  final picker = ImagePicker();
  var file;

  @override
  void initState() {
    fondLatLng();
    // TODO: implement initState
    super.initState();
  }

  Future<Null> fondLatLng() async {
    Location location = new Location();
    LocationData locationData;
    try {
      locationData = await location.getLocation();
      setState(() {
        lat = locationData.latitude!;
        lng = locationData.longitude!;
      });
    } catch (e) {}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Infomation Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizebox(),
            nameForm(),
            MyStyle().mySizebox(),
            addressForm(),
            MyStyle().mySizebox(),
            phoneForm(),
            MyStyle().mySizebox(),
            groupImage(),
            MyStyle().mySizebox(),
            Container(
              height: 300.0,
              child: lat == 0.0 ? MyStyle().showProgress() : showMap(),
            )
          ],
        ),
      ),
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => nameShop = value.trim(),
              decoration: InputDecoration(
                  labelText: 'ชื่อร้านค้า',
                  prefixIcon: Icon(Icons.account_box),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      );
  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => address = value.trim(),
              decoration: InputDecoration(
                  labelText: 'ที่อยู่',
                  prefixIcon: Icon(Icons.house),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      );
  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  labelText: 'เบอร์โทร',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      );

  Future<Null> getImage() async {
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

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () => {getImage()}),
        Container(
          //ignore: unnecessary_null_comparison
          child: file == null
              ? Image.asset('images/myimge.png')
              : Image.file(file),
          width: 250.0,
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () => {getImageFile()}),
      ],
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

  Container showMap() {
    print('latitude= $lat');
    print('longitude= $lng');
    LatLng latlng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(target: latlng, zoom: 15.0);
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }
}
