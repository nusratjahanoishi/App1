import 'package:nutritionapp/pages/homepage.dart';

import '../user.dart';
import '../databaseService.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String uid;

  Profile(this.uid);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget roleSpecificWidget(String role) {
    if (role == "role_general_user") {
      return ElevatedButton(onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Homepage(),
        //   ),
        // );

      }, child: Text("Normal Button"));
    } else if (role == "role_admin_user") {
      return Row(
        children: [
          ElevatedButton(onPressed: () {}, child: Text("Special Button 01")),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(onPressed: () {}, child: Text("Special Button 02")),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        flexibleSpace: null,
        // elevation: 2,
        backgroundColor: Color(0xffE0E0E0),

        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 10),
            child: Row(
              children: [
                Icon(Icons.search_sharp, size: 30),
                SizedBox(width: 8),
                Icon(Icons.settings, size: 30),

              ],
            ),
          ),

        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<CustomUser>(
          stream: DatabaseService().getUserByUserID(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CustomUser? customUser = snapshot.data;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${customUser?.name}", style: TextStyle(fontSize: 20, color: Colors.white),),
                        Text("Email: ${customUser?.email}", style: TextStyle(fontSize: 20, color: Colors.white),),
                        //Text("User ID: ${customUser?.uid}", style: TextStyle(fontSize: 20, color: Colors.white),),
                        //Text("Role: ${customUser?.role}", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ],
                    ),
                  ),
                  roleSpecificWidget(customUser!.role),
                  ListTile(
                    title: Text('Logout'),
                    onTap: () async {
                      await DatabaseService().logoutUser();
                      Navigator.pop(context); // Close the drawer after logout
                    },
                  ),
                ],
              );
            } else {
              return Text("Data Not Found");
            }
          },
        ),
      ),

      body:
      SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1,
                  // color: Colors.blueGrey,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/mushroom r khaon.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 110),
                    child: Text(
                      "Food Finder",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1,
                  // color: Colors.blueGrey,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/meal.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 110),
                    child: Text(
                      "Meal Planner",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1,
                  // color: Colors.blueGrey,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/BMR&BMI.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 80),
                    child: Text(
                      "BMR & BMI",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1,
                  // color: Colors.blueGrey,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/DietNote-04.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 110),
                    child: Text(
                      "Personal Diet Plan",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 1,
                  // color: Colors.blueGrey,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Health-Insurance.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 110),
                    child: Text(
                      "Doctor's Consultation",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}


