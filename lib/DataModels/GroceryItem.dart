class GroceryItem{

  String name, quantity, unit, category;
  bool status;
  DateTime time;

  GroceryItem({this.time, this.name, this.quantity, this.unit, this.category, this.status});

  Map<String, dynamic> toMap() {
    return {
      'time': time.toString(),
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'category': category,
      'status': status.toString(),
    };
  }
}
