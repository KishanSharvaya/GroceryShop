import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

import '../order_failed_dialog.dart';

class CheckoutBottomSheet extends BaseStatefulWidget {
  static const routeName = '/CheckoutBottomSheet';

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}



class _CheckoutBottomSheetState extends  BaseState<CheckoutBottomSheet>
    with BasicScreen, WidgetsBindingObserver {
  double TotalAmount;
  List<ProductCartModel> placedOrderList=[];
  CategoryScreenBloc _categoryScreenBloc;

  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  int CustomerID = 0;
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TotalAmount = 0.00;
    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails= SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID;
    LoginUserID = _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    _categoryScreenBloc = CategoryScreenBloc(baseBloc);

    getproductlistfromdbMethod();
  }

  getproductlistfromdbMethod() async {
    await getproductductdetails();

  }


  Future<void> getproductductdetails() async {

    placedOrderList.clear();
    List<ProductCartModel> Tempgetproductlistfromdb = await OfflineDbHelper.getInstance().getProductCartList();
    placedOrderList.addAll(Tempgetproductlistfromdb);
    //getproductlistfromdb.addAll(Tempgetproductlistfromdb);
    for(int i=0;i<Tempgetproductlistfromdb.length;i++)
    {
      TotalAmount +=  (Tempgetproductlistfromdb[i].UnitPrice * Tempgetproductlistfromdb[i].Quantity);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {

          /*if(state is ProductCartResponseState)
            {


              _onCartListResponse(state,context);
            }*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {

          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {
          if(state is PlaceOrderSaveResponseState)
            {
              _onPlaceOrderSucessResponse(state,context);

            }
          if(state is CartDeleteResponseState)
            {
              _ondeleteCartFromAPIResponse(state);
            }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {

          if(currentState is PlaceOrderSaveResponseState || currentState is CartDeleteResponseState)
            {
              return true;
            }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: new Wrap(
        children: <Widget>[
          Row(
            children: [
              AppText(
                text: "Checkout",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 25,
                  ))
            ],
          ),
          SizedBox(
            height: 45,
          ),
          getDivider(),
          checkoutRow("Delivery", trailingText: "Select Method"),
          getDivider(),
          checkoutRow("Payment", trailingWidget: Icon(Icons.payment)),
          getDivider(),
          checkoutRow("Promo Code", trailingText: "Pick Discount"),
          getDivider(),
          checkoutRow("Total Cost", trailingText: "\$"+ TotalAmount.toStringAsFixed(2)),
          getDivider(),
          SizedBox(
            height: 30,
          ),
          termsAndConditionsAgreement(context),
          Container(
            margin: EdgeInsets.only(
              top: 25,
            ),
            child: AppButton(
              label: "Place Order",
              fontWeight: FontWeight.w600,
              padding: EdgeInsets.symmetric(
                vertical: 25,
              ),
              onPressed: () {

                onPlaceOrderClicked();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getDivider() {
    return Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget termsAndConditionsAgreement(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'By placing an order you agree to our',
          style: TextStyle(
            color: Color(0xFF7C7C7C),
            fontSize: 14,
            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
                text: " Terms",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(text: " And"),
            TextSpan(
                text: " Conditions",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ]),
    );
  }

  Widget checkoutRow(String label,
      {String trailingText, Widget trailingWidget}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        children: [
          AppText(
            text: label,
            fontSize: 18,
            color: Color(0xFF7C7C7C),
            fontWeight: FontWeight.w600,
          ),
          Spacer(),
          trailingText == null
              ? trailingWidget
              : AppText(
                  text: trailingText,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
          )
        ],
      ),
    );
  }

   onPlaceOrderClicked() {
     List<CartModel> arrCartAPIList=[];

     /* Navigator.pop(context);
    showDialog(context: context, child: OrderFailedDialogue());*/
     for(int i=0;i<placedOrderList.length;i++)
     {
       CartModel cartModel = CartModel();
       cartModel.ProductName=placedOrderList[i].ProductName;
       cartModel.ProductAlias=placedOrderList[i].ProductAlias;
       cartModel.ProductID=placedOrderList[i].ProductID;
       cartModel.CustomerID=placedOrderList[i].CustomerID;
       cartModel.Unit=placedOrderList[i].Unit;
       cartModel.UnitPrice=placedOrderList[i].UnitPrice;
       cartModel.Quantity=placedOrderList[i].Quantity.toDouble();
       cartModel.DiscountPercent=placedOrderList[i].DiscountPercent==null?0.00:placedOrderList[i].DiscountPercent;
       cartModel.LoginUserID=placedOrderList[i].LoginUserID;
       cartModel.CompanyId=placedOrderList[i].CompanyId;
       cartModel.ProductSpecification=placedOrderList[i].ProductSpecification;
       cartModel.ProductImage=placedOrderList[i].ProductImage;

       arrCartAPIList.add(cartModel);


     }
     _categoryScreenBloc.add(PlaceOrderSaveCallEvent(arrCartAPIList));



   }

  void _onPlaceOrderSucessResponse(PlaceOrderSaveResponseState state, BuildContext context) async {

    await OfflineDbHelper.getInstance().deleteContactTable();

    _categoryScreenBloc.add(CartDeleteRequestCallEvent(CustomerID,CartDeleteRequest(CompanyID: CompanyID)));


    commonalertbox(state.inquiryProductSaveResponse.details[0].column2,
        onTapofPositive: (){

          Navigator.pop(context);
          navigateTo(context, DashboardScreen.routeName,clearSingleStack: true);
        }
    );

  }

  Widget commonalertbox(String msg,{GestureTapCallback onTapofPositive,bool useRootNavigator = true}){
    showDialog(context: context, builder: (BuildContext ab){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10,

        actions: [
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green,width: 2.00),
            ),
            alignment: Alignment.center,
            child: Text("Alert!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            alignment: Alignment.center,
            //margin: EdgeInsets.only(left: 10),
            child: Text(msg,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 30,),
          Divider(
            height: 1.00,thickness: 2.00,

          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap:onTapofPositive ??(){
              Navigator.of(context,
                  rootNavigator: useRootNavigator
              ).pop();},
            child: Container(
              alignment: Alignment.center,
              child: Text("Ok",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      );
    });

  }

  void _ondeleteCartFromAPIResponse(CartDeleteResponseState state) {

    print("CartDeleteAPI"+ " DeleteResponse " + state.cartDeleteResponse.details[0].column1.toString());

  }

}
