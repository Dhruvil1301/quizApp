import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testline_assignment/src/features/home/view/quizView.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent.shade100,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 200,),
            Center(child: Text("Welcome! to QUIZ ",style: GoogleFonts.lato(fontWeight:FontWeight.w700,fontSize:23,color:Colors.white),)),
            SizedBox(height: 200,),
            InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QuizScreen()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pink
                ),
                child:  Center(child: Text("Let's Begin",style: GoogleFonts.poppins(fontWeight:FontWeight.w700,fontSize:23,color:Colors.white),)),
              ),
            )
          ],
        ),
      ));
  }
}
