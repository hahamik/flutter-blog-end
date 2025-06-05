import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';

class UserRepository {
  Future<Map<String, dynamic>> join(String username, String email, String password) async {
    final requestBody = {
      "username": username,
      "email": email,
      "password": password,
    };
    Response response = await dio.post("", data: requestBody);
    Map<String, dynamic> responseBody = response.data;
    return responseBody;
  }
}
