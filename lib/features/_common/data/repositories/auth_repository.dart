// ignore_for_file: always_specify_types

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../features.dart';

/// A repository for handling authentication-related API requests.
class AuthRepository {
  /// Logs in a user with the given [email] and [password].
  ///
  /// Sends a POST request to the login endpoint and returns a [CustomResponse] object
  /// containing a [Session] on success or an error message on failure.
  ///
  /// Returns a [CustomResponse<Session>] object.
  Future<CustomResponse<Session>> login({
    String email = kTimuEmail,
    String password = kTimuPassword,
  }) async {
    final Uri url = Uri.parse('$kTimuApiBaseUrl/auth/login');

    try {
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as dynamic;

        // Assuming Session is a model class that you have defined.
        final session = Session.fromMap(data as Map<String, dynamic>);
        return CustomResponse<Session>(value: session);
      } else {
        return CustomResponse<Session>(
            error:
                'FFFailed to fetch data. Status code: ${response.statusCode}');
      }
    } on HttpException catch (e) {
      return CustomResponse<Session>(error: e.message);
    } catch (e) {
      return CustomResponse<Session>(error: 'An unexpected error occurred: $e');
    }
  }
}
