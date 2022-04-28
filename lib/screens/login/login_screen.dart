
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/bloc/others/firstscreen/first_screen_bloc.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/company_details_request.dart';
import 'package:grocery_app/models/api_request/login_user_details_api_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/login_user_details_api_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:grocery_app/screens/registration/registration_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/offline_db_helper.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class LoginScreen extends BaseStatefulWidget {
  static const routeName = '/LoginScreen';

 // const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState  extends BaseState<LoginScreen>
with BasicScreen, WidgetsBindingObserver {
  double DEFAULT_SCREEN_LEFT_RIGHT_MARGIN = 30.0;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String InvalidUserMessage = "";
  bool _isObscure = true;
  String SiteUrl="";
  ThemeData baseTheme;
  FirstScreenBloc _firstScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginResponse _offlineLoggedInDetailsData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firstScreenBloc = FirstScreenBloc(baseBloc);

    _firstScreenBloc
      ..add(CompanyDetailsCallEvent(
          CompanyDetailsApiRequest(serialKey: "BBBB-BBBB-BBBB-BBBB")));

  }

  @override
  Widget buildBody(BuildContext context) {
   //var theme =ThemeData(colorScheme: ColorScheme(secondary:Colors.green ),);

    baseTheme = /*Theme.of(context).copyWith(
        primaryColor: Colors.lightGreen,
        colorScheme: ThemeData.light().colorScheme.copyWith(
          secondary: Colors.green,
        ),
    );*/ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.red, // Your accent color
        ));
       // ColorScheme.fromSwatch().copyWith(primary: Colors.green,secondary: Colors.green));

    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              top: 50,
              bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTopView(), SizedBox(height: 40), _buildLoginForm(context)],
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _firstScreenBloc,
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {

          if (state is ComapnyDetailsEventResponseState) {
            _onCompanyDetailsCallSucess(state.companyDetailsResponse);
          }


          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if(currentState is ComapnyDetailsEventResponseState)
            {
              return true;
            }
          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          if (state is LoginResponseState) {
            _onLoginSucessResponse(state, context);
          }
          if (state is ProductFavoriteResponseState) {
            _onFavoriteProductList(state, context);
          }
          if (state is ProductCartResponseState) {
            _onCartProductList(state, context);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is LoginResponseState ||
              currentState is ProductFavoriteResponseState ||
              currentState is ProductCartResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Center(
           child: Image.asset(
            "assets/images/grocery_images/login_logo.png",
            width: 150,
            height: 200,
            fit: BoxFit.fitWidth,
        ),
         ),
       /* Image.network("https://thumbs.dreamstime.com/b/avatar-supermarket-worker-cash-register-customer-car-full-groceries-colorful-design-vector-illustration-163995684.jpg",
          width: MediaQuery.of(context).size.width / 1.5,
          fit: BoxFit.fitWidth,),*/
        SizedBox(
          height: 40,
        ),
        /* Text(
          "Login",
          style: baseTheme.textTheme.headline1,
        ),*/
        Text(
          "Login",
          style: TextStyle(
            color: Color(0xff53B175),
            fontSize: 48,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Log in to your existent account",
          style: TextStyle(
            color:Color(0xff5fb47e),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {

   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCommonTextFormField(context, baseTheme,
              title: "Email",
              hint: "enter email address",
              keyboardType: TextInputType.emailAddress,
              suffixIcon: Icon(Icons.person),
              controller: _userNameController),
          SizedBox(
            height: 20,
          ),
          getCommonTextFormField(context, baseTheme,
              title: "Password",
              hint: "enter password",
              obscureText: _isObscure,
              textInputAction: TextInputAction.done,
              suffixIcon:
              IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
              controller: _passwordController
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                _onTapOfForgetPassword();
              },
              child: Text(
                "Forget Password?",
                style: baseTheme.textTheme.headline2,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          getButton(context),
          SizedBox(
            height: 20,
          ),
         /* _buildGoogleButtonView(),
          SizedBox(
            height: 20,
          ),*/
          InkWell(
            onTap: (){
              navigateTo(context, RegistrationScreen.routeName,clearAllStack: true);

            },
            child: Container(

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Do You want to Visit Registration Page?",
                    style: baseTheme.textTheme.caption,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  InkWell(
                    onTap: () {
                     // _onTapOfRegister();

                      navigateTo(context, RegistrationScreen.routeName,clearAllStack: true);
                    },

                      child: Text(
                        "Tap here",
                        style: baseTheme.textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorPrimary,
                            fontStyle: FontStyle.italic),

                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );

  }

  Widget getButton(BuildContext context) {
    return AppButton(
      label: "Login",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 25),
      onPressed: () {
        //onGetStartedClicked(context);





        _firstScreenBloc.add(LoginRequestCallEvent(LoginRequest(
            EmailAddress: _userNameController.text.toString(),
            Password: _passwordController.text.toString(),
            CompanyId: _offlineCompanyData.details[0].pkId.toString())));



       /* if(_userNameController.text!="") {
          if(_passwordController.text!="") {
            if (SharedPrefHelper.IS_REGISTERED == "is_registered") {
              // addError(error: "Success");


              try{
                if (SharedPrefHelper.instance
                    .getSignUpData()
                    .UserName == _userNameController.text &&
                    SharedPrefHelper.instance
                        .getSignUpData()
                        .Password == _passwordController.text) {
                  SharedPrefHelper.instance.putBool(
                      SharedPrefHelper.IS_LOGGED_IN_DATA, true);
                  navigateTo(
                      context, DashboardScreen.routeName, clearAllStack: true);
                }
                else {
                  showCommonDialogWithSingleOption(
                      context, "Please Enter valid login Details",
                      positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                  });
                }

              }
              catch(E){
                showCommonDialogWithSingleOption(
                    context, "Please Enter valid login Details",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }



            }
            else {
              showCommonDialogWithSingleOption(
                  context, "Please Enter valid login Details",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }

          }
          else {
            showCommonDialogWithSingleOption(
                context, "Password is required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
          }


        }
        else {
          showCommonDialogWithSingleOption(
              context, "UserName is required !",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }*/

      },
    );
  }

  Widget _buildGoogleButtonView() {
    return Visibility(
      visible: false,
      child: Container(
        width: double.maxFinite,
        height: COMMON_BUTTON_HEIGHT,
        // ignore: deprecated_member_use
        child: RaisedButton(
          onPressed: () {
            //_onTapOfSignInWithGoogle();
          },
          color: colorRedLight,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(COMMON_BUTTON_RADIUS)),
          ),
          elevation: 0.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Image.asset(
                  IC_GOOGLE,
                  width: 30,
                  height: 30,
                ),

              SizedBox(
                width: 20,
              ),
              Text(
                "Sign in with Google",
                textAlign: TextAlign.center,
                style: baseTheme.textTheme.button,

              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginSucessResponse(LoginResponseState state, BuildContext context) {

    print("LoginSucess" + state.loginResponse.details[0].emailAddress);
    String EmpName = state.loginResponse.details[0].customerName;
    if(EmpName!="")
      {
        SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, true);
        SharedPrefHelper.instance.setLoginUserData(state.loginResponse);
        _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
        _offlineLoggedInDetailsData = SharedPrefHelper.instance.getLoginUserData();
       // print("LoginAuthenticateSucess123" + "CompanyID : " + _offlineCompanyData.details[0].pkId.toString() +"LoginUserID : "+_offlineLoggedInDetailsData.details[0].userID);

        _firstScreenBloc.add(ProductFavoriteDetailsRequestCallEvent(ProductCartDetailsRequest(CompanyId: _offlineCompanyData.details[0].pkId.toString(),CustomerID: state.loginResponse.details[0].customerID.toString())));


        // navigateTo(context, DashboardScreen.routeName, clearAllStack: true);

      }

  }

  void _onCompanyDetailsCallSucess(CompanyDetailsResponse companyDetailsResponse) {

    if(companyDetailsResponse.details.length!=0)
    {
      SharedPrefHelper.instance.setCompanyData(companyDetailsResponse);
      _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
      SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_REGISTERED, true);

      //navigateTo(context, FirstScreen.routeName, clearAllStack: true);

      print(
          "Company Details : " + companyDetailsResponse.details[0].companyName.toString() + "");
    }
  }

  void _onTapOfForgetPassword() {
    navigateTo(context, ForgotPasswordScreen.routeName,clearAllStack: true);

  }

  void _onFavoriteProductList(ProductFavoriteResponseState state, BuildContext context) async {
    await OfflineDbHelper.getInstance().deleteContactTableFavorit();

    for (int i = 0; i < state.cartDeleteResponse.details.length; i++)
    {
      String name = state.cartDeleteResponse.details[i].productName;
      String Alias = state.cartDeleteResponse.details[i].productName;
      int ProductID = state.cartDeleteResponse.details[i].productID;
      int CustomerID = state.cartDeleteResponse.details[i].customerID;

      String Unit = state.cartDeleteResponse.details[i].unit;
      int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
      double Amount = state.cartDeleteResponse.details[i]
          .unitPrice; //getTotalPrice();
      double DiscountPer = state.cartDeleteResponse.details[i]
          .discountPercent;

      String ProductSpecification = "";
      String ProductImage = "http://122.169.111.101:206/productimages/no-figure.png";

      ProductCartModel productCartModel = new ProductCartModel(
          name,
          Alias,
          ProductID,
          CustomerID,
          Unit,
          Amount,
          Qty,
          DiscountPer,
          _offlineLoggedInDetailsData.details[0].customerName.replaceAll(' ', ""),
          _offlineCompanyData.details[0].pkId.toString(),
          ProductSpecification,
          ProductImage
      );


      await OfflineDbHelper.getInstance().insertProductToCartFavorit(
          productCartModel);
    }


    _firstScreenBloc.add(ProductCartDetailsRequestCallEvent(ProductCartDetailsRequest(CompanyId: _offlineCompanyData.details[0].pkId.toString(),CustomerID: _offlineLoggedInDetailsData.details[0].customerID.toString())));


  }

  void _onCartProductList(ProductCartResponseState state, BuildContext context) async {

    await OfflineDbHelper.getInstance().deleteContactTable();
    for(int i=0;i<state.cartDeleteResponse.details.length;i++)
    {
      String name = state.cartDeleteResponse.details[i].productName;
      String Alias =state.cartDeleteResponse.details[i].productName;
      int ProductID=state.cartDeleteResponse.details[i].productID;
      int CustomerID = state.cartDeleteResponse.details[i].customerID;

      String Unit = state.cartDeleteResponse.details[i].unit;
      int Qty = state.cartDeleteResponse.details[i].quantity.toInt();
      double Amount =state.cartDeleteResponse.details[i].unitPrice;//getTotalPrice();
      double DiscountPer = state.cartDeleteResponse.details[i].discountPercent;

      String ProductSpecification = "";
      String ProductImage = "http://122.169.111.101:206/productimages/no-figure.png";

      ProductCartModel productCartModel = new ProductCartModel(name,Alias,ProductID,CustomerID,Unit,Amount,Qty,DiscountPer,_offlineLoggedInDetailsData.details[0].customerName.replaceAll(' ', ""),_offlineCompanyData.details[0].pkId.toString(),
          ProductSpecification,ProductImage
      );


      await OfflineDbHelper.getInstance().insertProductToCart(productCartModel);

    }

    navigateTo(context, DashboardScreen.routeName, clearAllStack: true);

  }


}
