class InventoryItem {
  final int id;
  final String name;
  final int quantity;
  final DateTime expiryDate;
  final DateTime addedDate;
  final String? imageUrl;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.expiryDate,
    required this.addedDate,
    this.imageUrl,
  });

  // Factory constructor to create an InventoryItem from JSON
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      expiryDate: DateTime.parse(json['expiryDate']),
      addedDate: DateTime.parse(json['addedDate']),
      imageUrl: json['imageUrl'],
    );
  }
}
