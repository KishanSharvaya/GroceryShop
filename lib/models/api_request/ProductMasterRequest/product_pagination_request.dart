class ProductPaginationRequest {
  String SearchKey;
  String CompanyId;


  ProductPaginationRequest({this.SearchKey,this.CompanyId});

  ProductPaginationRequest.fromJson(Map<String, dynamic> json) {
    SearchKey = json['SearchKey'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
