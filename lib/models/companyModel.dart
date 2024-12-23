class companyModel {
  int? id;
  String name;

  companyModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory companyModel.fromMap(Map<String, dynamic> map) {
    return companyModel(
      name: map['name'],
      id: map['id'],
    );
  }
}
