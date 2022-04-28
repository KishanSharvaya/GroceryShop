import 'package:grocery_app/models/api_request/BestSelling/best_selling_list_request.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_forgot_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_login_request.dart';
import 'package:grocery_app/models/api_request/Customer/customer_registration_request.dart';
import 'package:grocery_app/models/api_request/Exclusive_Offer/exclusive_offer_list_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_list_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_save_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_save_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_pagination_request.dart';
import 'package:grocery_app/models/api_request/company_details_request.dart';
import 'package:grocery_app/models/api_request/login_user_details_api_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_save_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_seach_request.dart';
import 'package:grocery_app/models/api_response/BestSelling/best_selling_list_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_delete_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_save_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/product_cart_list_response.dart';
import 'package:grocery_app/models/api_response/Category/category_list_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_forgot_respons.dart';
import 'package:grocery_app/models/api_response/Customer/customer_login_response.dart';
import 'package:grocery_app/models/api_response/Customer/customer_registration_response.dart';
import 'package:grocery_app/models/api_response/Exclusive_Offer/exclusive_offer_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_master_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/company_details_response.dart';
import 'package:grocery_app/models/api_response/login_user_details_api_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_save_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_search.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/repository/api_client.dart';
import 'package:grocery_app/utils/shared_pref_helper.dart';
import 'dart:developer' as developer;

import 'api_client.dart';
import 'error_response_exception.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path/path.dart';


class Repository {
  SharedPrefHelper prefs = SharedPrefHelper.instance;
  final ApiClient apiClient;

  Repository({@required this.apiClient});

  static Repository getInstance() {
    return Repository(apiClient: ApiClient(httpClient: http.Client()));
  }

  ///add your functions of api calls as below


/*  Future<CompanyDetailsResponse> CompanyDetailsCallApi(CompanyDetailsApiRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      CompanyDetailsResponse companyDetailsResponse =
      CompanyDetailsResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }*/

