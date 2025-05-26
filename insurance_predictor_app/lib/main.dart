import 'package:flutter/material.dart';
import 'models/insurance_model.dart';
import 'services/api_service.dart';

void main() {
  runApp(MaterialApp(home: InsuranceFormScreen()));
}

class InsuranceFormScreen extends StatefulWidget {
  @override
  _InsuranceFormScreenState createState() => _InsuranceFormScreenState();
}

class _InsuranceFormScreenState extends State<InsuranceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();
  final bmiController = TextEditingController();
  final childrenController = TextEditingController();

  int sex = 1, smoker = 0, region = 0;
  InsuranceResponse? result;

  // When the form is submitted
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var request = InsuranceRequest(
        age: int.parse(ageController.text),
        sex: sex,
        smoker: smoker,
        bmi: double.parse(bmiController.text),
        children: int.parse(childrenController.text),
        region: region,
      );

      var response = await ApiService.predictInsuranceCost(request);
      setState(() {
        result = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Insurance Cost Predictor")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // AGE
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter age" : null,
              ),

              // SEX DROPDOWN
              DropdownButtonFormField(
                value: sex,
                decoration: InputDecoration(labelText: "Sex"),
                items: [
                  DropdownMenuItem(value: 1, child: Text("Male")),
                  DropdownMenuItem(value: 0, child: Text("Female")),
                ],
                onChanged: (val) => setState(() => sex = val!),
              ),

              // SMOKER DROPDOWN
              DropdownButtonFormField(
                value: smoker,
                decoration: InputDecoration(labelText: "Smoker"),
                items: [
                  DropdownMenuItem(value: 1, child: Text("Yes")),
                  DropdownMenuItem(value: 0, child: Text("No")),
                ],
                onChanged: (val) => setState(() => smoker = val!),
              ),

              // BMI
              TextFormField(
                controller: bmiController,
                decoration: InputDecoration(labelText: "BMI"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter BMI" : null,
              ),

              // CHILDREN
              TextFormField(
                controller: childrenController,
                decoration: InputDecoration(labelText: "Children"),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? "Enter number of children" : null,
              ),

              // REGION
              DropdownButtonFormField(
                value: region,
                decoration: InputDecoration(labelText: "Region"),
                items: [
                  DropdownMenuItem(value: 0, child: Text("Northeast")),
                  DropdownMenuItem(value: 1, child: Text("Northwest")),
                  DropdownMenuItem(value: 2, child: Text("Southeast")),
                  DropdownMenuItem(value: 3, child: Text("Southwest")),
                ],
                onChanged: (val) => setState(() => region = val!),
              ),

              SizedBox(height: 20),

              // BUTTON
              ElevatedButton(onPressed: _submitForm, child: Text("Predict")),

              // RESULT
              if (result != null) ...[
                SizedBox(height: 20),
                Text(
                  "Result: \$${result!.insuranceCost.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Age: ${result!.age}"),
                Text("Sex: ${result!.sex}"),
                Text("Smoker: ${result!.smoker}"),
                Text("BMI: ${result!.bmi}"),
                Text("Children: ${result!.children}"),
                Text("Region: ${result!.region}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
