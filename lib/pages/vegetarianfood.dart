import 'package:flutter/material.dart';
import 'package:nutritionapp/Setup/allfoodsmodel.dart';
import 'package:nutritionapp/databaseService.dart';

class VegetarianFoodScreen extends StatefulWidget {
  final  bool isFromveginarian;
  const VegetarianFoodScreen({super.key,required this.isFromveginarian});

  @override
  State<VegetarianFoodScreen> createState() => _VegetarianFoodScreenState();
}

class _VegetarianFoodScreenState extends State<VegetarianFoodScreen> {
  final DatabaseService _databaseService = DatabaseService();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(widget.isFromveginarian?"vegetarian Food":"Non vegetarian Food"),
        ),
        body: Column(
          children: [
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
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: foodlist.length,
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: foodlist[index].isvagitarian?true:false,
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
                                              style: const TextStyle(fontWeight: FontWeight.bold),
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
                        );
                      });
                }
              },
            )
          ],
        ));
  }
}