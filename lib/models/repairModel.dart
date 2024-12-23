class repairModel {
  int? id;
  String date;
  String? deldate;
  String name;
  String mobile;
  String devModel;
  String devFault;
  String devCost;
  String status;
  String? wardays;
  String? code;
  List<String> images;

  repairModel(
      {this.id,
      required this.date,
      required this.name,
      required this.mobile,
      required this.devModel,
      required this.devFault,
      required this.devCost,
      required this.status,
      this.deldate,
      this.wardays,
      this.code,
      required this.images});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'name': name,
      'mobile': mobile,
      'devModel': devModel,
      'devFault': devFault,
      'devCost': devCost,
      'status': status,
      'wardays': wardays,
      'code': code,
      'deldate': deldate,
      'images': images,
      'id': id,
    };
  }

  factory repairModel.fromMap(Map<String, dynamic> map) {
    return repairModel(
        date: map['date'],
        name: map['name'],
        mobile: map['mobile'],
        devModel: map['devModel'],
        devFault: map['devFault'],
        devCost: map['devCost'],
        status: map['status'],
        wardays: map['wardays'],
        code: map['code'],
        deldate: map['deldate'],
        id: map['id'],
        images: List<String>.from(map['images'] ?? []));
  }
}
