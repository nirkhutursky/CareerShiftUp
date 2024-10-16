import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      'http://localhost:3000'; // Replace with your backend server address

  // Function to add a new resume
  static Future<Map<String, dynamic>> addResume(
      String token, Map<String, dynamic> resumeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resumes'), // Update to /resumes
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(resumeData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add resume: ${response.body}');
    }
  }

  // Function to retrieve resumes
  static Future<List<dynamic>> getResumes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/resumes'), // This is already correct
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch resumes: ${response.body}');
    }
  }

  // Function to delete a resume by ID
  static Future<void> deleteResume(String token, String resumeId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/resumes/$resumeId'), // This is already correct
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete resume: ${response.body}');
    }
  }
}
