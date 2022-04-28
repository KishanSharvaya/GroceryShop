class ProductGroupSaveRequest {
  String LoginUserID;
  String ProductGroupName;
  String CompanyId;
  String ActiveFlag;
  String ProductGroupImage;
/*ProductGroupName:Test From API
ActiveFlag:1
ProductGroupImage:
LoginUserID:admin
CompanyId:4094*/

  ProductGroupSaveRequest({this.LoginUserID, this.ActiveFlag,this.ProductGroupImage,this.ProductGroupName, this.CompanyId});

  ProductGroupSaveRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    ProductGroupName = json['ProductGroupName'];
    ActiveFlag = json['ActiveFlag'];
    ProductGroupImage = json['ProductGroupImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserID'] = this.LoginUserID;
    data['ProductGroupName'] = this.ProductGroupName;
    data['CompanyId'] = this.CompanyId;
    data['ActiveFlag'] = this.ActiveFlag;
    data['ProductGroupImage'] = this.ProductGroupImage;
    return data;
  }
}

