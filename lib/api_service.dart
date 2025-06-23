import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model_rumah_sakit.dart';

class ApiService {
  static const String host = 'http://192.168.100.6:8000';

  static Future<List<RumahSakit>> getRumahSakit() async {
    try {
      final response = await http.get(Uri.parse('$host/rumahsakit'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => RumahSakit.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<bool> deleteRumahSakit(int id) async {
    try {
      final response = await http.delete(Uri.parse('$host/rumahsakit/$id'));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  static Future<bool> tambahRumahSakit(RumahSakit rumahSakit) async {
    try {
      final response = await http.post(
        Uri.parse('$host/rumahsakit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(rumahSakit.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to add data: $e');
    }
  }
}
