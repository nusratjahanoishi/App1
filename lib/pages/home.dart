import '../user.dart';
import '../databaseService.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String uid;
  Home(this.uid);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget roleSpecificWidget(String role) {
    if (role == "role_general_user") {
      return ElevatedButton(onPressed: () {}, child: Text("Normal Button"));
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
        title: Text("User Profile"),
      ),
      body: StreamBuilder<CustomUser>(
          stream: DatabaseService().getUserByUserID(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CustomUser? customUser = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ", style: TextStyle(fontSize: 30),),
                    Text(
                      "${customUser?.name} ", style: TextStyle(fontSize: 20),),

                    SizedBox(height: 20,),
                    Text("Email: ", style: TextStyle(fontSize: 30),),
                    Text(
                      "${customUser?.email} ", style: TextStyle(fontSize: 20),),

                    SizedBox(height: 20,),
                    Text("User ID: ", style: TextStyle(fontSize: 30),),
                    Text(
                      "${customUser?.uid} ", style: TextStyle(fontSize: 20),),

                    SizedBox(height: 20,),
                    Text("Role: ", style: TextStyle(fontSize: 30),),
                    Text(
                      "${customUser?.role} ", style: TextStyle(fontSize: 20),),

                    SizedBox(height: 40,),
                    roleSpecificWidget(customUser!.role),

                    SizedBox(height: 40,),
                    ElevatedButton(
                        onPressed: () async {
                          await DatabaseService().logoutUser();
                        },
                        child: Text("Logout"))
                  ],
                ),
              );
            } else {
              return Text("Data Not Found");
            }
          }),
    );
  }
}

