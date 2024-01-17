import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nutritionapp/databaseService.dart';
import 'package:nutritionapp/doctors.dart';
import 'package:nutritionapp/user.dart';

class DoctorConsolation extends StatefulWidget {
  final String userId;

  const DoctorConsolation({Key? key, required this.userId}) : super(key: key);

  @override
  State<DoctorConsolation> createState() => _DoctorConsolationState();
}

class _DoctorConsolationState extends State<DoctorConsolation> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xff2F685A),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 27,
                      child: Icon(
                        Icons.person_2_outlined,
                        size: 40,
                        color: Color(0xff2F685A),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<CustomUser>(
                        stream: DatabaseService().getUserByUserID(widget.userId),
                        builder: (context, snapshot) {
                          CustomUser? customUser = snapshot.data;
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi, ${customUser!.name}",
                                  style: const TextStyle(fontSize: 20, color: Colors.white),
                                ),
                                const Text(
                                  "You can book a doctor for a health checkup",
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        })
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book a Doctor",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    "Schedule an appointment with a Diagnosis",
                    style: TextStyle(fontSize: 12, color: Color(0xffC2C2C2)),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<Doctors>>(
              stream: DatabaseService().getDoctorsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Doctors> doctorsList = snapshot.data ?? [];

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctorsList.length,
                    itemBuilder: (context, index) {
                      Doctors doctor = doctorsList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  children: [
                                    Text(
                                      selectedDate == null
                                          ? 'Select a date'
                                          : 'Selected Date: ${selectedDate!.toLocal()}',
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        DatabaseService().selectDate(context).then((value) {
                                          setState(() {
                                            selectedDate = value;
                                          });
                                        });
                                      },
                                      child: const Text('Select Date'),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (selectedDate == null) {
                                            Fluttertoast.showToast(
                                              msg: "Please select a date first",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            return;
                                          }

                                          DatabaseService().setAppointmentDate(
                                            doctor.uid,
                                            doctor.name,
                                            doctor.image,
                                            doctor.appointment,
                                            doctor.department,
                                            doctor.rating,
                                            selectedDate!,
                                            doctor.time,
                                            widget.userId,
                                          ).then((value) {
                                            Fluttertoast.showToast(
                                              msg: "Successfully appointment done",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.black,
                                              fontSize: 16.0,
                                            );
                                          });
                                        },
                                        child: const Text("Confirm Appointment"),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 100,
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
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(doctor.image),
                                      ),
                                      color: const Color(0xffE2E2E8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(doctor.name),
                                      Text(
                                        doctor.department,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffC2C2C2),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            itemSize: 15,
                                            initialRating: double.parse(doctor.rating),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                            const EdgeInsets.symmetric(horizontal: 1.0),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (double value) {},
                                          ),
                                          const SizedBox(width: 5),
                                          Text("${doctor.rating}"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.timer, color: Color(0xffC2C2C2)),
                                          Text(
                                            "${doctor.time}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xffC2C2C2),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
