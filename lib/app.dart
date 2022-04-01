import 'package:flutter/material.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/screens/home/grocery_featured_Item_widget.dart';
import 'package:grocery_app/screens/home/home_banner_widget.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/registration/registration_screen.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/styles/theme.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';

class MyApp extends StatelessWidget {
  static MaterialPageRoute globalGenerateRoute(RouteSettings settings) {
    //if screen have no argument to pass data in next screen while transiting
    // final GlobalKey<ScaffoldState> key = settings.arguments;

    switch (settings.name) {
      case WelcomeScreen.routeName:
        return getMaterialPageRoute(WelcomeScreen());
      case SplashScreen.routeName:
        return getMaterialPageRoute(SplashScreen());
      case LoginScreen.routeName:
        return getMaterialPageRoute(LoginScreen());
      case RegistrationScreen.routeName:
        return getMaterialPageRoute(RegistrationScreen());
      case HomeScreen.routeName:
        return getMaterialPageRoute(HomeScreen());
      case DashboardScreen.routeName:
        return getMaterialPageRoute(DashboardScreen());
      case GroceryFeaturedCard.routeName:
        return getMaterialPageRoute(GroceryFeaturedCard(settings.arguments));

      case HomeBanner.routeName:
        return getMaterialPageRoute(HomeBanner());
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: MyApp.globalGenerateRoute,
        theme: themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: getInitialRoute()

/*
    home: SplashScreen(),
*/

        );
  }

  getInitialRoute() {
    if (SharedPrefHelper.instance.isLogIn()) {
      return DashboardScreen.routeName;
    } else if (SharedPrefHelper.IS_REGISTERED == "is_registered") {
      return WelcomeScreen.routeName;
    } else {
      return SplashScreen.routeName;
    }
  }
}
