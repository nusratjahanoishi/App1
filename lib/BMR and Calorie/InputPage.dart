import 'package:nutritionapp/BMR and Calorie/AimPage.dart';
import 'package:nutritionapp/BMR and Calorie/ImageTextCard.dart';
import 'package:nutritionapp/BMR and Calorie/ReusableCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutritionapp/Meal Planner/Common/colo_extension.dart';

const Color inactiveCard = Color(0xFF303030);
const Color activeCard = Color(0xFF202020);

class InputPage extends StatefulWidget {
  InputPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Color maleCard = inactiveCard, femaleCard = inactiveCard;
  int height = 180, weight = 60, age = 25;
  String gender = "";
  bool isLoading = false;

  void updateGenderSelected(int x) {
    if (x == 1) {
      gender = "Male";
      maleCard = activeCard;
      femaleCard = inactiveCard;
    } else {
      gender = "Female";
      maleCard = inactiveCard;
      femaleCard = activeCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Meter"),
        centerTitle: true,
        backgroundColor: TColor.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        print("FEMALE");
                        updateGenderSelected(2);
                      });
                    },
                    child: ReusableCard(
                      color: femaleCard,
                      card: ImageTextCard(
                        text: 'FEMALE',
                        icon: FontAwesomeIcons.venus,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        print("MALE");
                        updateGenderSelected(1);
                      });
                    },
                    child: ReusableCard(
                      color: maleCard,
                      card: ImageTextCard(
                        text: "MALE",
                        icon: FontAwesomeIcons.mars,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              color: activeCard,
              card: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'HEIGHT',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFDCDCDC),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        height.toString(),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'cm',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFDCDCDC),
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                      activeTrackColor: Color(0xff03DAC5),
                      thumbColor: Color(0xff03DAC5),
                      inactiveTrackColor: Color(0x5503DAC5),
                      overlayColor: Color(0x5503DAC5),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 100.0,
                      max: 240.0,
                      onChanged: (double x) {
                        setState(() {
                          height = x.round();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    color: activeCard,
                    card: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFDCDCDC),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          weight.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            color: Color(0xFFDCDCDC),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  weight--;
                                });
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: activeCard,
                    card: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Age",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFDCDCDC),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          age.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            color: Color(0xFFDCDCDC),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  age--;
                                });
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ButtonTheme(
            minWidth: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 7),
            child: FloatingActionButton(
              backgroundColor: Color(0xffbb86fc),
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator when isLoading is true
                  : Text(
                'Next',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                // Set isLoading to true when the button is pressed
                setState(() {
                  isLoading = true;
                });

                // Simulate a delay for loading (replace this with your actual logic)
                await Future.delayed(Duration(seconds: 2));

                // Navigate to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AimPage(
                      height: height,
                      weight: weight,
                      gender: gender,
                      age: age,
                    ),
                  ),
                );

                // Set isLoading to false when the loading is complete
                setState(() {
                  isLoading = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  RoundIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(icon),
      onPressed: onPressed,
      elevation: 0,
      constraints: BoxConstraints.tightFor(
        width: 56,
        height: 56,
      ),
      fillColor: Color(0xFFDCDCDC),
      shape: CircleBorder(),
    );
  }
}