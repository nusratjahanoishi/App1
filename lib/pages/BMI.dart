 import 'package:animate_do/animate_do.dart';
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


class BMI_page extends StatefulWidget {
  const BMI_page({super.key, required this.title});

  final String title;

  @override
  State<BMI_page> createState() => _BMI_pageState();
}

class _BMI_pageState extends State<BMI_page> {
  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var inController = TextEditingController();

  var result = "";
  var bgColor;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],

        title: Text('yourBMI'),
      ),

      body:FadeInUp(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/p23.png'),
              fit: BoxFit.cover,
            ),
          ),
        
        
          child: Center(
            child: Container(
              width:300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
        
                  const Text(
                    'BMI', style: TextStyle(
                      fontSize:34,fontWeight:FontWeight.w700
        
                  ),),
                  SizedBox(height: 21,),
                  FadeInLeft(
                    child: TextField(
                      controller: wtController ,
                      decoration: InputDecoration(
                          label: Text('Enter your Weight(in Kgs)'),
                          prefixIcon: Icon(Icons.line_weight)
                            
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  FadeInLeft(
                    child: TextField(
                      controller: ftController,
                      decoration: InputDecoration(
                          label:Text('Enter your height(in feets)'),
                          prefixIcon: Icon(Icons.height)
                      ),
                      keyboardType: TextInputType.number,
                            
                    ),
                  ),
                  SizedBox(height: 11,),
                  FadeInLeft(
                    child: TextField(
                      controller: inController,
                      decoration: InputDecoration(
                          label: Text('Enter your height(in inch)'),
                          prefixIcon: Icon(Icons.height)
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 16,),
        
                  FadeInDown(
                    child: ElevatedButton(onPressed: (){
                      var wt = wtController.text.toString();
                      var ft = ftController.text.toString();
                      var inch = inController.text.toString();
                            
                      if(wt!= " " && ft!="" && inch!= "" )
                      {
                        //BMI calculation
                        var iWt =int.parse(wt);
                        var iFt =int.parse(ft);
                        var iInch=int.parse(inch);
                            
                        var tInch=(iFt*12)+iInch;
                            
                        var tCm= tInch*2.54;
                        var tM= tCm/100;
                            
                            
                        var bmi=iWt/(tM*tM);
                            
                        var msg=" ";
                            
                        if(bmi>25){
                          msg="You are overweight!";
                          bgColor=Colors.orange.shade200;
                            
                        }else if(bmi<18){
                          msg="You are underweight!";
                          bgColor=Colors.red.shade200;
                            
                        }else{
                          msg="You are healthy!";
                          bgColor=Colors.green.shade200;
                            
                        }
                        setState(() {
                          result="$msg \n Your BMI is: ${bmi.toStringAsFixed(4)}";
                        });
                            
                            
                      }else{
                        setState(() {
                          result = "please fill all the required blanks!!";
                        });
                            
                      }
                            
                    }, child: Text('calculate',style:TextStyle(color:Colors.green[300]), )),
                  ),
                  SizedBox(height: 11,),
                  Text(result, style: TextStyle(color:Colors.green[100],fontSize: 19),)
                ],
              ),
            ),
          ),
        ),
      ),
    );


  }
}
