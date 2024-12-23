class salesModel {
  int? id;
  String date;
  String name;
  String mobile;
  String company;
  String itemname;
  String price;
  String? wardays;
  String? code;
  // List<String> images;

  salesModel({
    this.id,
    required this.date,
    required this.name,
    required this.mobile,
    required this.company,
    required this.itemname,
    required this.price,
    this.wardays,
    this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'name': name,
      'mobile': mobile,
      'company': company,
      'itemname': itemname,
      'price': price,
      'wardays': wardays,
      'code': code,
      'id': id,
    };
  }

  factory salesModel.fromMap(Map<String, dynamic> map) {
    return salesModel(
      date: map['date'],
      name: map['name'],
      mobile: map['mobile'],
      company: map['company'],
      itemname: map['itemname'],
      price: map['price'],
      wardays: map['wardays'],
      code: map['code'],
      id: map['id'],
    );
  }
}
