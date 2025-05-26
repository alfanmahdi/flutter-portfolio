// This class is for the request data you send to the API
class InsuranceRequest {
  final int age, sex, smoker, children, region;
  final double bmi;

  InsuranceRequest({
    required this.age,
    required this.sex,
    required this.smoker,
    required this.bmi,
    required this.children,
    required this.region,
  });

  // Converts values to key-value pairs as expected by the API
  Map<String, String> toFormData() {
    return {
      'age': age.toString(),
      'sex': sex.toString(),
      'smoker': smoker.toString(),
      'bmi': bmi.toString(),
      'children': children.toString(),
      'region': region.toString(),
    };
  }
}

// This class is for the response data you receive from the API
class InsuranceResponse {
  final int age, children;
  final String sex, smoker, region;
  final double bmi, insuranceCost;

  InsuranceResponse({
    required this.age,
    required this.sex,
    required this.smoker,
    required this.bmi,
    required this.children,
    required this.region,
    required this.insuranceCost,
  });

  // Converts JSON response to Dart object
  factory InsuranceResponse.fromJson(Map<String, dynamic> json) {
    return InsuranceResponse(
      age: json['age'],
      sex: json['sex'],
      smoker: json['smoker'],
      bmi: json['bmi'],
      children: json['children'],
      region: json['region'],
      insuranceCost: json['insurance_cost'],
    );
  }
}
