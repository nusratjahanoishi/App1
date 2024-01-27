import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var inController = TextEditingController();

  var result = "";
  var bgColor;
  String latestBMI = "Latest BMI: -";

  // Stream controller to broadcast the latest BMI data
  final _latestBmiController = StreamController<String>();

  @override
  void initState() {
    super.initState();
    _initLatestBMI();
  }



  Future<void> _initLatestBMI() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String latestBmi = await _fetchLatestBMI(user.uid);
      _latestBmiController.add(latestBmi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BMI Calculator'),
            StreamBuilder(
              stream: _latestBmiController.stream,
              builder: (context, AsyncSnapshot<String> snapshot) {
                return Text(
                  snapshot.data ?? "Latest BMI: -",
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMIRecordsPage()),
              );
            },
          ),
        ],
      ),
      body: FadeInUp(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/p23.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'BMI',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 21,),
                  FadeInLeft(
                    child: TextField(
                      controller: wtController,
                      decoration: InputDecoration(
                        label: Text('Enter your Weight (in Kgs)'),
                        prefixIcon: Icon(Icons.line_weight),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  FadeInLeft(
                    child: TextField(
                      controller: ftController,
                      decoration: InputDecoration(
                        label: Text('Enter your height (in feet)'),
                        prefixIcon: Icon(Icons.height),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 11,),
                  FadeInLeft(
                    child: TextField(
                      controller: inController,
                      decoration: InputDecoration(
                        label: Text('Enter your height (in inches)'),
                        prefixIcon: Icon(Icons.height),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 16,),
                  FadeInDown(
                    child: ElevatedButton(
                      onPressed: () {
                        storeDataOnFirestore();
                      },
                      child: Text('Calculate', style: TextStyle(color: Colors.green[300])),
                    ),
                  ),
                  SizedBox(height: 11,),
                  Text(result, style: TextStyle(color: Colors.black, fontSize: 19)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> storeDataOnFirestore() async {
    var wt = wtController.text.toString();
    var ft = ftController.text.toString();
    var inch = inController.text.toString();

    if (wt != "" && ft != "" && inch != "") {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // BMI calculation
        var iWt = int.parse(wt);
        var iFt = int.parse(ft);
        var iInch = int.parse(inch);

        var tInch = (iFt * 12) + iInch;
        var tCm = tInch * 2.54;
        var tM = tCm / 100;

        var bmi = iWt / (tM * tM);

        var msg = " ";

        if (bmi > 25) {
          msg = "You are overweight!";
          bgColor = Colors.orange.shade200;
        } else if (bmi < 18) {
          msg = "You are underweight!";
          bgColor = Colors.red.shade200;
        } else {
          msg = "You are healthy!";
          bgColor = Colors.green.shade200;
        }

        setState(() {
          result = "$msg \n Your BMI is: ${bmi.toStringAsFixed(4)}";
        });

        // Update latest BMI data immediately
        _latestBmiController.add("Latest BMI: ${bmi.toStringAsFixed(2)}");

        // Store BMI record on Firestore
        await FirebaseFirestore.instance.collection('bmi_records').add({
          'user_uid': user.uid, // Associate the record with the user's UID
          'weight': iWt,
          'height_ft': iFt,
          'height_inch': iInch,
          'bmi': bmi,
          'date': DateTime.now(),
        });
      }
    } else {
      setState(() {
        result = "Please fill all the required blanks!";
      });
    }
  }
  Future<String> _fetchLatestBMI(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('bmi_records')
        .where('user_uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var latestRecord = querySnapshot.docs.first;
      var latestBMIValue = latestRecord.get('bmi');
      return "Latest BMI: $latestBMIValue";
    } else {
      return "Latest BMI: -";
    }
  }
}

class BMIRecordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Records'),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(child: Text('No user logged in.'));
          }

          return StreamBuilder(
            stream: _fetchBMIRecords(userSnapshot.data!.uid),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No BMI records available.'));
              }

              // Order BMI records by date
              List<Map<String, dynamic>> bmiRecords = snapshot.data!;
              bmiRecords.sort((a, b) => b['date'].compareTo(a['date']));

              return ListView(
                children: bmiRecords.map((record) {
                  var value = record['bmi'].toStringAsFixed(2);

                  return ListTile(
                    title: Text('BMI: $value'),
                    subtitle: Text('Date: ${record['date'].toDate()}'),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _fetchBMIRecords(String uid) {
    return FirebaseFirestore.instance
        .collection('bmi_records')
        .where('user_uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        return data;
      }).toList();
    });
  }
}
