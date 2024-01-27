import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
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

  @override
  void initState() {
    super.initState();
    fetchLatestBMI();
  }

  Future<void> fetchLatestBMI() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bmi_records')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var latestRecord = querySnapshot.docs.first;
        var latestBMIValue = latestRecord.get('bmi');
        setState(() {
          latestBMI = "Latest BMI: $latestBMIValue";
        });
      }
    } catch (e) {
      print("Error fetching latest BMI: $e");
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
            Text(
              latestBMI,
              style: TextStyle(fontSize: 12),
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
                  Text(result, style: TextStyle(color: Colors.green[100], fontSize: 19)),
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

      // Store BMI record on Firestore
      await FirebaseFirestore.instance.collection('bmi_records').add({
        'weight': iWt,
        'height_ft': iFt,
        'height_inch': iInch,
        'bmi': bmi,
        'date': DateTime.now(),
      });

      // Update latest BMI in the app bar
      fetchLatestBMI();
    } else {
      setState(() {
        result = "Please fill all the required blanks!";
      });
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
        stream: FirebaseFirestore.instance.collection('bmi_records').orderBy('date', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No BMI records available.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              var record = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('BMI: ${record['bmi'].toStringAsFixed(2)}'),
                subtitle: Text('Date: ${record['date'].toDate()}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}