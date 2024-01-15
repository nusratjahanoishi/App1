import 'package:carousel_slider/carousel_slider.dart';
import 'package:nutritionapp/Meal Planner/Common/colo_extension.dart';
import 'package:nutritionapp/pages/doctos_consultation.dart';

import 'package:nutritionapp/pages/EditProfileScreen.dart';

import '../Meal Planner/view/meal_planner/meal_planner_view.dart';
import '../personalDietplan/planpage.dart';
import '../user.dart';
import '../databaseService.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'BMI.dart';
import 'package:nutritionapp/personalDietplan/Meals.dart';

class Profile extends StatefulWidget {
  final String uid;

  Profile(this.uid);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {

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
  int currIndex = 0;
  final PageController tabPageController = PageController();
  final List<String> carouselItems = [
    'assets/vegetarian.png',
    'assets/Non- vegetarian.png',
    'assets/bdp digital zone.png',
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: carouselItems.length, vsync: this);
  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white, //Color(0xffdFBF9F1),//FFFBF5
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FadeInUp(
                          duration: Duration(milliseconds: 1300),
                          child: IconButton(
                            icon: Icon(Icons.account_circle_rounded, color: Colors.black),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return StreamBuilder<CustomUser>(
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
                                  );
                                },
                              );
                            },
                          ),
                        ),


                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //crossAxisAlignment: ,
                                  children: [
                                    Text(
                                      "Welcome To Leaflife",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeInUp(duration: Duration(milliseconds: 1300), child: IconButton(
                          icon: Icon(Icons.settings, color: Colors.black,), onPressed: () {},
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Food Finder",
                                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),

                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 5),

                  CarouselSlider.builder(
                    options: CarouselOptions(
                      aspectRatio: 14 / 9,
                      viewportFraction: 0.75,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      height: 280,
                      clipBehavior: Clip.antiAlias,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currIndex = index;
                          _tabController.animateTo(index);
                        });
                      },
                    ),
                    itemCount: carouselItems.length,
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return _buildCarouselItem(context, carouselItems[index], index);
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: TabPageSelector(
                      controller: _tabController,
                      color: Colors.grey,
                      selectedColor: Colors.orange,
                      borderStyle: BorderStyle.none,
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Fitness and Health calculation",
                                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("All"),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                makeBestCategory(
                                  image: 'assets/bmr.png',
                                  title: "",
                                  onTap: () {
                                    print('BMI tapped!');
                                  },
                                ),
                                makeBestCategory(
                                  image: 'assets/Calorie Counter.png',
                                  title: '',
                                  onTap: () {
                                    print('BMR tapped!');
                                  },
                                ),
                                makeBestCategory(
                                  image: 'assets/bmi.jpeg',
                                  title: '',
                                  onTap: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => BMIPage()),
                                    );
                                    print('Calories tapped!');
                                  },
                                ),
                                // Add more categories as needed
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Categories",
                                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("All"),
                            ],
                          ),
                          SizedBox(height: 20),
                          FadeInUp(child: SingleChildScrollView(

                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              clipBehavior: Clip.antiAlias,
                              child: GestureDetector(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  const MealPlannerView(),),
                                  );
                                  print('Calories tapped!');
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height / 4,
                                  width: MediaQuery.of(context).size.width / 1,
                                  child: Image.asset(
                                    'assets/Meal Planner.png',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height / 4,
                                    width: MediaQuery.of(context).size.width / 1,
                                  ),
                                ),
                              ),
                            ),),),
                          SizedBox(height: 15,),
                          FadeInUp(child: SingleChildScrollView(

                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              clipBehavior: Clip.antiAlias,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  DoctorConsolation(userId: widget.uid,)));


                                  print('Container pressed!');
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height / 4,
                                  width: MediaQuery.of(context).size.width / 1,
                                  child: Image.asset(
                                    'assets/Doctor’s Consultation.png',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height / 4,
                                    width: MediaQuery.of(context).size.width / 1,
                                  ),
                                ),
                              ),
                            ),),),
                          SizedBox(height: 15,),
                          FadeInUp(child: SingleChildScrollView(

                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              clipBehavior: Clip.antiAlias,
                              child: GestureDetector(
                                onTap: () {

                                  print('Container pressed!');
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height / 4,
                                  width: MediaQuery.of(context).size.width / 1,
                                  child: Image.asset(
                                    'assets/bdp digital zone.png',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height / 4,
                                    width: MediaQuery.of(context).size.width / 1,
                                  ),
                                ),
                              ),
                            ),),),
                          SizedBox(height: 20,)

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        handleImageTap(index);
      },
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget makeBestCategory({image, title, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 3 / 2.2,
        child: Container(
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
  void handleImageTap(int index) {
    switch (index) {
      case 0:
      // Handle the onTap event for the first image
        print('First image tapped! URL: ${carouselItems[index]}');
        // Add your action for the first image
        break;
      case 1:
        print('Second image tapped! URL: ${carouselItems[index]}');
        // Add your action for the second image
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Mealpage(),
          ),
        );
         // Navigate to the CartPage
        print('Third image tapped! URL: ${carouselItems[index]}');
        break;
    // Add more cases if you have additional images
    }
  }



  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
