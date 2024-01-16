import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/BMR and Calorie/ReusableCard.dart';
import 'package:nutritionapp/databaseService.dart';
import '../Meal Planner/Common/colo_extension.dart';
import '';

class Result extends StatelessWidget {
  final String status, msg;
  final String statusNumber, currentCalorie, goalCalorie, bmr;

  Result({
    required this.status,
    required this.msg,
    required this.statusNumber,
    required this.currentCalorie,
    required this.goalCalorie,
    required this.bmr,
  });

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Meter"),
        centerTitle: true,
        backgroundColor: TColor.white,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMRHistory()),
              );
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                'Result',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
              padding: EdgeInsets.only(top: 25),
            ),
          ),
          Expanded(
            flex: 4,
            child: ReusableCard(
              color: Color(0xffBB86FC),
              card: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Body Mass Weight",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    statusNumber,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ReusableCard(
              color: Color(0xffBB86FC),
              card: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Basal Metabolic Rate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "BMR: " + bmr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Daily Calorie Required",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    currentCalorie,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "(As per Activity)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Daily Calorie Required",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    goalCalorie,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "(As per Activity)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ButtonTheme(
            minWidth: double.infinity,
            child: GestureDetector(
              onTap: () async {
                // Fetch the authenticated user
                User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
    await databaseService.storeBMRData(user.uid, double.parse(bmr), currentCalorie, goalCalorie, DateTime.now());
    await databaseService.storeBMRHistory(user.uid, double.parse(bmr), currentCalorie, goalCalorie, DateTime.now());

    ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('BMR data saved successfully!'),
    ),
    );
    }
    },

                // Do not navigate back to the previous screen
                // Navigator.pop(context);

              child: Container(
                color: Color(0xffbb86fc),
                padding: EdgeInsets.symmetric(vertical: 7),
                child: GestureDetector(
                  onTap: () async {
                    // Your logic to save data

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                        content: Text("Save Your Data"),  // Change the message as needed
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Save Your Data',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class BMRHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print('User UID: ${user?.uid}');

    return Scaffold(
      appBar: AppBar(
        title: Text("BMR History"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bmr_history').doc(user?.uid).collection('history').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('No data available');
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var historyDocs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              var historyData = historyDocs[index].data();
              return ListTile(
                title: Text('BMR: ${historyData['bmr']}'),
                subtitle: Text('Goal Calorie: ${historyData['goalCalorie']} | Date: ${historyData['date'].toDate()}'),
                // Add other fields as needed
              );
            },
          );
        },
      ),
    );
  }
}
