class Item {
  String id;
  String name;
  int quantity;
  bool available;
  DateTime addedDate;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.available,
    required this.addedDate,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      name: json['name'],
      quantity: json['quantity'],
      available: json['available'],
      addedDate: DateTime.parse(json['addedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'quantity': quantity,
      'available': available,
      'addedDate': addedDate.toIso8601String(),
    };
  }
}
