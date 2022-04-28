import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/bloc/others/category/category_bloc.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_list_request.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/category_item.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/screens/base/base_screen.dart';
import 'package:grocery_app/utils/general_utils.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'package:grocery_app/widgets/category_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';

import 'category_items_screen.dart';

List<Color> gridColors = [
  Color(0xff53B175),
  Color(0xffF8A44C),
  Color(0xffF7A593),
  Color(0xffD3B0E0),
  Color(0xffFDE598),
  Color(0xffB7DFF5),
  Color(0xff836AF6),
  Color(0xffD73B77),
];

/*class AddUpdateExploreScreenArguments {
  String BrandID;

  AddUpdateExploreScreenArguments(this.BrandID);
}*/

class ExploreScreen extends BaseStatefulWidget {

  static const routeName = '/ExploreScreen';
 /* final AddUpdateExploreScreenArguments arguments;
  ExploreScreen(this.arguments);*/


  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends BaseState<ExploreScreen>
    with BasicScreen, WidgetsBindingObserver {
  CategoryScreenBloc _categoryScreenBloc;
  String _ProductBrandID;
  List<CategoryItem> AllProducts = [];
  LoginResponse _offlineLogindetails;
  CompanyDetailsResponse _offlineCompanydetails;
  String CustomerID = "";
  String LoginUserID = "";
  String CompanyID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offlineLogindetails = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanydetails= SharedPrefHelper.instance.getCompanyData();
    CustomerID = _offlineLogindetails.details[0].customerID.toString();
    LoginUserID = _offlineLogindetails.details[0].customerName.trim().toString();
    CompanyID = _offlineCompanydetails.details[0].pkId.toString();

    _categoryScreenBloc = CategoryScreenBloc(baseBloc);


    _categoryScreenBloc..add(ProductGroupListRequestCallEvent(ProductGroupListRequest(LoginUserID: LoginUserID,SearchKey: "",CompanyId: CompanyID)));

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (BuildContext context) => _categoryScreenBloc,
      child: BlocConsumer<CategoryScreenBloc, CategoryScreenStates>(
        builder: (BuildContext context, CategoryScreenStates state) {
          if(state is ProductGroupListResponseState)
          {
            _onCategoryResponse(state,context);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if(currentState is ProductGroupListResponseState)
          {
            return true;

          }
          return false;
        },
        listener: (BuildContext context, CategoryScreenStates state) {

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {

          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          getHeader(),
          Expanded(
            child: getStaggeredGridView(context),
          ),
        ],
      ),
    ));
  }

  Widget getHeader() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Center(
          child: AppText(
            text: "Find Products",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        /*Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SearchBarWidget(),
        ),*/
      ],
    );
  }

  Widget getStaggeredGridView(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 4,
      children: AllProducts.asMap().entries.map<Widget>((e) {
        int index = e.key;
        CategoryItem categoryItem = e.value;
        return GestureDetector(
          onTap: () {
            onCategoryItemClicked(context, categoryItem);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: CategoryItemCardWidget(
              item: categoryItem,
              color: gridColors[index % gridColors.length],
            ),
          ),
        );
      }).toList(),

      //Here is the place that we are getting flexible/ dynamic card for various images
      staggeredTiles: AllProducts
          .map<StaggeredTile>((_) => StaggeredTile.fit(2))
          .toList(),
      mainAxisSpacing: 3.0,
      crossAxisSpacing: 4.0, // add some space
    );
  }

  void onCategoryItemClicked(BuildContext context, CategoryItem categoryItem) {
   /* Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) {
        return CategoryItemsScreen();
      },
    ));*/

    navigateTo(context, CategoryItemsScreen.routeName,
        arguments: AddUpdateCategoryItemsScreenArguments(categoryItem.id.toString()))
        .then((value) {

    });
  }

  void _onCategoryResponse(ProductGroupListResponseState state, BuildContext context) {

    AllProducts.clear();
    int tempID =0;
    for(int i=0;i <state.response.details.length;i++) {
      print("CategoryProduct" + state.response.details[i].productGroupName);


      CategoryItem groceryItem = CategoryItem();
      groceryItem.name = state.response.details[i].productGroupName;
      groceryItem.id = state.response.details[i].pkID;
     // groceryItem.imagePath = //state.response.details[i].productGroupImage;//"http://122.169.111.101:206/productimages/beverages.png";
      groceryItem.imagePath = state.response.details[i].productGroupImage==""?"https://img.icons8.com/bubbles/344/no-image.png":"http://122.169.111.101:206/"+state.response.details[i].productGroupImage;

      AllProducts.add(groceryItem);
    }
    AllProducts = AllProducts.toSet().toList();

  }
}
