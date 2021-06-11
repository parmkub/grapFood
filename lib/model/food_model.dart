class FoodModel {
  String id = '';
  String idshop = '';
  String nameFood = '';
  String patchImage = '';
  String price ='';
  String detail ='';

  FoodModel(
      {required this.id,
        required this.idshop,
        required this.nameFood,
        required this.patchImage,
        required this.price,
        required this.detail});

  FoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idshop = json['idshop'];
    nameFood = json['NameFood'];
    patchImage = json['PatchImage'];
    price = json['Price'];
    detail = json['Detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idshop'] = this.idshop;
    data['NameFood'] = this.nameFood;
    data['PatchImage'] = this.patchImage;
    data['Price'] = this.price;
    data['Detail'] = this.detail;
    return data;
  }
}

