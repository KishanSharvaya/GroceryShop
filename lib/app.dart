import 'package:flutter/material.dart';
import 'package:grocery_app/screens/AdminRegistration/admin_registration_screen.dart';
import 'package:grocery_app/screens/account/about_us_screen.dart';
import 'package:grocery_app/screens/account/account_screen.dart';
import 'package:grocery_app/screens/best_selling/best_selling_list_screen.dart';
import 'package:grocery_app/screens/cart/dynamic_cart_scree.dart';
import 'package:grocery_app/screens/category_items_screen.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/screens/exclusive_offer/exclusive_offer_list_screen.dart';
import 'package:grocery_app/screens/favorite/favorite_screen.dart';
import 'package:grocery_app/screens/filter_screen.dart';
import 'package:grocery_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:grocery_app/screens/home/grocery_featured_Item_widget.dart';
import 'package:grocery_app/screens/home/home_banner_widget.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/login/login_screen.dart';
import 'package:grocery_app/screens/order_failed_dialog.dart';
import 'package:grocery_app/screens/placed_order/place_order_product_list_screen.dart';
import 'package:grocery_app/screens/placed_order/placed_order_list_screen.dart';
import 'package:grocery_app/screens/product_brand/product_brand_add.dart';
import 'package:grocery_app/screens/product_brand/product_brand_list.dart';
import 'package:grocery_app/screens/product_brand/product_brand_search.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/screens/product_group/product_group_add.dart';
import 'package:grocery_app/screens/product_group/product_group_pagination.dart';
import 'package:grocery_app/screens/product_master/manage_product.dart';
import 'package:grocery_app/screens/product_master/product_pagination.dart';
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
      case DynamicCartScreen.routeName:
        return getMaterialPageRoute(DynamicCartScreen());

      case HomeBanner.routeName:
        return getMaterialPageRoute(HomeBanner());
      case CategoryItemsScreen.routeName:
        return getMaterialPageRoute(CategoryItemsScreen(settings.arguments));
      case ExclusiveOfferListScreen.routeName:
        return getMaterialPageRoute(ExclusiveOfferListScreen());


      case FilterScreen.routeName:
        return getMaterialPageRoute(FilterScreen());
      case BestSellingListScreen.routeName:
        return getMaterialPageRoute(BestSellingListScreen());

      case ManageProduct.routeName:
        return getMaterialPageRoute(ManageProduct(settings.arguments));
      case ProductPagination.routeName:
        return getMaterialPageRoute(ProductPagination());

      case AccountScreen.routeName:
        return getMaterialPageRoute(AccountScreen());
      case ForgotPasswordScreen.routeName:
        return getMaterialPageRoute(ForgotPasswordScreen());

      case ProductBrandPagination.routeName:
        return getMaterialPageRoute(ProductBrandPagination());
      case ManageProductBrand.routeName:
        return getMaterialPageRoute(ManageProductBrand(settings.arguments));
      case SearchProductBrandScreen.routeName:
        return getMaterialPageRoute(SearchProductBrandScreen());
      case FavoriteItemsScreen.routeName:
        return getMaterialPageRoute(FavoriteItemsScreen());
      case ProductDetailsScreen.routeName:
        return getMaterialPageRoute(ProductDetailsScreen(settings.arguments));
      case ProductGroupPagination.routeName:
        return getMaterialPageRoute(ProductGroupPagination());
      case ManageProductGroup.routeName:
        return getMaterialPageRoute(ManageProductGroup(settings.arguments));
      case AdminRegistrationScreen.routeName:
        return getMaterialPageRoute(AdminRegistrationScreen());
      case AboutUsDialogue.routeName:
        return getMaterialPageRoute(AboutUsDialogue());
      case PlacedOrderListScreen.routeName:
        return getMaterialPageRoute(PlacedOrderListScreen());
      case PlacedOrderDetailsScreen.routeName:
        return getMaterialPageRoute(PlacedOrderDetailsScreen(settings.arguments));




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
    /*if (SharedPrefHelper.instance.isLogIn()) {
      return DashboardScreen.routeName;
    } else if (SharedPrefHelper.IS_REGISTERED == "is_registered") {
      return WelcomeScreen.routeName;
    } else {
      return SplashScreen.routeName;
    }*/
    if (SharedPrefHelper.instance.isLogIn()) {
      return DashboardScreen.routeName;
    } else if (SharedPrefHelper.instance.isRegisteredIn()) {
      return LoginScreen.routeName;
    }

    return SplashScreen.routeName;

  }
}
