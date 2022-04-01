import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/helpers/column_with_seprator.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

import 'account_item.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/AccountScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ListTile(
            leading:
            SizedBox(width: 65, height: 65, child: getImageHeader()),
            title: AppText(
              text: "Sharvaya InfoTech",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            subtitle: AppText(
              text: "info@sharvayainfotech.com",
              color: Color(0xff7C7C7C),
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),

          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: getChildrenWithSeperator(
                        widgets: accountItems.map((e) {
                          return getAccountItemWidget(e);
                        }).toList(),
                        seperator: Divider(
                          thickness: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    logoutButton(context),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),

        ],
      )
    );
  }

  Widget logoutButton(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 25),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  "assets/icons/account_icons/logout_icon.svg",
                  color: Colors.white,
                ),
              ),
              Text(
                "Log Out",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container()
            ],
          ),
          onPressed: () {
           /* Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) {
                return LoginScreen();

              },
            ));*/
            SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_LOGGED_IN_DATA,false);
            // Navigator.pushNamed(context, SignInScreen.routeName);

            navigateTo(context, LoginScreen.routeName,clearAllStack: true);

          },
        ),
      ),
    );
  }

  Widget getImageHeader() {
    String imagePath = "assets/images/sharvaya_logo.png";
    return CircleAvatar(
      radius: 5.0,
      backgroundImage: AssetImage(imagePath),
      backgroundColor: AppColors.primaryColor.withOpacity(0.7),
    );
  }

  Widget getAccountItemWidget(AccountItem accountItem) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              accountItem.iconPath,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            accountItem.label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
