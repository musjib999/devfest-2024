import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class RemoteData {
  final Dio _dio = Dio();
  Future<dynamic> getData(
      {required String url, Map<String, String>? headers}) async {
    try {
      checkInternetConnection();
      final apiUrl = Uri.parse(url);
      final response = await http
          .get(
            apiUrl,
            headers: headers ?? {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw data['message'];
      }
    } on TimeoutException catch (_) {
      throw 'The request timed out. Please try again later.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> postData(
      {required String url, dynamic data, Map<String, String>? headers}) async {
    try {
      // checkInternetConnection();
      final apiUrl = Uri.parse(url);

      final response = await http
          .post(
            apiUrl,
            headers: headers ?? {'Content-Type': 'application/json'},
            body: data == null ? null : jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw data['message'];
      }
    } on TimeoutException catch (_) {
      throw 'The request timed out. Please try again later.';
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateData(
      {required String url,
      Map<String, dynamic>? data,
      Map<String, String>? headers}) async {
    try {
      checkInternetConnection();
      final apiUrl = Uri.parse(url);

      final response = await http.patch(
        apiUrl,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendDataWithImage({
    required String url,
    required Map<String, dynamic> formData,
    required File imageFile,
  }) async {
    try {
      checkInternetConnection();
      FormData formDataToSend = FormData.fromMap(formData);

      String fileName = imageFile.path.split('/').last;
      formDataToSend.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      ));

      final response = await _dio.post(
        url,
        data: formDataToSend,
      );

      if (response.statusCode == 201) {
      } else {
        final data = jsonDecode(response.data);
        throw data['message'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      throw 'No internent connection';
    }
  }
}
