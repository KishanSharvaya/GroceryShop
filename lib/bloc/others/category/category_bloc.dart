




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/bloc/base/base_bloc.dart';
import 'package:grocery_app/models/api_request/BestSelling/best_selling_list_request.dart';
import 'package:grocery_app/models/api_request/CartList/cart_save_list.dart';
import 'package:grocery_app/models/api_request/CartList/product_cart_list_request.dart';
import 'package:grocery_app/models/api_request/CartListDelete/cart_delete_request.dart';
import 'package:grocery_app/models/api_request/Category/category_list_request.dart';
import 'package:grocery_app/models/api_request/Exclusive_Offer/exclusive_offer_list_request.dart';
import 'package:grocery_app/models/api_request/ProductGroup/product_group_list_request.dart';
import 'package:grocery_app/models/api_response/BestSelling/best_selling_list_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_delete_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/cart_save_response.dart';
import 'package:grocery_app/models/api_response/CartResponse/product_cart_list_response.dart';
import 'package:grocery_app/models/api_response/Category/category_list_response.dart';
import 'package:grocery_app/models/api_response/Exclusive_Offer/exclusive_offer_list_response.dart';
import 'package:grocery_app/models/api_response/ProductGroup/product_group_list_response.dart';
import 'package:grocery_app/models/database_models/db_product_cart_details.dart';
import 'package:grocery_app/repository/repository.dart';


part 'category_events.dart';
part 'category_states.dart';

class CategoryScreenBloc extends Bloc<CategoryScreenEvents, CategoryScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  CategoryScreenBloc(this.baseBloc) : super(CategoryScreenInitialState());

  @override
  Stream<CategoryScreenStates> mapEventToState(CategoryScreenEvents event) async* {
    /// sets state based on events

    if (event is CategoryListRequestCallEvent) {
      yield* _mapLoginUserDetailsCallEventToState(event);
    }

    if(event is ProductGroupListRequestCallEvent)
      {
        yield* _mapProductGroupListEventToState(event);

      }

    if(event is ExclusiveOfferListRequestCallEvent)
      {
        yield*  _mapExclusiveOfferListEventToState(event);
      }

    if(event is BestSellingListRequestCallEvent)
    {
      yield*  _mapBestSellingListEventToState(event);
    }
    if(event is InquiryProductSaveCallEvent)
      {
        yield*  _mapInquiryProductSaveEventToState(event);

      }
    if(event is CartDeleteRequestCallEvent)
    {
      yield*  _mapCartDeleteRequestEventToState(event);
    }

    if(event is ProductCartDetailsRequestCallEvent)
      {
        yield* _mapProductCartDetailEventToState(event);
      }

    if(event is InquiryFavoriteProductSaveCallEvent)
      {
        yield* _mapInquiryFavoriteProductSaveEventToState(event);

      }

    if(event is FavoriteDeleteRequestCallEvent)
    {
      yield* _mapFavoriteDeleteRequestEventToState(event);

    }

    if(event is ProductFavoriteDetailsRequestCallEvent)
    {
      yield* _mapProductFavoriteDetailEventToState(event);

    }
    if(event is PlaceOrderSaveCallEvent)
    {
      yield* _mapPlaceOrderSaveEventToState(event);

    }

    if(event is PlacedOrderDetailsRequestCallEvent)
    {
      yield* _mapPlacedOrdertDetailEventToState(event);

    }




  }

  Stream<CategoryScreenStates> _mapLoginUserDetailsCallEventToState(
      CategoryListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CategoryListResponse loginResponse =
      await userRepository.categoryListAPI(event.categoryListRequest);
      yield CategoryListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapProductGroupListEventToState(
      ProductGroupListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductGroupListResponse loginResponse =
      await userRepository.productGroupListAPI(event.productGroupListRequest);
      yield ProductGroupListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapExclusiveOfferListEventToState(
      ExclusiveOfferListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ExclusiveOfferListResponse loginResponse =
      await userRepository.ExcluSiveListAPI(event.exclusiveOfferListRequest);
      yield ExclusiveOfferListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapBestSellingListEventToState(
      BestSellingListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      BestSellingListResponse loginResponse =
      await userRepository.BestSellingListAPI(event.bestSellingListRequest);
      yield BestSellingListResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState "+ "Msg : "+error.toString());

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapInquiryProductSaveEventToState(
      InquiryProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo = await userRepository
          .inquiryProductSaveDetails(event.inquiryProductModel);
      yield InquiryProductSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapInquiryFavoriteProductSaveEventToState(
      InquiryFavoriteProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo = await userRepository
          .inquiryFavoriteProductSaveDetails(event.inquiryProductModel);
      yield InquiryFavoriteProductSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapCartDeleteRequestEventToState(
      CartDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CartDeleteResponse loginResponse =
      await userRepository.CartDeleteAPI(event.CustomerID,event.cartDeleteRequest);
      yield CartDeleteResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState "+ "Msg : "+error.toString());

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapFavoriteDeleteRequestEventToState(
      FavoriteDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      CartDeleteResponse loginResponse =
      await userRepository.FavoriteDeleteAPI(event.CustomerID,event.cartDeleteRequest);
      yield FavoriteDeleteResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState "+ "Msg : "+error.toString());

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CategoryScreenStates> _mapProductCartDetailEventToState(
      ProductCartDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductCartListResponse loginResponse =
      await userRepository.ProductCartListAPI(event.productCartDetailsRequest);
      yield ProductCartResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState "+ "Msg : "+error.toString());

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapProductFavoriteDetailEventToState(
      ProductFavoriteDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductCartListResponse loginResponse =
      await userRepository.ProductFavoriteListAPI(event.productCartDetailsRequest);
      yield ProductFavoriteResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState "+ "Msg : "+error.toString());

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapPlaceOrderSaveEventToState(
      PlaceOrderSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo = await userRepository
          .placeOrderSaveDetails(event.inquiryProductModel);
      yield PlaceOrderSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }


  Stream<CategoryScreenStates> _mapPlacedOrdertDetailEventToState(
      PlacedOrderDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      ProductCartListResponse loginResponse =
      await userRepository.PlacedOrderListAPI(event.productCartDetailsRequest);
      yield PlacedOrderResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print("_mapBestSellingListEventToState "+ "Msg : "+error.toString());

    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

}