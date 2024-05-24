import 'package:accident_reporter/templates/accidentList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../commons/constants.dart';
import '../domains/requests/getVehicles.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double? cornerRadius;

  @override
  void initState() {
    super.initState();
    loadCornerRadius();

  }

  Future<void> loadCornerRadius() async {
    setState(() {
      setCorners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Режим $trackMode')),
      body: Stack(
        children: [
          Column(
            children: [
              accidentList()
            ],
          ),
          Positioned(
            right: 10,
            left: 10,
            bottom: 10,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Действие, которое происходит при нажатии на кнопку
                  print('Button Pressed');
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceCorner*0.8),
                    ),
                  ),
                ),
                child: const Text(
                  'Сообщить об аварии',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
  
}