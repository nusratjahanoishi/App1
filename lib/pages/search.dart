import 'package:flutter/material.dart';
import 'package:nutritionapp/Setup/allfoodsmodel.dart';

import 'package:nutritionapp/databaseService.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  TextEditingController controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  String changevalue = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("search Element"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        filled: true,
                        fillColor: Color(0xffDFDEE4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          changevalue = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            controller.text = changevalue;
                          });
                        },
                        icon: Icon(Icons.search)),
                  )
                ],
              ),
            ),
            StreamBuilder<List<AllFoodModel>>(
              stream: _databaseService.getAllFood(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                      CircularProgressIndicator()); // Loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<AllFoodModel> foodlist = snapshot.data ?? [];
                  return controller.text.isEmpty
                      ? Text("Nothing found")
                      : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: foodlist.length,
                      itemBuilder: (context, index) {
                        return foodlist[index].name.contains(controller.text)
                            ? Visibility(
                          visible: foodlist[index].name.contains(controller.text)
                              ? true
                              : false,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xffEAEAEA)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(foodlist[index].image),
                                          fit: BoxFit.cover),
                                      color: const Color(0xffE2E2E8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(text: 'Food Name:'),
                                            TextSpan(
                                              text: '${foodlist[index].name}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text("Calories: ${foodlist[index].protein}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600)),
                                      Row(
                                        children: [
                                          const SizedBox(width: 5),
                                          Text("Ready in : ${foodlist[index].ready}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                            : SizedBox.shrink();
                      });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
