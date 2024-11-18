import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';
import '../model/gender.dart';

class APIGender extends APIRepository {
  Future<Gender?> getGender(int id) async {
    try {
      Uri uri = Uri.parse("$baseurl/Gender/Get").replace(queryParameters: {
        'id': id.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Gender.fromJson(data['gender']);
      } else if (response.statusCode == 404) {
        print("Không tìm thấy giới tính");
        return null;
      } else {
        print("Lỗi không xác định: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi kết nối đến máy chủ: $e");
      return null;
    }
  }
}
