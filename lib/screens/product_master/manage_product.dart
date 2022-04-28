
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';

import 'package:grocery_app/models/Model_for_dropdown/Model_for_list.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_list_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_save_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_master/product_pagination.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/image_full_screen.dart';
import 'package:image_picker/image_picker.dart';

class EditProduct{
  ProductPaginationDetails detail;
  EditProduct(this.detail);
}


class ManageProduct extends BaseStatefulWidget {
  static const routeName = '/ManageProduct';
  EditProduct edit;
  ManageProduct(this.edit);
  @override
  _ManageProductState createState() => _ManageProductState();

}
class _ManageProductState extends BaseState<ManageProduct>with BasicScreen,WidgetsBindingObserver {
  double height = 50;
  ProductGroupBloc productGroupBloc;
  int id=0;
  List<ALL_NAME_ID>PG=[];
  List<ALL_NAME_ID>PB=[];
  TextEditingController productgroup = TextEditingController();
  TextEditingController productgroupid = TextEditingController();
  TextEditingController productbrand = TextEditingController();
  TextEditingController productbrandid = TextEditingController();
  TextEditingController productname = TextEditingController();
  TextEditingController productalias = TextEditingController();
  TextEditingController unit = TextEditingController();

  TextEditingController unitprice = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController openingstock = TextEditingController();
  TextEditingController closingstock = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController productspec = TextEditingController();

