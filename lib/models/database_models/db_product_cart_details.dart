class ProductCartModel {
  int id;
   String name;
   String description;
   double price;
   int Qty;
   String Nutritions;
   String imagePath;

  ProductCartModel(this.name, this.description, this.price, this.Qty,this.Nutritions, this.imagePath,{this.id });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['Qty'] = this.Qty;
    data['Nutritions'] = this.Nutritions;
    data['imagePath'] = this.imagePath;
    return data;
  }


  @override
  String toString() {
    return 'ProductCartModel{id: $id, name: $name, description: $description, price: $price,Qty: $Qty, Nutritions: $Nutritions, imagePath: $imagePath}';
  }

}