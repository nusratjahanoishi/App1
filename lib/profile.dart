//
// import 'package:flutter/material.dart';
// class profile extends StatefulWidget {
//   const profile({super.key});
//
//   @override
//   State<profile> createState() => _profileState();
// }
//
// class _profileState extends State<profile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           children: [
//             SizedBox(height: 20,),
//             Container(
//               height:130,
//               width:130,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: Image(
//                   image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ09uJRvSYTZguOy_L--3XALEwxqNIuvBvF8yJOHWNiew&s'),
//                   loadingBuilder: (context,child,loadingProgress){
//                     return CircularProgressIndicator();
//                   },
//                   errorBuilder: (context,object,stack){
//                     return Co
//                   },
//                 ),
//               ),
//
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
