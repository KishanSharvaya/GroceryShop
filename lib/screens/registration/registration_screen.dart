
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/models/signup_details.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/ui/color_resource.dart';
import 'package:grocery_app/ui/dimen_resource.dart';
import 'package:grocery_app/ui/image_resource.dart';
import 'package:grocery_app/utils/rounded_progress_bar.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator; // or whatever name you want


class RegistrationScreen extends StatefulWidget {
  static const routeName = '/RegistrationScreen';

  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  double DEFAULT_SCREEN_LEFT_RIGHT_MARGIN = 30.0;

  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fetchaddresswithlocation = TextEditingController();

  String InvalidUserMessage = "";
  bool _isObscure = true;
  String SiteUrl="";
  ThemeData baseTheme;


  String Address = 'search';
  String Latitude;
  String Longitude;
  Position _currentPosition;
  Location location = new Location();

  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;
  bool isLoading = false;
  ProgressBarHandler _handler;



  @override
  Widget build(BuildContext context) {
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

    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) { _handler = handler;},
    );

    var scaffold =  Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
              top: 50,
              bottom: 50),
          child:  isLoading
              ? Center(
            child: CircularProgressIndicator(),
          ): Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTopView(),SizedBox(height: 50),_buildLoginForm(context)],
          ),
        ),
      ),
    );


    return Stack(
      children: <Widget>[
        scaffold,
        progressBar,
      ],
    );


  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /* Image.network("https://thumbs.dreamstime.com/b/avatar-supermarket-worker-cash-register-customer-car-full-groceries-colorful-design-vector-illustration-163995684.jpg",
          width: MediaQuery.of(context).size.width / 1.5,
          fit: BoxFit.fitWidth,),*/
        SizedBox(
          height: 5,
        ),
        /* Text(
          "Login",
          style: baseTheme.textTheme.headline1,
        ),*/
        Text(
          "Registration",
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
          "Register a new account",
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
        logoutButton(context),
        SizedBox(
          height: 25,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Email",
            hint: "enter email address",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icon(Icons.email_outlined),
            controller: _userEmailController),
        SizedBox(
          height: 25,
        ),
        getCommonTextFormField(context, baseTheme,
            title: "Username",
            hint: "enter username",
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icon(Icons.person),
            controller: _userNameController),
        SizedBox(
          height: 25,
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
          height: 35,
        ),
        Container(
         // margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Address",
              style: TextStyle(
                  color: colorPrimary,
                  fontSize: 18
              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 0),
          child: TextFormField(
            controller: _fetchaddresswithlocation,
            minLines: 5,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter Details',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide:
                  new BorderSide(color: colorPrimary),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder:     OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1,color: Colors.green),
                ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1,color: Colors.green),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1,color: Colors.green),
              ),

              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1,color: Colors.green)
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 1,color: Colors.green)
              ),
    ),
          ),
        ),
        /*getCommonTextFormField(context, baseTheme,
            title: "Re-Enter Password",
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
            controller: _re_enter_passwordController
        ),
        SizedBox(
          height: 35,
        ),*/
        SizedBox(
          height: 20,
        ),
        getButton(context),
        SizedBox(
          height: 20,
        ),
        _buildGoogleButtonView(),
        SizedBox(
          height: 20,
        ),


      ],
    );

  }

  Widget getButton(BuildContext context) {
    return AppButton(
      label: "Register",
      fontWeight: FontWeight.w600,
      padding: EdgeInsets.symmetric(vertical: 25),
      onPressed: () {

        /* TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fetchaddresswithlocation = TextEditingController();*/
        if(_userEmailController.text!="")
        {


          if(_userNameController.text!="")
            {
              if(_passwordController.text!="")
              {
                if(_fetchaddresswithlocation.text!="")
                {

                  SignUpDetails signupDetails = new SignUpDetails();
                  signupDetails.Email = _userEmailController.text;
                  signupDetails.UserName = _userNameController.text;

                  signupDetails.Password = _passwordController.text;
                  signupDetails.Address = _fetchaddresswithlocation.text;
                  SharedPrefHelper.instance.setSignUpData(signupDetails);
                  SharedPrefHelper.instance.putString(SharedPrefHelper.IS_REGISTERED,"is_registered");
                  navigateTo(context, LoginScreen.routeName,clearAllStack: true);

                }
                else
                {
                  showCommonDialogWithSingleOption(
                      context, "Address is required!",
                      positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                    Navigator.of(context).pop();
                  });
                }
              }
              else
              {
                showCommonDialogWithSingleOption(
                    context, "Password is required!",
                    positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                  Navigator.of(context).pop();
                });
              }
            }
          else
            {
              showCommonDialogWithSingleOption(
                  context, "UserName is required!",
                  positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                Navigator.of(context).pop();
              });
            }

        }
        else
        {
          showCommonDialogWithSingleOption(
              context, "Email address is required!",
              positiveButtonTitle: "OK",onTapOfPositiveButton: (){
            Navigator.of(context).pop();
          });
        }


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


  Widget logoutButton(BuildContext context) {
    return InkWell(
      onTap: (){
        _getCurrentLocation();

      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: RaisedButton(

          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Color(0xff7ac97a),
          textColor: Colors.white,
          elevation: 0.0,
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Icon(Icons.my_location,color: Colors.indigo,),
                width: 10,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Current Location",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),

            ],
          ),
          onPressed: () {
            _getCurrentLocation();

          },
        ),
      ),
    );
  }


  _getCurrentLocation()  {
    geolocator123.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best)
        .then((Position position) async {
      _currentPosition = position;
      Longitude = position.longitude.toString();
      Latitude = position.latitude.toString();
      Address = "";

      Address = await getAddressFromLatLng(Latitude,Longitude,"AIzaSyCVs8h5lia6ktiHnj2yzLYJOGtn0CQG48k");
      _handler.dismiss();

      _fetchaddresswithlocation.text = Address;

    }).catchError((e) {
      print(e);
    });

   /* location.onLocationChanged.listen((LocationData currentLocation) async {
      print("OnLocationChange" +
          " Location : " +
          currentLocation.latitude.toString());

      Latitude = currentLocation.latitude.toString();
      Longitude = currentLocation.longitude.toString();
      Address = await getAddressFromLatLng(Latitude,Longitude,"AIzaSyCVs8h5lia6ktiHnj2yzLYJOGtn0CQG48k");

    });*/

  }


  Future<String> getAddressFromLatLng(String lat, String lng, String skey) async {
    _handler.show();
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$skey&latlng=$lat,$lng';
    if(lat != "" && lng != "null"){
      var response = await http.get(Uri.parse(url));

      if(response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        //Address = _formattedAddress;
        print("response ==== $_formattedAddress");

        return _formattedAddress;
      } else return null;
    } else return null;
  }

}
