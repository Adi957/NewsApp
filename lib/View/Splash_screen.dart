import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TOP HEADLINES and LATEST NEWS',
                style: GoogleFonts.anton(
                  letterSpacing: .55,
                  color: Colors.grey.shade700,
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Image.asset(
                'images/splash_pic.jpg', 
                fit: BoxFit.cover,
                width: width * 0.9,
                height: height * 0.5,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                'NEWS:- North East West South ',
                style: GoogleFonts.anton(
                  letterSpacing: .6,
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              const SpinKitChasingDots(color: Colors.blue, size: 50),
            ],
          ),
        ),
      ),
    );
  }
}
