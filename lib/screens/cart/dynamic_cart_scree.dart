
import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/screens/cart/checkout_bottom_sheet.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/widgets/item_count_for_cart.dart';
import 'package:grocery_app/widgets/item_counter_widget.dart';

class DynamicCartScreen extends StatefulWidget {
  const DynamicCartScreen({Key key}) : super(key: key);

  @override
  _DynamicCartScreenState createState() => _DynamicCartScreenState();
}

class _DynamicCartScreenState extends State<DynamicCartScreen> {

  List<ProductCartModel> getproductlistfromdb = [];
  int amount = 1;
  double TotalAmount =0;
  double tot =0.00;

  TextEditingController tot_amnt = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tot_amnt.text ="";
    getproductlistfromdbMethod();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body:   Container(

          padding: EdgeInsets.only(
            left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
            right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
            top: 25,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "My Cart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      getproductlistfromdb.length!=0? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildInquiryListItem(index);
                        },
                        shrinkWrap: true,
                        itemCount:  getproductlistfromdb.length,
                      ):Container(),

                    ],
                  ),
                ),
              ),
              Align(alignment : Alignment.bottomCenter,child: getCheckoutButton(context))


            ],

          ),
        )


    );
  }

  Widget _buildInquiryListItem(int index) {
    ProductCartModel productCartModel = getproductlistfromdb[index];

    print('QTY'+ productCartModel.Qty.toString());
    int ItemWiseQTY = 0;
    return Container(
     child: Column(
       children: [
         Align(
           alignment: Alignment.topRight,
           child: InkWell(
             onTap: (){
               _onTapOfDeleteContact(index);
             },
             child: Icon(
               Icons.delete,
               color: AppColors.darkGrey,
               size: 25,
             ),
           ),
         ),
         Row(
           //mainAxisAlignment: MainAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           /* mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.stretch,*/
           children: [
             imageWidget(productCartModel.imagePath),
             SizedBox(
               width: 20,

             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 AppText(
                   text: productCartModel.name,
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),
                 SizedBox(
                   height: 5,
                 ),
                 AppText(
                     text: productCartModel.description,
                     fontSize: 14,
                     fontWeight: FontWeight.bold,
                     color: AppColors.darkGrey),
                 SizedBox(
                   height: 12,
                 ),

                /* ItemCounterWidget(
                     onAmountChanged: (newAmount) {
                       setState(() {
                         amount = newAmount;
                         //ItemWiseQTY = newAmount;
                       });
                     }
                 )*/
                 ItemCounterWidgetForCart(
                     onAmountChanged: (newAmount) {
                     setState(() {

                       //tot_amnt.text = TotalAmount.toStringAsFixed(2);
                       productCartModel.Qty = newAmount;

                       //ItemWiseQTY = newAmount;
                     });
                   },
                   amount: productCartModel.Qty,
                 )
               ],
             ),


           ],
         ),
         Align(
           alignment: Alignment.bottomRight,
           child: Container(
             alignment: Alignment.bottomRight,
             width: 70,
             child: AppText(
               text: "\$${getPrice(productCartModel.price,  productCartModel.Qty).toStringAsFixed(2)}",
               fontSize: 18,
               fontWeight: FontWeight.bold,
               textAlign: TextAlign.right,
             ),
           ),
         ),
         Divider(
           thickness: 1,
         ),
       ],

     ),
   );
  }

  Future<void> _onTapOfDeleteContact(int index) async {
    await OfflineDbHelper.getInstance().deleteContact(getproductlistfromdb[index].id);
    setState(() {
      getproductlistfromdb.removeAt(index);
    });
  }

  Widget imageWidget(String imagePath) {
    return Container(
      width: 100,
      child: Image.asset(imagePath),
    );
  }

  double getPrice(double price, int itemWiseQTY) {
   // TotalAmount = TotalAmount + (price * itemWiseQTY);

   // TotalAmount +=  (price * itemWiseQTY);
  //  tot = tot +  productCartModel.price * newAmount;
      tot =  price * itemWiseQTY;

     // TotalAmount = TotalAmount - tot;
      double Tot1 =0.00;

      Tot1 += tot;
      TotalAmount += Tot1;

      print("GettTotal" + "Price : " + price.toStringAsFixed(2) +  " QTY : " + itemWiseQTY.toString() + " Total Amount : "+Tot1.toStringAsFixed(2));

      return price * itemWiseQTY;
  }

   getproductlistfromdbMethod() async {
   await getproductductdetails();

  }

  Future<void> getproductductdetails() async {

    getproductlistfromdb.clear();
    List<ProductCartModel> Tempgetproductlistfromdb = await OfflineDbHelper.getInstance().getProductCartList();
    getproductlistfromdb.addAll(Tempgetproductlistfromdb);
    for(int i=0;i<getproductlistfromdb.length;i++)
      {
        TotalAmount +=  (getproductlistfromdb[i].price * getproductlistfromdb[i].Qty);
      }
    setState(() {});
  }

  Widget getCheckoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: AppButton(
        label: "Go To Check Out",
        fontWeight: FontWeight.w600,
        padding: EdgeInsets.symmetric(vertical: 30),
        trailingWidget: getButtonPriceWidget(),
        onPressed: () {
          showBottomSheet(context);
        },
      ),
    );
  }

  Widget getButtonPriceWidget() {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Color(0xff489E67),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "\$"+TotalAmount.toStringAsFixed(2),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CheckoutBottomSheet();
        });
  }
}
