import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class splash_page extends StatefulWidget {
  final Widget? child;

  const splash_page({super.key, this.child});

  @override
  State<splash_page> createState() => _splash_pageState();
}

class _splash_pageState extends State<splash_page> {

  @override
  void initState(){
    Future.delayed(
        Duration(seconds: 5),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget.child!), (route) => false);
    }

    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('hd2.png'), fit: BoxFit.cover),
      ),
    );

  }
}