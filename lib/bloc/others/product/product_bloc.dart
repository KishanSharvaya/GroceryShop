
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_list_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_save_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_delete_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_master_save_request.dart';
import 'package:grocery_app/models/api_request/ProductMasterRequest/product_pagination_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_delete_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_save_request.dart';
import 'package:grocery_app/models/api_request/product_brand/product_brand_seach_request.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_delete_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_master_save_response.dart';
import 'package:grocery_app/models/api_response/ProductMasterResponse/product_pagination_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_delete_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_save_response.dart';
import 'package:grocery_app/models/api_response/product_brand/product_brand_search.dart';

import 'package:grocery_app/repository/repository.dart';
part 'product_event.dart';
part 'product_state.dart';
class ProductGroupBloc extends Bloc<ProductGroupEvents, ProductStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ProductGroupBloc(this.baseBloc) : super(ProductGroupInitialState());

  @override
  Stream<ProductStates> mapEventToState(ProductGroupEvents event) async* {
    /// sets state based on events

    if (event is ProductBrandCallEvent) {
      yield* _mapProductBrandCallEventToState(event);
    }
    if (event is ProductMasterSaveCallEvent) {
      yield* _mapProductMasterSaveCallEventToState(event);
    }
    if (event is ProductMasterPaginationCallEvent) {
      yield* _mapProductMasterPaginationCallEventToState(event);
    }
    if (event is ProductMasterPaginationSearchCallEvent) {
      yield* _mapProductMasterPaginationSearchCallEventToState(event);
    }
    if (event is ProductMasterDeleteCallEvent) {
      yield* _mapProductMasterDeleteCallEventToState(event);
    }
    if (event is ProductBrandSaveCallEvent) {
      yield* _mapProductBrandSaveCallEventToState(event);
    }
    if (event is ProductBrandDeleteCallEvent) {
      yield* _mapProductBrandDeleteCallEventToState(event);
    }
    if (event is ProductBrandSearchCallEvent) {
      yield* _mapProductBrandSearchCallEventToState(event);
    }
    if (event is ProductBrandSearchMainCallEvent) {
      yield* _mapProductBrandSearchMainCallEventToState(event);
    }

    if (event is ProductGroupSaveCallEvent) {
      yield* _mapProductGroupSaveCallEventToState(event);
    }
    if (event is ProductGroupDeleteCallEvent) {
      yield* _mapProductGroupDeleteCallEventToState(event);
    }
    if (event is ProductGroupCallEvent) {
      yield* _mapProductGroupCallEventToState(event);
    }
    if (event is ProductGroupSearchCallEvent) {
      yield* _mapProductGroupSearchCallEventToState(event);
    }
  }


  Stream<ProductStates> _mapProductBrandCallEventToState(
      ProductBrandCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandResponse response =
      await userRepository.productbrand(event.request);
      yield ProductBrandResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<ProductStates> _mapProductMasterSaveCallEventToState(
      ProductMasterSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductMasterSaveResponse response =
      await userRepository.productmastersave(event.id,/*event.imageFile,*/event.request);


      yield ProductMasterSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductMasterPaginationCallEventToState(
      ProductMasterPaginationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductPaginationResponse response =
      await userRepository.productmasterlist(event.pageno,event.request);
      yield ProductMasterPaginationResponseState(event.pageno,response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductMasterPaginationSearchCallEventToState(
      ProductMasterPaginationSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductPaginationResponse response =
      await userRepository.productmasterlist(event.pageno,event.request);
      yield ProductMasterPaginationResponseState(event.pageno,response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductMasterDeleteCallEventToState(
      ProductMasterDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductMasterDeleteResponse response =
      await userRepository.productmasterdelete(event.id,event.request);
      yield ProductMasterDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductBrandSaveCallEventToState(
      ProductBrandSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandSaveResponse response =
      await userRepository.productbrandsave(event.id,event.request);
      yield ProductBrandSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductBrandDeleteCallEventToState(
      ProductBrandDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandDeleteResponse response =
      await userRepository.productbranddelete(event.id,event.request);
      yield ProductBrandDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductBrandSearchCallEventToState(
      ProductBrandSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandResponse response =
      await userRepository.productbrandsearch(event.request);
      yield ProductBrandSearchResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductBrandSearchMainCallEventToState(
      ProductBrandSearchMainCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductBrandSearchResponse response =
      await userRepository.productbrandmainsearch(event.request);
      yield ProductBrandSearchMainResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductStates> _mapProductGroupDeleteCallEventToState(
      ProductGroupDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupDeleteResponse response =
      await userRepository.productgroupdelete(event.id,event.request);
      yield ProductGroupDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductGroupSaveCallEventToState(
      ProductGroupSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupSaveResponse response =
      await userRepository.productgroupsave(event.id,event.request);
      yield ProductGroupSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductGroupCallEventToState(
      ProductGroupCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupListResponse productGroupListResponse =
      await userRepository.productGroupListAPI(event.request);
      yield ProductGroupResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  Stream<ProductStates> _mapProductGroupSearchCallEventToState(
      ProductGroupSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupListResponse productGroupListResponse =
      await userRepository.productGroupListAPI(event.request);
      yield ProductGroupSearchResponseState(productGroupListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

}