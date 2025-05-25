import 'dart:convert';

import 'package:bmi_calculator/constant/colors.dart';
import 'package:bmi_calculator/constant/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? data;
  String apiEndpoint = "api_endpoint_here";

  double _currentWeightValue = 40;
  double _currentHeightValue = 40;
  int _age = 10;
  bool isMale = false;
  
  Future<void> postData() async {
    if (_age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("GABISA TAI")));
    }
    final response = await http.post(
      Uri.parse(apiEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "gender": isMale ? 0 : 1,
        "age": _age,
        "height": _currentHeightValue,
        "weight": _currentWeightValue,
      })
    );

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        // data = response.body;
        data = jsonDecode(response.body);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondaryWhite,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              children: [
                Text(
                  "Height",
                  style: heading1Black,
                ),
                Row(
                  spacing: 2,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentHeightValue.round().toString(),
                      style: subHeadingBlack,
                    ),
                    Text(
                      "CM",
                      style: paragraphBlack,
                    ),
                  ],
                ),
                Slider(
                  activeColor: blue,
                  min: 0,
                  max: 200,
                  value: _currentHeightValue,
                  onChanged: (value) {
                    setState(() {
                      _currentHeightValue = value;
                    });
                  }
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: secondaryWhite,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              children: [
                Text(
                  "Weight",
                  style: heading1Black,
                ),
                Row(
                  spacing: 2,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentWeightValue.round().toString(),
                      style: subHeadingBlack,
                    ),
                    Text(
                      "Kg",
                      style: paragraphBlack,
                    ),
                  ],
                ),
                Slider(
                  activeColor: blue,
                  min: 0,
                  max: 200,
                  value: _currentWeightValue,
                  onChanged: (value) {
                    setState(() {
                      _currentWeightValue = value;
                    });
                  }
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: secondaryWhite,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              spacing: 10,
              children: [
                Text(
                  "AGE",
                  style: heading1Black,
                ),
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _age++;
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        color: blue,
                        size: 30,
                      ),
                    ),
                    Text(
                      _age.toString(),
                      style: subHeadingBlack,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _age--;
                        });
                      },
                      icon: Icon(
                        size: 30,
                        Icons.remove,
                        color: blue
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isMale = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isMale ? blue : Colors.red,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/man.png",
                        width: 150,
                        height: 150,
                      ),
                      Text(
                        "Male",
                        style: subHeadingBlack,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isMale = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isMale ? Colors.red : blue
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/woman.png",
                        width: 150,
                        height: 150,
                      ),
                      Text(
                        "Female",
                        style: subHeadingBlack,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.amber)
              ),
              onPressed: postData,
              child: Text(
                "Submit",
                style: subHeadingBlack,
              )
            ),
          ),
          if (data != null) 
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryWhite,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Text(
                    "HASIL BMI:",
                    style: heading1Black
                  ),
                  const SizedBox(height: 20,),
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 10,
                        maximum: 40,
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 10,
                            endValue: 18.5,
                            color: Colors.blue,        // Kurus
                            label: 'Kurus',
                            startWidth: 20,
                            endWidth: 20,
                          ),
                          GaugeRange(
                            startValue: 18.5,
                            endValue: 25,
                            color: Colors.green,       // Normal
                            label: 'Normal',
                            startWidth: 20,
                            endWidth: 20,
                          ),
                          GaugeRange(
                            startValue: 25,
                            endValue: 30,
                            color: Colors.orange,      // Overweight
                            label: 'Overweight',
                            startWidth: 20,
                            endWidth: 20,
                          ),
                          GaugeRange(
                            startValue: 30,
                            endValue: 40,
                            color: Colors.red,         // Obesitas
                            label: 'Obesitas',
                            startWidth: 20,
                            endWidth: 20,
                          ),
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(value: data!['data'][0]), // Misalnya nilai BMI kamu
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            widget: Text(
                              data!['data'][0].floor().toString(),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            angle: 90,
                            positionFactor: 0.8,
                          )
                        ],
                      )
                    ],
                  ),
                  // Text(data!['data'][0].toString()),
                  Text(
                    "Kategori: ${_predict(data!['data'][0]).toString()}",
                    style: subHeadingBlack,
                  )
                ],
              ),
            ),

        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue,
      title: Text(
        "BMI CALCULATOR",
        style: heading1Black,
      ),
      centerTitle: true,
    );
  }

  String _predict(double bmiValue) {
    if (bmiValue < 18.5) {
      return "Kurus";
    } else if (bmiValue >= 18.5 && bmiValue < 25) {
      return "Normal";
    } else if (bmiValue >= 25 && bmiValue < 30) {
      return "Overweight";
    } else {
      return "Obesitas";
    }
  }
}
