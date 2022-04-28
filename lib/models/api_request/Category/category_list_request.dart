

class CategoryListRequest {
  String BrandID;
  String ProductGroupID;
  String ProductID;
  String CompanyId;

  CategoryListRequest({this.BrandID, this.ProductGroupID, this.ProductID,this.CompanyId});

  CategoryListRequest.fromJson(Map<String, dynamic> json) {
    BrandID = json['BrandID'];
    ProductGroupID = json['ProductGroupID'];
    ProductID = json['ProductID'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.BrandID;
    data['ProductGroupID'] = this.ProductGroupID;
    data['ProductID'] = this.ProductID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}

