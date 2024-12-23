class itemModel {
  int? id;
  String name;

  itemModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory itemModel.fromMap(Map<String, dynamic> map) {
    return itemModel(
      name: map['name'],
      id: map['id'],
    );
  }
}
