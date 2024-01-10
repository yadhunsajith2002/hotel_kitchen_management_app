class OrderModel {
  final String id;
  final List<Map<String, dynamic>> items;

  OrderModel({
    required this.id,
    required this.items,
  });
}
