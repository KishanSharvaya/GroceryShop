
class ProductBrandSaveRequest {
  String BrandName;
  String BrandAlias;
  String BrandImage;
  String CompanyId;
  String LoginUserID;
  int ActiveFlag;

/*BrandName:Test From API
BrandAlias:API
BrandImage:
ActiveFlag:1
LoginUserID:admin
CompanyId:4094*/

  ProductBrandSaveRequest(
      {this.BrandName,
        this.BrandAlias,
        this.BrandImage,
        this.CompanyId,
        this.LoginUserID,
        this.ActiveFlag,
      });

  ProductBrandSaveRequest.fromJson(Map<String, dynamic> json) {

    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    ActiveFlag = json['ActiveFlag'];
    BrandName = json['BrandName'];
    BrandAlias = json['BrandAlias'];
    BrandImage = json['BrandImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['ActiveFlag'] = this.ActiveFlag;
    data['BrandName'] = this.BrandName;
    data['BrandAlias'] = this.BrandAlias;
    data['BrandImage'] = this.BrandImage;

    return data;
  }
}
