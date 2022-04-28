part of 'category_bloc.dart';

abstract class CategoryScreenStates extends BaseStates {
  const CategoryScreenStates();
}

///all states of AuthenticationStates

class CategoryScreenInitialState extends CategoryScreenStates {}


class CategoryListResponseState extends CategoryScreenStates {
  CategoryListResponse response;

  CategoryListResponseState(this.response);
}



class ProductGroupListResponseState extends CategoryScreenStates {
  ProductGroupListResponse response;

  ProductGroupListResponseState(this.response);
}
class ExclusiveOfferListResponseState extends CategoryScreenStates {
  ExclusiveOfferListResponse response;

  ExclusiveOfferListResponseState(this.response);
}

class BestSellingListResponseState extends CategoryScreenStates {
  BestSellingListResponse response;

  BestSellingListResponseState(this.response);
}

class InquiryProductSaveResponseState extends CategoryScreenStates{
  final InquiryProductSaveResponse inquiryProductSaveResponse;
  InquiryProductSaveResponseState(this.inquiryProductSaveResponse);
}

class CartDeleteResponseState extends CategoryScreenStates{
  final CartDeleteResponse cartDeleteResponse;
  CartDeleteResponseState(this.cartDeleteResponse);
}
class ProductCartResponseState extends CategoryScreenStates{
  final ProductCartListResponse cartDeleteResponse;
  ProductCartResponseState(this.cartDeleteResponse);
}

class InquiryFavoriteProductSaveResponseState extends CategoryScreenStates{
  final InquiryProductSaveResponse inquiryProductSaveResponse;
  InquiryFavoriteProductSaveResponseState(this.inquiryProductSaveResponse);
}
class FavoriteDeleteResponseState extends CategoryScreenStates{
  final CartDeleteResponse cartDeleteResponse;
  FavoriteDeleteResponseState(this.cartDeleteResponse);
}

class ProductFavoriteResponseState extends CategoryScreenStates{
  final ProductCartListResponse cartDeleteResponse;
  ProductFavoriteResponseState(this.cartDeleteResponse);
}


class PlaceOrderSaveResponseState extends CategoryScreenStates{
  final InquiryProductSaveResponse inquiryProductSaveResponse;
  PlaceOrderSaveResponseState(this.inquiryProductSaveResponse);
}


class PlacedOrderResponseState extends CategoryScreenStates{
  final ProductCartListResponse cartDeleteResponse;
  PlacedOrderResponseState(this.cartDeleteResponse);
}
