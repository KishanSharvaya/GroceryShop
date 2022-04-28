import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/utils/common_widgets.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/widgets/item_counter_widget.dart';

class PlacedOrderDetailsScreen extends StatefulWidget {
  static const routeName = '/PlacedOrderDetailsScreen';

  final GroceryItem groceryItem;

  const PlacedOrderDetailsScreen(this.groceryItem);

  @override
  _PlacedOrderDetailsScreenState createState() =>
      _PlacedOrderDetailsScreenState();
}

class _PlacedOrderDetailsScreenState extends State<PlacedOrderDetailsScreen> {
  int amount = 1;
  FToast fToast;
  bool favorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            getImageHeaderWidget(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        widget.groceryItem.ProductName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      subtitle: AppText(
                        text: widget.groceryItem.ProductSpecification,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7C7C7C),
                      ),
                      /*trailing: /*FavoriteToggleIcon()*/InkWell(
                        onTap: () {




                        },
                        child: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite ? Colors.red : Colors.blueGrey,
                          size: 30,
                        ),
                      ),*/
                    ),
                    Spacer(),
                    Row(
                      children: [
                        /* ItemCounterWidget(
                          onAmountChanged: (newAmount) {
                            setState(() {
                              amount = newAmount;
                            });
                          },
                        ),*/
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.all(Radius.circular(20))

                          ),
                          child: Text(
                            "Quantity : " +
                                widget.groceryItem.Quantity.toInt().toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$${getTotalPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Product Details"),
                    Divider(thickness: 1),
                    getProductDataRowWidget("Nutritions",
                        customWidget: nutritionWidget()),
                    Divider(thickness: 1),
                    getProductDataRowWidget(
                      "Review",
                      customWidget: ratingWidget(),
                    ),
                    Spacer(),
                    AppButton(
                      label: "Exit",
                      onPressed: () {

                        Navigator.pop(context);
                        // isProductinCart==true?navigateTo(context,DynamicCartScreen.routeName,clearAllStack: true): _OnTaptoAddProductinCart();

                        /* Fluttertoast.showToast(
                              msg: "Item Added To Cart",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );*/
                        //
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageHeaderWidget() {
    return Container(
        height: 250,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF3366FF).withOpacity(0.1),
                const Color(0xFF3366FF).withOpacity(0.09),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: /*Image(
        image: AssetImage(widget.groceryItem.imagePath),
      ),*/
            Image.network(widget.groceryItem.ProductImage));
  }

  Widget getProductDataRowWidget(String label, {Widget customWidget}) {
    return InkWell(
      onTap: () {
        showCommonDialogWithSingleOption(
            context,
            "Product : " +
                widget.groceryItem.ProductName +
                "\n" +
                "Price : " +
                widget.groceryItem.UnitPrice.toString() +
                " Nutritions : " +
                widget.groceryItem.Unit,
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Row(
          children: [
            AppText(text: label, fontWeight: FontWeight.w600, fontSize: 16),
            Spacer(),
            if (customWidget != null) ...[
              customWidget,
              SizedBox(
                width: 20,
              )
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget nutritionWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xffEBEBEB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: AppText(
        text: widget.groceryItem.Unit,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xff7C7C7C),
      ),
    );
  }

  Widget ratingWidget() {
    Widget starIcon() {
      return Icon(
        Icons.star,
        color: Color(0xffF3603F),
        size: 20,
      );
    }

    return Row(
      children: [
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
      ],
    );
  }

  double getTotalPrice() {
    return amount * widget.groceryItem.UnitPrice;
  }

  _OnTaptoAddProductinCart() async {
    String name = widget.groceryItem.ProductName;
    String Alias = widget.groceryItem.ProductName;
    int ProductID = widget.groceryItem.ProductID;
    int CustomerID = widget.groceryItem.CustomerID;

    String Unit = widget.groceryItem.Unit;
    String description = widget.groceryItem.ProductSpecification;
    String ImagePath = widget.groceryItem.ProductImage;
    int Qty = amount;
    double Amount = widget.groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = widget.groceryItem.DiscountPer;
    String LoginUserID = widget.groceryItem.LoginUserID;
    String CompanyID = widget.groceryItem.ComapanyID;
    String ProductSpecification = widget.groceryItem.ProductSpecification;
    String ProductImage = widget.groceryItem.ProductImage;

    ProductCartModel productCartModel = new ProductCartModel(
        name,
        Alias,
        ProductID,
        CustomerID,
        Unit,
        Amount,
        Qty,
        DiscountPer,
        LoginUserID,
        CompanyID,
        ProductSpecification,
        ProductImage);

    await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);

    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Cart"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    navigateTo(context, DashboardScreen.routeName, clearAllStack: true);
  }

  _OnTaptoAddProductinCartFavorit() async {
    String name = widget.groceryItem.ProductName;
    String Alias = widget.groceryItem.ProductName;
    int ProductID = widget.groceryItem.ProductID;
    int CustomerID = widget.groceryItem.CustomerID;

    String Unit = widget.groceryItem.Unit;
    String description = widget.groceryItem.ProductSpecification;
    String ImagePath = widget.groceryItem.ProductImage;
    int Qty = amount;
    double Amount = widget.groceryItem.UnitPrice; //getTotalPrice();
    double DiscountPer = widget.groceryItem.DiscountPer;
    String LoginUserID = widget.groceryItem.LoginUserID;
    String CompanyID = widget.groceryItem.ComapanyID;
    String ProductSpecification = widget.groceryItem.ProductSpecification;
    String ProductImage = widget.groceryItem.ProductImage;

    ProductCartModel productCartModel = new ProductCartModel(
        name,
        Alias,
        ProductID,
        CustomerID,
        Unit,
        Amount,
        Qty,
        DiscountPer,
        LoginUserID,
        CompanyID,
        ProductSpecification,
        ProductImage);

    await OfflineDbHelper.getInstance()
        .insertProductToCartFavorit(productCartModel);

    fToast.showToast(
      child: showCustomToast(Title: "Item Added To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
    //navigateTo(context, DashboardScreen.routeName,clearAllStack: true);
  }

  Future<void> _onTapOfDeleteContact() async {
    await OfflineDbHelper.getInstance()
        .deleteContactFavorit(widget.groceryItem.ProductID);
    fToast.showToast(
      child: showCustomToast(Title: "Item Remove To Favorite"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void chekforProductExist() {}

  void getproductFavoritelistfromdbMethod() async {
    await getproductductfavoritedetails();
  }

  getproductductfavoritedetails() async {
    await OfflineDbHelper.getInstance().getProductCartFavoritList();
    List<ProductCartModel> groceryItemdb =
        await OfflineDbHelper.getInstance().getProductCartFavoritList();
    for (int i = 0; i < groceryItemdb.length; i++) {
      if (groceryItemdb[i].ProductID == widget.groceryItem.ProductID) {
        favorite = true;
        break;
      } else {
        favorite = false;
      }

      //print("FlagDeBIUG"+isProductinCart.toString() + " DBPRID " + groceryItemdb[i].ProductID.toString() + widget.groceryItem.ProductID.toString());

    }

    setState(() {});
  }
}