  ProductPaginationDetails PD;
  File _selectedImageFile;
  String ImageURLFromListing = "";
  bool _isForUpdate=false;
  bool _isswitch=true;
  bool _isUpdate=false;

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
    _isUpdate = widget.edit!=null;
    if(_isUpdate){
          PD = widget.edit.detail;
      filldata();
    }else{}

  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) => productGroupBloc,
      child: BlocConsumer<ProductGroupBloc, ProductStates>(
        builder: (BuildContext context, ProductStates state) {

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {

          return false;
        },
        listener: (BuildContext context, ProductStates state) {
          if(state is ProductGroupResponseState)
          {
            _onproductgroupsuccess(state);
          }
          if(state is ProductBrandResponseState)
          {
            _onproductbrandsuccess(state);
          }
          if(state is ProductMasterSaveResponseState)
          {
            _onproductmastersave(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if(currentState is ProductGroupResponseState|| currentState is ProductBrandResponseState
          || currentState is ProductMasterSaveResponseState
          )
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
    return  Scaffold(

        appBar: AppBar(
          title: Container(
            child: Text("Manage Product",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
          top: true,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.only(left: 5,right: 5),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text(
                            "Product Name",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                )
                        ),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        color: colorLightGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: productname,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    //enabled: false,

                                    //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                    decoration: InputDecoration(
                                      hintText: "Enter Product Name",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text(
                            "Product Alias",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                )
                        ),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        color: colorLightGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: productalias,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    //enabled: false,

                                    //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                    decoration: InputDecoration(
                                      hintText: "Enter Product Alias",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text(
                            "Product Brand",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                )
                        ),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        color: colorLightGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: (){
                            productGroupBloc.add(ProductBrandCallEvent(ProductBrandListRequest(CompanyId:CompanyID ,LoginUserID: LoginUserID)));
                          },
                          child: Container(
                            height: height,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: productbrand,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      enabled: false,

                                      //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                      decoration: InputDecoration(
                                        hintText: "Select Product Brand",
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
                                Icon(Icons.arrow_drop_down),
                              ],

                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text(
                            "Product Group",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                /*fontWeight: FontWeight.bold*/)
                        ),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: (){
                       productGroupBloc.add(ProductGroupCallEvent(ProductGroupListRequest(CompanyId: CompanyID,LoginUserID: LoginUserID)));

                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                          elevation: 5,
                          color: colorLightGray,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            height: height,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: productgroup,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      enabled: false,

                                      //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                      decoration: InputDecoration(
                                        hintText: "Select Product Group",
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
                                Icon(Icons.arrow_drop_down),
                              ],

                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text(
                            "Product Specification",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            )
                        ),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        color: colorLightGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(left: 5,top: 5),
                                  child: TextField(
                                      controller: productspec,
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      //enabled: false,

                                      //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                      decoration: InputDecoration(
                                        hintText: "Enter Product Specification",
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 23),
                                child: Text(
                                    "Unit",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                    )
                                ),
                              ),
                            ), //heading
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10,),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  height: height,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: unit,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.text,
                                            //enabled: false,

                                            //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                            decoration: InputDecoration(
                                              hintText: "Enter Unit",
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],

                        )),
                        Expanded(
                            flex: 1,
                            child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                    "Unit Price",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                    )
                                ),
                              ),
                            ), //heading
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              margin: EdgeInsets.only( right: 10),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  height: height,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: unitprice,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            //enabled: false,

                                            //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                            decoration: InputDecoration(
                                              hintText: "0.00",
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ))
                      ],
                    ),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 23),
                        child: Text(
                            "Discount",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            )
                        ),
                      ),
                    ), //heading
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        elevation: 5,
                        color: colorLightGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          height: height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: discount,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    //enabled: false,

                                    //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                    decoration: InputDecoration(
                                      hintText: "Enter Discount %",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 23),
                                child: Text(
                                    "Opening Stock",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                    )
                                ),
                              ),
                            ), //heading
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10,),
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  height: height,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: openingstock,
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            //enabled: false,

                                            //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                            decoration: InputDecoration(
                                               hintText: "0",
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],

                        )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text(
                                        "Closing Stock",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.green,
                                        )
                                    ),
                                  ),
                                ), //heading
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  margin: EdgeInsets.only( right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Container(
                                      height: height,
                                      padding: EdgeInsets.only(left: 20, right: 20),
                                      width: double.maxFinite,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: closingstock,
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                //enabled: false,

                                                //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                                decoration: InputDecoration(
                                                  hintText: "0",
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                            ))
                      ],
                    ),

                    UploadImage(),
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                            "Product Status",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                            )
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                        left: 10
                      ),
                          child: Switch(value: _isswitch,
                              onChanged: switchchange,
                            activeColor: Colors.white,
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.red,
                            inactiveThumbColor: Colors.white,
                              ),
                    ),
                    _isswitch?activetext():inactivetext(),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        pickImage(context, onImageSelection: (file) {
                          _selectedImageFile = file;
                          baseBloc.refreshScreen();
                        });
                      },
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.only(left: 15,right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.green,
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text("\tAdd  Image  +",
                            style: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            )),
                      ),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                        onPressed: (){
                          _isswitch?status.text="1":status.text="0";
                         ontapofsave();
                        },
                        child: Text("Save Product",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        ),),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  }

  void _onproductgroupsuccess(ProductGroupResponseState state) {
    PG.clear();
    for(int i=0;i<state.response.details.length;i++){
      ALL_NAME_ID all_name_id = ALL_NAME_ID();
      all_name_id.Name = state.response.details[i].productGroupName;
      all_name_id.id = state.response.details[i].pkID.toString();
      PG.add(all_name_id);
    }
    showDialog(context: context, builder: (ctx)=>Container(
      //margin: EdgeInsets.only(left: 20,right: 20),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),

        ),
        elevation: 10.00,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green,width: 2.00),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text("Select ProductGroup",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
        children: [
          SizedBox(height: 5,),
          Container(
              margin: EdgeInsets.only(left: 3,right: 3),
              child: Divider(height: 1.00,thickness: 1.00,color: Colors.green,)),
          SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: PG.length,
                      itemBuilder: (abc,index){
                        return ListTile(
                          onTap: (){
                            Navigator.pop(context);
                            productgroup.text = PG[index].Name;
                            productgroupid.text = PG[index].id;
                            print(productgroupid.text);
                          },
                          title: Container(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  child: Text(PG[index].Name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,

                                    ),
                                  ))),
                          leading: Container(
                            margin: EdgeInsets.only(left: 10,top: 5),
                            child: Icon(Icons.circle,
                              size: 15,
                              color: Colors.green,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _onproductbrandsuccess(ProductBrandResponseState state) {
    PB.clear();
    for(int i=0;i<state.response.details.length;i++){
      ALL_NAME_ID all_name_id = ALL_NAME_ID();
      all_name_id.Name=state.response.details[i].brandName;
      all_name_id.id = state.response.details[i].pkID.toString();
      PB.add(all_name_id);
    }
    showDialog(context: context, builder: (ctx)=>Container(
      //margin: EdgeInsets.only(left: 20,right: 20),
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),

        ),
        elevation: 10.00,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green,width: 2.00),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text("Select ProductBrand",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
        children: [
          SizedBox(height: 5,),
          Container(
              margin: EdgeInsets.only(left: 3,right: 3),
              child: Divider(height: 1.00,thickness: 1.00,color: Colors.green,)),
          SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: PB.length,
                      itemBuilder: (abc,index){
                        return ListTile(
                          onTap: (){
                            Navigator.pop(context);
                            productbrand.text = PB[index].Name;
                            productbrandid.text = PB[index].id;
                            print(productbrandid.text);
                          },
                          title: Container(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  child: Text(PB[index].Name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,

                                    ),
                                  ))),
                          leading: Container(
                            margin: EdgeInsets.only(left: 10,top: 5),
                            child: Icon(Icons.circle,
                              size: 15,
                              color: Colors.green,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
  pickImage(
      BuildContext context, {
        @required Function(File f) onImageSelection,
      }) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(context: context, builder: (BuildContext abc){
      return SafeArea(
          child: Container(
            height: 150,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 8,left: 10),
                  child: Text("Choose Option",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    InkWell(
                      onTap:()async{
                        Navigator.of(context).pop();
                        PickedFile capturedFile =
                        await ImagePicker().getImage(
                            source: ImageSource.gallery,
                            imageQuality: 100);

                        if (capturedFile != null) {
                          onImageSelection(
                              File(capturedFile.path));
                        }
                      },
                      child: Image.asset("assets/images/gl.png",
                        height: 50,
                        width: 50,
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        Navigator.of(context).pop();
                        PickedFile capturedFile =
                        await ImagePicker().getImage(
                            source: ImageSource.camera,
                            imageQuality: 100);
                        if (capturedFile != null) {
                          onImageSelection(
                              File(capturedFile.path));
                        }
                      },
                      child: Image.asset("assets/images/camera.png",
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Gallary",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text("Camera",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ));
    });
  }
  Widget UploadImage(){
    return Column(
      children: [
        _selectedImageFile == null
            ? _isForUpdate //edit mode or not
            ? Container(
            margin: EdgeInsets.only(bottom: 20),
            child: ImageURLFromListing.isNotEmpty
                ? Column(
              mainAxisAlignment:MainAxisAlignment.start ,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),

                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    //color: colorGray,
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                  ),
                  child: ImageFullScreenWrapperWidget(
                    child: Image.network(ImageURLFromListing,
                      height: 125,
                      width: 125,
                    ),
                    dark: true,
                  ),),

                Align(
                    alignment: Alignment.topCenter,
                    child: Container(

                      // padding: const EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        //color: colorGray,
                        borderRadius: BorderRadius.all(Radius.circular(10)),

                      ),
/*
                                    margin: EdgeInsets.only(left: 180),
*/
                      child: GestureDetector(
                        onTap: (){
                         /* *//*showCommonDialogWithTwoOptions(
                              context, "Are you sure you want to delete this Image ?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                            _FollowupBloc.add(FollowupImageDeleteCallEvent(savepkID, FollowupImageDeleteRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID)));*//*
                          });*/
                        },
                        child: Icon(

                          Icons.delete_forever,
                          size: 32,
                          color: colorPrimary,
                        ),
                      ),
                    )),
              ],
            )
                : Container())
            : Container()
            : Container(
          margin: EdgeInsets.only(bottom: 20),
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageFullScreenWrapperWidget(
              child: Image.file(_selectedImageFile,
                height: 125,
                width: 125,
              ),
              dark: true,
            ),
          ),),

      ],
    );
  }

  switchchange(value) {
    if(_isswitch){
      setState(() {
        _isswitch = !_isswitch;

      });
    }else if(!_isswitch){
      setState(() {
        _isswitch = true;

      });
    }
  }
  Widget activetext(){
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20),
      child: Text("Active",
      style: TextStyle(
        fontSize: 15,
        color: Colors.green,
        fontWeight: FontWeight.bold
      ),
      ),
    );
  }
  Widget inactivetext(){
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20),
      child: Text("Inactive",
        style: TextStyle(
          fontSize: 15,
          color: Colors.red,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  void _onproductmastersave(ProductMasterSaveResponseState state) {
    commonalertbox(state.response.details[0].column2,
    onTapofPositive: (){
      Navigator.pop(context);
      navigateTo(context, ProductPagination.routeName,clearSingleStack: true);
    }
    );
  }

  void ontapofsave() {

    if(productname.text==""){
      commonalertbox("Fill Product Name.");
    }else if(productalias.text==""){
      commonalertbox("Fill Product Alias.");
    }else if(productbrand.text==""){
      commonalertbox("Select Product Brand.");
    }else if(productgroup.text==""){
      commonalertbox("Select Product Group.");
    }else if(unit.text==""){
      commonalertbox("Fill Unit.");
    }else if(unitprice.text==""){
      commonalertbox("Fill Discount.");
    }else if(openingstock.text==""){
      commonalertbox("Fill Opening Stock.");
    }else if(closingstock.text==""){
      commonalertbox("Fill Closing Stock.");
    }else{
      showCommonDialogWithTwoOptions(context, "Do You Want To Save This Details?",
          onTapOfPositiveButton: (){
        Navigator.pop(context);
        productGroupBloc.add(ProductMasterSaveCallEvent(id,ProductMasterSaveRequest(
          ProductName: productname.text,
          ProductAlias: productalias.text,
          Unit: unit.text,
          ProductSpecification: productspec.text,
          UnitPrice: double.parse(unitprice.text),
          DiscountPercent: double.parse(discount.text),
          OpeningSTK: double.parse(openingstock.text),
          ClosingSTK: double.parse(closingstock.text),
          BrandID: int.parse(productbrandid.text),
          ProductGroupID: int.parse(productgroupid.text),
          CompanyId: CompanyID,
          LoginUserID:LoginUserID,
          ActiveFlag: int.parse(status.text),
        )));
        
          },
      );
    }
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

  void filldata() {
    productname.text = PD.productName.toString();
    productalias.text = PD.productAlias.toString();
    productbrand.text = PD.brandName.toString();
    productgroup.text = PD.productGroupName.toString();
    productgroupid.text = PD.productGroupID.toString();
    productbrandid.text = PD.brandID.toString();
    productspec.text = PD.productSpecification.toString();
    unit.text = PD.unit.toString();
    unitprice.text = PD.unitPrice.toString();
    discount.text = PD.discountPercent.toString();
    openingstock.text = PD.openingSTK.toString();
    closingstock.text = PD.closingSTK.toString();
    id = PD.pkID;
    setState(() {
     if(PD.activeFlag==false){
       setState(() {
         _isswitch = false;
       });
     }else if (PD.activeFlag==true){
       setState(() {
         _isswitch = true;
       });
     }
    });

  }



}

