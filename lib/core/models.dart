class Food {
  const Food(
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.category,
  );
  final String id, name, description, image, category;
  final int price;
}

const foods = [
  Food(
    'salad',
    'Prawn mix salad',
    'Fresh prawn mix salad',
    899,
    'salad',
    'Vegetables',
  ),
  Food(
    'chicken',
    'Grilled chicken',
    'Grilled chicken legs with spices',
    1199,
    'chicken',
    'Fast Food',
  ),
  Food(
    'rice',
    'Rice green peas',
    'Green peas, shrimps and arugula',
    650,
    'rice',
    'Vegetables',
  ),
  Food(
    'baked',
    'Baked chicken',
    'Roasted chicken with a rich tomato dip',
    1099,
    'baked_chicken',
    'Fast Food',
  ),
  Food(
    'waffles',
    'Waffles',
    'Fresh berries and maple syrup',
    299,
    'waffles',
    'Ice Cream',
  ),
  Food(
    'soup',
    'Pumpkin soup',
    'Roasted pumpkin, cream and herbs',
    499,
    'soup',
    'Vegetables',
  ),
  Food(
    'hummus',
    'Hummus',
    'Chickpeas, tahini and olive oil',
    499,
    'hummus',
    'Vegetables',
  ),
];
String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

class CartLine {
  CartLine(this.foodId, this.size, this.quantity);
  final String foodId, size;
  int quantity;
  Food get food => foods.firstWhere((f) => f.id == foodId);
  String get key => '$foodId:$size';
  int get unitPrice =>
      food.price +
      (size == 'L'
          ? 200
          : size == 'S'
          ? -100
          : 0);
  Map<String, dynamic> toJson() => {
    'food': foodId,
    'size': size,
    'quantity': quantity,
  };
}
