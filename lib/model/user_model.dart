class UserModel {
  String id ="";
  String chooseType ="";
  String name = "";
  String user = "";
  String password ="";
  String nameShop ="";
  String address ="";
  String phone ="";
  String uriPicture ="";
  String lat ="";
  String lng= "";

  UserModel(
      {required this.id,
        required this.chooseType,
        required this.name,
        required this.user,
        required this.password,
        required this.nameShop,
        required this.address,
        required this.phone,
        required this.uriPicture,
        required this.lat,
        required this.lng});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chooseType = json['ChooseType'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    nameShop = json['NameShop'];
    address = json['Address'];
    phone = json['Phone'];
    uriPicture = json['UriPicture'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ChooseType'] = this.chooseType;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['NameShop'] = this.nameShop;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['UriPicture'] = this.uriPicture;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}

