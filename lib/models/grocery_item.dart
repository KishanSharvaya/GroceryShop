class GroceryItem {
   String name;
   String description;
   double price;
   String Nutritions;
   String imagePath;

  GroceryItem({this.name, this.description, this.price, this.imagePath,this.Nutritions});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['Nutritions'] = this.Nutritions;
    data['imagePath'] = this.imagePath;
    return data;
  }

}

var demoItems = [
  GroceryItem(
      name: "Organic Bananas",
      description: "7pcs, Priceg",
      price: 4.99,
      Nutritions : "100gm",
      imagePath: "assets/images/grocery_images/banana.png"),
  GroceryItem(
      name: "Red Apple",
      description: "1kg, Priceg",
      price: 4.99,
      Nutritions : "10gm",
      imagePath: "assets/images/grocery_images/apple.png"),
  GroceryItem(
      name: "Bell Pepper Red",
      description: "1kg, Priceg",
      price: 4.99,
      Nutritions : "70gm",
      imagePath: "assets/images/grocery_images/pepper.png"),
  GroceryItem(
      name: "Ginger",
      description: "250gm, Priceg",
      price: 4.99,
      Nutritions : "40gm",
      imagePath: "assets/images/grocery_images/ginger.png"),
  GroceryItem(
      name: "Ginger",
      description: "250gm, Priceg",
      price: 4.99,
      Nutritions : "90gm",
      imagePath: "assets/images/grocery_images/beef.png"),
  GroceryItem(
      name: "Ginger",
      description: "250gm, Priceg",
      price: 4.99,
      Nutritions : "120gm",
      imagePath: "assets/images/grocery_images/chicken.png"),
];

var exclusiveOffers = [demoItems[0], demoItems[5]];

var bestSelling = [demoItems[2], demoItems[3]];

var groceries = [demoItems[4], demoItems[5]];

var beverages = [
  GroceryItem(
      name: "Dite Coke",
      description: "355ml, Price",
      price: 1.99,
      Nutritions : "120gm",
      imagePath: "assets/images/beverages_images/diet_coke.png"),
  GroceryItem(
      name: "Sprite Can",
      description: "325ml, Price",
      price: 1.50,
      Nutritions : "40gm",
      imagePath: "assets/images/beverages_images/sprite.png"),
  GroceryItem(
      name: "Apple Juice",
      description: "2L, Price",
      price: 15.99,
      Nutritions : "10gm",
      imagePath: "assets/images/beverages_images/apple_and_grape_juice.png"),
  GroceryItem(
      name: "Orange Juice",
      description: "2L, Price",
      price: 1.50,
      Nutritions : "125gm",
      imagePath: "assets/images/beverages_images/orange_juice.png"),
  GroceryItem(
      name: "Coca Cola Can",
      description: "325ml, Price",
      price: 4.99,
      Nutritions : "90gm",
      imagePath: "assets/images/beverages_images/coca_cola.png"),
  GroceryItem(
      name: "Pepsi Can",
      description: "330ml, Price",
      price: 4.99,
      Nutritions : "96gm",
      imagePath: "assets/images/beverages_images/pepsi.png"),
];