  ///Login USer APi Details as below
  Future<LoginUserDetialsResponse> loginUserDetailsCall(
      LoginUserDetialsAPIRequest loginUserDetialsAPIRequest) async {
    try {
      /*  String jsonString = await apiClient.apiCallLoginUSerPost(
          *//*ApiClient.END_POINT_LOGIN_USER_DETAILS*//*
          "Login/" + loginUserDetialsAPIRequest.companyId.toString(),
          loginUserDetialsAPIRequest.toJson());
      print("json - $jsonString");
      List<dynamic> list = json.decode(jsonString);*/
      //return LoginUserDetials.fromJson(list[0]);

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN_USER_DETAILS+"/"+loginUserDetialsAPIRequest.companyId.toString(), loginUserDetialsAPIRequest.toJson());
      LoginUserDetialsResponse loginUserDetialsResponse =
      LoginUserDetialsResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CompanyDetailsResponse> CompanyDetailsCallApi(CompanyDetailsApiRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      CompanyDetailsResponse companyDetailsResponse =
      CompanyDetailsResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerRegistrationResponse> CustomerRegistrationAPI(int pkID,CustomerRegistrationRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_CUSTOMER_REGISTRATION+pkID.toString()+"/Save", companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      CustomerRegistrationResponse companyDetailsResponse =
      CustomerRegistrationResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CategoryListResponse> categoryListAPI(
      CategoryListRequest loginUserDetialsAPIRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CATEGORY_DETAILS, loginUserDetialsAPIRequest.toJson());
      CategoryListResponse loginUserDetialsResponse =
      CategoryListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }





  Future<ExclusiveOfferListResponse> ExcluSiveListAPI(
      ExclusiveOfferListRequest loginUserDetialsAPIRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXCLUSIVE_OFFER_DETAILS, loginUserDetialsAPIRequest.toJson());
      ExclusiveOfferListResponse loginUserDetialsResponse =
      ExclusiveOfferListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BestSellingListResponse> BestSellingListAPI(
      BestSellingListRequest bestSellingListRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BEST_SELLING_DETAILS, bestSellingListRequest.toJson());
      BestSellingListResponse loginUserDetialsResponse =
      BestSellingListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSaveResponse> inquiryProductSaveDetails(List<CartModel> inquiryProductModel) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPostforMultipleJSONArray(
          ApiClient.END_POINT_INQUIRY_PRODUCT_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
      InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSaveResponse> placeOrderSaveDetails(List<CartModel> inquiryProductModel) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPostforMultipleJSONArray(
          ApiClient.END_POINT_PLACEORDER_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
      InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSaveResponse> inquiryFavoriteProductSaveDetails(List<CartModel> inquiryProductModel) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPostforMultipleJSONArray(
          ApiClient.END_POINT_FAVORITE_PRODUCT_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
      InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CartDeleteResponse> CartDeleteAPI(int CustomerID,
      CartDeleteRequest loginUserDetialsAPIRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CART_DELETE+CustomerID.toString()+"/Del", loginUserDetialsAPIRequest.toJson());
      CartDeleteResponse loginUserDetialsResponse =
      CartDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CartDeleteResponse> FavoriteDeleteAPI(int CustomerID,
      CartDeleteRequest loginUserDetialsAPIRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FAVORITE_DELETE+CustomerID.toString()+"/Del", loginUserDetialsAPIRequest.toJson());
      CartDeleteResponse loginUserDetialsResponse =
      CartDeleteResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductCartListResponse> ProductCartListAPI(
      ProductCartDetailsRequest productCartDetailsRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CART_LIST, productCartDetailsRequest.toJson());
      ProductCartListResponse loginUserDetialsResponse =
      ProductCartListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductCartListResponse> PlacedOrderListAPI(
      ProductCartDetailsRequest productCartDetailsRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PLACED_ORDER_LIST, productCartDetailsRequest.toJson());
      ProductCartListResponse loginUserDetialsResponse =
      ProductCartListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductCartListResponse> ProductFavoriteListAPI(
      ProductCartDetailsRequest productCartDetailsRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FAVORITE_LIST, productCartDetailsRequest.toJson());
      ProductCartListResponse loginUserDetialsResponse =
      ProductCartListResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }


  Future<ProductMasterSaveResponse> productmastersave(int id,/*File imageFile,*/
      ProductMasterSaveRequest productMasterSaveRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Master_Save}/$id/Save', productMasterSaveRequest.toJson());

    /*  await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_Product_Master_Save,productMasterSaveRequest.toJson(),imageFilesToUpload: [imageFile]);*/

      ProductMasterSaveResponse response =
      ProductMasterSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductPaginationResponse> productmasterlist(int pageno,
      ProductPaginationRequest paginationRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Master_Pagination}/$pageno-11', paginationRequest.toJson());
      ProductPaginationResponse response =
      ProductPaginationResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }
  Future<ProductMasterDeleteResponse> productmasterdelete(int id,
      ProductPaginationDeleteRequest paginationDeleteRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Master_Delete}/$id/Del', paginationDeleteRequest.toJson());
      ProductMasterDeleteResponse response =
      ProductMasterDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandResponse> productbrand(
      ProductBrandListRequest productBrandListRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_Brand, productBrandListRequest.toJson());
      ProductBrandResponse response =
      ProductBrandResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }


  Future<ForgotResponse> ForgotAPI(ForgotRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_FORGOTDETAILS, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      ForgotResponse companyDetailsResponse =
      ForgotResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> LoginAPI(LoginRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_LOGINDETAILS, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      LoginResponse companyDetailsResponse =
      LoginResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandSaveResponse> productbrandsave(int id,
      ProductBrandSaveRequest productBrandSaveRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Brand_save}/$id/Save', productBrandSaveRequest.toJson());
      ProductBrandSaveResponse response =
      ProductBrandSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandDeleteResponse> productbranddelete(int id,
      ProductBrandDeleteRequest productBrandDeleteRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Brand_delete}/$id/Delete', productBrandDeleteRequest.toJson());
      ProductBrandDeleteResponse response =
      ProductBrandDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }
  Future<ProductBrandResponse> productbrandsearch(
      ProductBrandSearchRequest productBrandSearchRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_Brand_search, productBrandSearchRequest.toJson());
      ProductBrandResponse response =
      ProductBrandResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }
  Future<ProductBrandSearchResponse> productbrandmainsearch(
      ProductBrandSearchRequest productBrandSearchRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_Brand_search, productBrandSearchRequest.toJson());
      ProductBrandSearchResponse response =
      ProductBrandSearchResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }


  Future<ProductGroupDeleteResponse> productgroupdelete(int id,
      ProductGroupDeleteRequest productGroupDeleteRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Group_Delete}/$id/Del', productGroupDeleteRequest.toJson());
      ProductGroupDeleteResponse response =
      ProductGroupDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupSaveResponse> productgroupsave(int id,
      ProductGroupSaveRequest productGroupSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          '${ApiClient.END_POINT_Product_Group}/$id/Save', productGroupSaveRequest.toJson());
      ProductGroupSaveResponse response =
      ProductGroupSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupListResponse> productGroupListAPI(
      ProductGroupListRequest productGroupListRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCTGROUP_DETAILS, productGroupListRequest.toJson());
      ProductGroupListResponse productGroupListResponse =
      ProductGroupListResponse.fromJson(json);
      return productGroupListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }


}
