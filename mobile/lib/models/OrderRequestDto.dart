class OrderRequestDto {
  final int productId;
  final int quantity;
  final double totalPrice;

  OrderRequestDto({
    required this.productId,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
