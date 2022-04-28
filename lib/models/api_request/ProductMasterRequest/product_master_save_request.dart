
class ProductMasterSaveRequest {
  String ProductName;
  String ProductAlias;
  String Unit;
  String ProductImage;
  String ProductSpecification;
  double UnitPrice;
  double DiscountPercent;
  double OpeningSTK;
  double ClosingSTK;
  int BrandID;
  int ProductGroupID;
  String CompanyId;
  String LoginUserID;
  int ActiveFlag;



  ProductMasterSaveRequest(
      {this.ProductName,
      this.ProductAlias,
      this.Unit,
      this.ProductImage,
      this.ProductSpecification,
      this.UnitPrice,
      this.DiscountPercent,
      this.OpeningSTK,
      this.ClosingSTK,
      this.BrandID,
      this.ProductGroupID,
      this.CompanyId,
      this.LoginUserID,
      this.ActiveFlag,
      });

  ProductMasterSaveRequest.fromJson(Map<String, dynamic> json) {
    ProductName = json['ProductName'];
    ProductAlias = json['ProductAlias'];
    Unit = json['Unit'];
    ProductImage = json['ProductImage'];
    ProductSpecification = json['ProductSpecification'];
    UnitPrice = json['UnitPrice'];
    DiscountPercent = json['DiscountPercent'];
    OpeningSTK = json['OpeningSTK'];
    ClosingSTK = json['ClosingSTK'];
    BrandID = json['BrandID'];
    ProductGroupID = json['ProductGroupID'];
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    ActiveFlag = json['ActiveFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductName'] = this.ProductName;
    data['ProductAlias'] = this.ProductAlias;
    data['Unit'] = this.Unit;
    data['ProductImage'] = this.ProductImage;
    data['ProductSpecification'] = this.ProductSpecification;
    data['UnitPrice'] = this.UnitPrice;
    data['DiscountPercent'] = this.DiscountPercent;
    data['OpeningSTK'] = this.OpeningSTK;
    data['ClosingSTK'] = this.ClosingSTK;
    data['BrandID'] = this.BrandID;
    data['ProductGroupID'] = this.ProductGroupID;
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['ActiveFlag'] = this.ActiveFlag;
    return data;
  }
}
