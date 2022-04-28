import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_seach_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';

import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_search.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_brand/product_brand_add.dart';
import 'package:grocery_app/screens/product_brand/product_brand_search.dart';
import 'package:grocery_app/screens/product_master/manage_product.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class ProductBrandPagination extends BaseStatefulWidget {
  static const routeName = '/ProductBrandPagination';
  @override
  _ProductBrandPaginationState createState() => _ProductBrandPaginationState();

}

class _ProductBrandPaginationState extends BaseState<ProductBrandPagination> with BasicScreen,WidgetsBindingObserver{
  TextEditingController searchbar = TextEditingController();
  int title_color = 0xFF000000;
  int pageNo = 0;
  int selected = 0;
  int delid = 0;
  ProductBrandSearchDetails PSD;
  ProductGroupBloc productGroupBloc;
  ProductBrandResponse Response;
  ProductPaginationDetails details;


  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    super.initState();


    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails= SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID = _offlineLogindetails.details[0].customerName.replaceAll(' ', "");
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    productGroupBloc = ProductGroupBloc(baseBloc);
    productGroupBloc..add(ProductBrandCallEvent(
        ProductBrandListRequest(CompanyId: CompanyID,LoginUserID: LoginUserID)));
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      productGroupBloc..add(ProductBrandCallEvent(
          ProductBrandListRequest(CompanyId: CompanyID,LoginUserID: LoginUserID))),
      child: BlocConsumer<ProductGroupBloc, ProductStates>(
        builder: (BuildContext context, ProductStates state) {
          if (state is ProductBrandResponseState) {
            productbrandlistsuccess(state);
          }
          if(state is ProductBrandSearchResponseState){
            searchsuccess(state);
          }



          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ProductBrandResponseState||currentState is ProductBrandSearchResponseState
          ) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ProductStates state) {
          if (state is ProductBrandDeleteResponseState) {
            productbranddeletesuccess(state);
          }
          if(state is ProductBrandSearchResponseState){
            searchsuccess(state);
          }

          return super.build(context);

        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductBrandDeleteResponseState||currentState is ProductBrandSearchResponseState
          ) {
            return true;
          }
          return false;
        },
      ),);
  }
  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Product Brands",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Expanded(
              child:RefreshIndicator(
                onRefresh: ()async{
                  searchbar.clear();
                  productGroupBloc..add(ProductBrandCallEvent(
                      ProductBrandListRequest(CompanyId: CompanyID,LoginUserID: LoginUserID)));
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  child: Column(
                    children: [
                      buildsearch(),
                      SizedBox(height: 10,),
                      Expanded(child: _buildInquiryList()),
                    ],
                  ),

                ),),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,
          color: Colors.white,
        ),
        onPressed: (){
          navigateTo(context, ManageProductBrand.routeName);
        },
        backgroundColor: Colors.green,
      ),
    );
  }
  Widget buildsearch(){
    return InkWell(
         onTap: (){
           onsearchtap();
         },
      child: Container(
        margin: EdgeInsets.only(left: 15,right: 15,top: 15),
        child: Card(
          elevation: 5,
          color: colorLightGray,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      //controller: searchbar,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      enabled: false,

                      //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                      decoration: InputDecoration(
                        hintText: "Tap To Search",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
                ),
                Icon(Icons.search),
              ],

            ),

          ),
        ),
      ),
    );
  }

  Widget _buildInquiryList() {
    if (Response == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )
        ) {
          _onProductMasterPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),

        itemBuilder: (context, index) {
          return _buildCustomerList(index);
        },
        shrinkWrap: true,
        itemCount: Response.details.length,
      ),
    );
  }
  Widget _buildCustomerList(int index) {
    return ExpantionCustomer(context,index);
  }
  void _onProductMasterPagination() {
    productGroupBloc.add(ProductBrandCallEvent(
        ProductBrandListRequest(CompanyId: CompanyID,LoginUserID: LoginUserID)));
  }
  Widget ExpantionCustomer(BuildContext context, int index) {
    ProductBrandDetails PD = Response.details[index];
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: ExpansionTileCard(
              initialElevation: 5.0,
              elevation: 5.0,
              elevationCurve: Curves.easeInOut,
              shadowColor: Color(0xFF504F4F),
              baseColor: Color(0xFFFCFCFC),
              expandedColor: Color(0xFFC1E0FA),
              //Colors.deepOrange[50],ADD8E6


              title: Text(
                Response.details[index].brandName,
                style: TextStyle(color: Colors.black), //8A2CE2)),
              ),
              children: [
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Container(
                    margin: EdgeInsets.all(20),
                    child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(" Name:",
                                                    style: TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    Response.details[index].brandName == ""
                                                        ? "N/A"
                                                        :Response.details[index].brandName,
                                                    style: TextStyle(
                                                        color: colorDarkBlue,
                                                        fontSize: 13,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Brand:",
                                                    style: TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    Response.details[index].brandAlias == ""
                                                        ? "N/A"
                                                        :  Response.details[index].brandAlias ,
                                                    style: TextStyle(
                                                        color: colorDarkBlue,
                                                        fontSize: 13,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: 20,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ))),
                ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonHeight: 52.0,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        onPressed: () {
                          _onTapOfEditproduct(PD);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              color: colorDarkBlue,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(color: colorDarkBlue),
                            ),
                          ],
                        ),
                      ),

                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        onPressed: () {
                          _onTapOfDelete(Response.details[index].pkID);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: colorDarkBlue,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(color: colorDarkBlue),
                            ),
                          ],
                        ),
                      )


                    ]),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }




  /*void productdeletesuccess(ProductMasterDeleteResponseState state) {
    commonalertbox(state.response.details[0].column2,
        onTapofPositive: (){
          Navigator.pop(context);
          navigateTo(context, ProductPagination.routeName);
        }
    );
  }*/
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
            margin: EdgeInsets.only(left: 10),
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

  /*void _onTapOfDelete(productID) {
    showCommonDialogWithTwoOptions(context, "Do you want to Delete This Product?",
      onTapOfPositiveButton: (){
        Navigator.pop(context);
        productGroupBloc.add(ProductMasterDeleteCallEvent(productID,ProductPaginationDeleteRequest(CompanyId: 4094)));

      },
    );

  }*/

  /*void _onTapOfEditproduct(ProductPaginationDetails details) {
    navigateTo(context, ManageProduct.routeName,
        arguments:EditProduct(details)
    );
  }*/

  void productbrandlistsuccess(ProductBrandResponseState state) {
    Response = state.response;
  }

  void productbranddeletesuccess(ProductBrandDeleteResponseState state) {
    commonalertbox(state.response.details[0].column1,
    onTapofPositive: (){
      Navigator.pop(context);
      navigateTo(context, ProductBrandPagination.routeName);
    }
    );
  }

  void _onTapOfDelete(int pkID) {
    showCommonDialogWithTwoOptions(context, "Do You Want To Delete This Product Brand?",
    onTapOfPositiveButton: (){
      productGroupBloc.add(ProductBrandDeleteCallEvent(pkID,ProductBrandDeleteRequest(CompanyId: CompanyID)));
    }
    );

  }

 Future<void>onsearchtap() async{
    navigateTo(context, SearchProductBrandScreen.routeName).then((value) {
      if (value != null) {
        PSD = value;
        productGroupBloc.add(ProductBrandSearchCallEvent(
            ProductBrandSearchRequest(CompanyId: CompanyID, LoginUserID: LoginUserID,pkID:PSD.pkID)),
        );
      }


    }
      );

 }

  void searchsuccess(ProductBrandSearchResponseState state) {
    Response = state.response;
  }

  void _onTapOfEditproduct(ProductBrandDetails pd) {
    navigateTo(context, ManageProductBrand.routeName,
    arguments: EditProductBrand(pd),
    );
  }
}
/**/

/*buildsearch(),
          SizedBox(height: 10,),
          Expanded(child: _buildInquiryList()),*/