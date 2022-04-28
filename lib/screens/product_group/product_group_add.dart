import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/others/product/product_bloc.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_save_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_list_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/product_group/product_group_pagination.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/image_full_screen.dart';
import 'package:image_picker/image_picker.dart';

class EditProductGroup{
  ProductGroupListResponseDetails detail;
  EditProductGroup(this.detail);
}


class ManageProductGroup extends BaseStatefulWidget {
  static const routeName = '/ManageProductGroup';
  EditProductGroup edit;
  ManageProductGroup(this.edit);
  @override
  _ManageProductGroupState createState() => _ManageProductGroupState();

}
class _ManageProductGroupState extends BaseState<ManageProductGroup>with BasicScreen,WidgetsBindingObserver {
  double height = 50;
  ProductGroupBloc productGroupBloc;
  int id=0;
  TextEditingController groupname = TextEditingController();
  ProductGroupListResponseDetails PG;
  File _selectedImageFile;
  String ImageURLFromListing = "";
  bool _isForUpdate=false;
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
    _isForUpdate = widget.edit!=null;
    if(_isForUpdate){
      PG = widget.edit.detail;
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
          if(state is ProductGroupSaveResponseState)
          {
            _onproductgroupsavesuccess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if(currentState is ProductGroupSaveResponseState)
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
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text("Manage Product Group",
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
                          "Product Group Name",
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
                                  controller: groupname,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  //enabled: false,

                                  //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                                  decoration: InputDecoration(
                                    hintText: "Enter Product Group",
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
                  UploadImage(),
                  SizedBox(height: 10,),
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
                    child: Image.network(ImageURLFromListing==""?ImageURLFromListing:"https://img.icons8.com/bubbles/344/no-image.png",
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



  void ontapofsave() {

    if(groupname.text==""){
      commonalertbox("Fill Product Group Name.");
    }else{
      showCommonDialogWithTwoOptions(context, "Do You Want To Save This Details?",
        onTapOfPositiveButton: (){
          Navigator.pop(context);
          productGroupBloc.add(ProductGroupSaveCallEvent(id,ProductGroupSaveRequest(
            CompanyId: CompanyID,
            LoginUserID:LoginUserID,
            ProductGroupName: groupname.text.toString(),
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
    groupname.text = PG.productGroupName.toString();
    id = PG.pkID;
  }
  void _onproductgroupsavesuccess(ProductGroupSaveResponseState state) {
    print("ruchit");
    commonalertbox(state.response.details[0].column2,
        onTapofPositive: (){
          Navigator.pop(context);
          navigateTo(context, ProductGroupPagination.routeName,clearSingleStack: true);
        }
    );
  }


}

