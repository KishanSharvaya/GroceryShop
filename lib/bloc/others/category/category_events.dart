part of 'category_bloc.dart';

@immutable
abstract class CategoryScreenEvents {}

///all events of AuthenticationEvents



class CategoryListRequestCallEvent extends CategoryScreenEvents {
  final CategoryListRequest categoryListRequest;

  CategoryListRequestCallEvent(this.categoryListRequest);
}


class ProductGroupListRequestCallEvent extends CategoryScreenEvents {
  final ProductGroupListRequest productGroupListRequest;

  ProductGroupListRequestCallEvent(this.productGroupListRequest);
}

class ExclusiveOfferListRequestCallEvent extends CategoryScreenEvents {
  final ExclusiveOfferListRequest exclusiveOfferListRequest;

  ExclusiveOfferListRequestCallEvent(this.exclusiveOfferListRequest);
}


class BestSellingListRequestCallEvent extends CategoryScreenEvents {
  final BestSellingListRequest bestSellingListRequest;

  BestSellingListRequestCallEvent(this.bestSellingListRequest);
}

class InquiryProductSaveCallEvent extends CategoryScreenEvents {
  final List<CartModel> inquiryProductModel;
  InquiryProductSaveCallEvent(this.inquiryProductModel);
}

class CartDeleteRequestCallEvent extends CategoryScreenEvents {
  final int CustomerID;
  final CartDeleteRequest cartDeleteRequest;
  CartDeleteRequestCallEvent(this.CustomerID,this.cartDeleteRequest);
}

class FavoriteDeleteRequestCallEvent extends CategoryScreenEvents {
  final int CustomerID;
  final CartDeleteRequest cartDeleteRequest;
  FavoriteDeleteRequestCallEvent(this.CustomerID,this.cartDeleteRequest);
}

class ProductCartDetailsRequestCallEvent extends CategoryScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  ProductCartDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class InquiryFavoriteProductSaveCallEvent extends CategoryScreenEvents {
  final List<CartModel> inquiryProductModel;
  InquiryFavoriteProductSaveCallEvent(this.inquiryProductModel);
}


class ProductFavoriteDetailsRequestCallEvent extends CategoryScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  ProductFavoriteDetailsRequestCallEvent(this.productCartDetailsRequest);
}

class PlaceOrderSaveCallEvent extends CategoryScreenEvents {
  final List<CartModel> inquiryProductModel;
  PlaceOrderSaveCallEvent(this.inquiryProductModel);
}


class PlacedOrderDetailsRequestCallEvent extends CategoryScreenEvents {
  final ProductCartDetailsRequest productCartDetailsRequest;

  PlacedOrderDetailsRequestCallEvent(this.productCartDetailsRequest);
}

/*
class placeOrderDeleteRequestCallEvent extends CategoryScreenEvents {
  final int CustomerID;
  final CartDeleteRequest cartDeleteRequest;
  CartDeleteRequestCallEvent(this.CustomerID,this.cartDeleteRequest);
}*/
