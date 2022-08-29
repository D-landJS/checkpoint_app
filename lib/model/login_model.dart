// LoginResponseModel loginResponseFromJson(String str) =>
//     LoginResponseModel.fromJson(jsonDecode(str));

// class LoginResponseModel {
//   bool? success;
//   int? statusCode;

//   String? message;
//   Data? data;

//   LoginResponseModel({this.success, this.statusCode, this.data});

//   LoginResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     success = json['statusCode'];

//     success = json['message'];
//     data = json['data'].length > 0 ? Data.fromJson(json['data']) : null;
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     data['statusCode'] = statusCode;

//     data['message'] = message;
//     data['data'] = this.data?.toJson();
//     return data;
//   }
// }

/* class Data {
  String? username;
  String? description;
  String? accountName;
  String? accountDescription;

  Data(
      {this.username,
      this.description,
      this.accountName,
      this.accountDescription});

  Data.fromJson(Map<String, dynamic> json) {
    username = json["username"];
    description = json["description"];
    accountName = json["accountName"];
    accountDescription = json["accountDescription"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['description'] = description;
    data['accountName'] = accountName;
    data['accountDescription'] = accountDescription;
    return data;
  } 
}*/

class User {
  String? userName;
  String? description;
  String? accountName;
  String? accountDescription;
// constructorUser(
  User(
      {this.userName,
      required String? description,
      required String? accountName,
      required String? accountDescription});
  // create the user object from json input
  User.fromJson(Map<String, dynamic> json) {
    userName = json["username"];
    description = json["description"];
    accountName = json["account_name"];
    accountDescription = json["account_description"];
  }
  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = userName;
    data['description'] = description;
    data['account_name'] = accountName;
    data['account_description'] = accountDescription;
    return data;
  }
}
