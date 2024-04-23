class Items {
  final String itemName;
  final        image;
  final double price;

  Items({
    required this.itemName,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      "itemName": itemName,
      "image": image,
      "price": price,
    };
  }
}