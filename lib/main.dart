import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:review_my_answers/constants/colors.dart';
import 'package:review_my_answers/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
      ),
      home: const HomeScreen(),
    );
  }
}
