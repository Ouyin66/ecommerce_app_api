import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app_api/api/api.dart';

import '../model/location.dart';
import '../model/loginresponse.dart';

class APILocation extends APIRepository {
  Future<List<Location>?> getLocationByUser(int userId) async {
    try {
      Uri uri =
          Uri.parse("$baseurl/Location/ListByUserId").replace(queryParameters: {
        'userId': userId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<Location> locations = (data['locations'] as List)
            .map((locationJson) => Location.fromJson(locationJson))
            .toList();

        return locations;
      } else {
        print("Lỗi khi lấy danh sách địa chỉ: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Lỗi: $e");
      return [];
    }
  }

  Future<Location?> getLocation(int id) async {
    try {
      Uri uri = Uri.parse("$baseurl/Location/Get").replace(queryParameters: {
        'id': id.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        Location location = Location.fromJson(data['location']);

        return location;
      } else if (response.statusCode == 404) {
        print("Không tìm thấy địa điểm");
        return null;
      } else {
        print("Lỗi khi lấy địa điểm: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<MessageResponse?> insertLocation(Location location) async {
    try {
      Uri uri = Uri.parse("$baseurl/Location/Insert").replace(queryParameters: {
        'userId': location.userId.toString(),
        'name': location.name.toString(),
        'address': location.address.toString(),
      });

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return MessageResponse(
            location: Location.fromJson(data['location']),
            successMessage: data['message']);
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey('errorName') &&
            errorData['errorName'] != null) {
          return MessageResponse(errorMessage: errorData['errorName'] ?? '');
        } else if (errorData.containsKey('errorAddress') &&
            errorData['errorAddress'] != null) {
          return MessageResponse(anotherError: errorData['errorAddress'] ?? '');
        } else {
          return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
        }
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<MessageResponse?> updateLocation(
      int id, String name, String address) async {
    try {
      Uri uri = Uri.parse("$baseurl/Location/Update").replace(queryParameters: {
        'id': id.toString(),
        'name': name,
        'address': address,
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(
            location: Location.fromJson(data['location']),
            successMessage: data['message']);
      } else {
        final errorData = jsonDecode(response.body);

        if (errorData.containsKey('errorName') &&
            errorData['errorName'] != null) {
          return MessageResponse(errorMessage: errorData['errorName'] ?? '');
        } else if (errorData.containsKey('errorAddress') &&
            errorData['errorAddress'] != null) {
          return MessageResponse(anotherError: errorData['errorAddress'] ?? '');
        } else {
          return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
        }
      }
    } catch (e) {
      print("Lỗi: $e với baseurl: $baseurl");
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }

  Future<MessageResponse?> deleteLocation(int id) async {
    try {
      Uri uri = Uri.parse("$baseurl/Location/Delete").replace(queryParameters: {
        'id': id.toString(),
      });

      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return MessageResponse(
            location: Location.fromJson(data['location']),
            successMessage: data['message']);
      } else if (response.statusCode == 404) {
        final errorData = jsonDecode(response.body);
        return MessageResponse(errorMessage: errorData['message']);
      } else {
        final errorData = jsonDecode(response.body);
        return MessageResponse(errorMessage: errorData['message']);
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<MessageResponse?> setDefaultLocation(int locationId) async {
    try {
      Uri uri = Uri.parse("$baseurl/Location/SetDefaultLocation")
          .replace(queryParameters: {
        'locationId': locationId.toString(),
      });

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MessageResponse(successMessage: data['message']);
      } else if (response.statusCode == 404) {
        final errorData = jsonDecode(response.body);
        return MessageResponse(errorMessage: errorData['message'] ?? '');
      } else {
        return MessageResponse(errorMessage: "Đã xảy ra lỗi không xác định");
      }
    } catch (e) {
      print("Lỗi: $e với baseurl: $baseurl");
      return MessageResponse(errorMessage: "Không thể kết nối đến máy chủ.");
    }
  }
}
