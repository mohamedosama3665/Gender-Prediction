import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String name;
  String gender;
  double probability;
  bool spinner = false;

  Future predictGender() async{
    String url = 'https://api.genderize.io/?name=$name';
    var res =  await http.get(url);
    var body = jsonDecode(res.body);
      probability = body['probability'];
      gender = body['gender'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Predict Gender',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Enter your name :',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter name here",
                    border: OutlineInputBorder(),
                    //labelText: "name",
                  ),
                  onChanged: (value) {
                    name = value;
                    print(name);
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: FlatButton(
                    onPressed: () async{
                      setState(() {
                        spinner = true;
                      });
                      await predictGender();
                      print('$gender********************');
                      print('$probability****************');
                      setState(() {
                        spinner = false;
                      });
                    },
                    child: Text(
                      'Predict Gender',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8),
                    ),
                    color: Colors.redAccent,
                  ),),
              (gender == null || probability == null)? SizedBox():Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1, vertical: MediaQuery.of(context).size.height*0.08),
                child: Text("Gender: $gender, Probability: $probability", style: TextStyle(fontSize: 24, fontFamily: "Horizon", fontWeight: FontWeight.w400),)
                /*RotateAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: ["Gender", "$gender", "Probability", "$probability"],
                    textStyle: TextStyle(fontSize: 30.0, fontFamily: "Horizon", fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}
