import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/insurance_model.dart';

class ApiService {
  // Change this to your actual API URL
  static const String _url =
      "https://hilmizr-pdst-regression-be-vclass.hf.space/predict";

  static Future<InsuranceResponse?> predictInsuranceCost(
    InsuranceRequest request,
  ) async {
    try {
      var response = await http.post(
        Uri.parse(_url),
        body: request.toFormData(), // Send the form data
      );

      if (response.statusCode == 200) {
        // Decode the JSON and convert it to Dart object
        final data = json.decode(response.body);
        return InsuranceResponse.fromJson(data);
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
}
