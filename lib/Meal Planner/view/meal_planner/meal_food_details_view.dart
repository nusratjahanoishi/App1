import 'package:nutritionapp/Meal Planner//common_widget/meal_recommed_cell.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/meal_category_cell.dart';

import '../../common/common.dart';
import '../../common/constants.dart';
import '../../common/globals.dart' as global;

class MealFoodDetailsView extends StatefulWidget {
  final Map eObj;
  const MealFoodDetailsView({super.key, required this.eObj});

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  TextEditingController txtSearch = TextEditingController();

  List recommendArr = [
    {
      "name": "Honey Pancake",
      "image": "assets/img/rd_1.png",
      "size": "Easy",
      "time": "30mins",
      "kcal": "180kCal"
    },
    {
      "name": "Canai Bread",
      "image": "assets/img/m_4.png",
      "size": "Easy",
      "time": "20mins",
      "kcal": "230kCal"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Recommendation\nfor Diet",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: media.width * 0.6,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: recommendArr.length,
                itemBuilder: (context, index) {
                  var fObj = recommendArr[index] as Map? ?? {};
                  return MealRecommendCell(
                    fObj: fObj,
                    index: index,
                  );
                },
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(height: media.width * 0.05),
            SizedBox(
              height: 350,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.vertical,
                itemCount: categoryFoods.length,
                itemBuilder: (context, index) {
                  var cObj = categoryFoods[index] as Map? ?? {};

                  bool isEvent = index % 2 == 0;
                  List<Map<String, dynamic>> list =
                      getIndexArr(widget.eObj["name"].toString());
                  bool show = false;
                  for (var element in list) {
                    if (element["name"] == cObj["name"]) {
                      show = true;
                    }
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4),
                        width: 100,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isEvent
                                  ? [
                                      TColor.primaryColor2.withOpacity(0.5),
                                      TColor.primaryColor1.withOpacity(0.5)
                                    ]
                                  : [
                                      TColor.secondaryColor2.withOpacity(0.5),
                                      TColor.secondaryColor1.withOpacity(0.5)
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(17.5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: TColor.white,
                                    borderRadius: BorderRadius.circular(17.5)),
                                child: Image.asset(
                                  cObj["image"].toString(),
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                cObj["name"],
                                maxLines: 1,
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        width: 50,
                        height: 50,
                        child: IconButton(
                          onPressed: () {
                            bool flag = false;
                            for (var element in list) {
                              if (element["name"] == cObj["name"]) {
                                flag = true;
                              }
                            }
                            if (flag) {
                              list.removeWhere(
                                  (element) => element["name"] == cObj["name"]);
                            } else {
                              list.add({
                                "name": cObj["name"],
                                "time": "07:00am",
                                "image": "assets/img/honey_pan.png"
                              });
                            }
                            setIndexArr(widget.eObj["name"].toString(), list);
                            setState(() {});
                          },
                          icon: Icon(
                            show ? Icons.remove_circle : Icons.add_circle,
                            color: TColor.gray,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: media.width * 0.05),
          ],
        ),
      ),
    );
  }
}
