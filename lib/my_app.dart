import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_contatos/pages/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor customColor = const MaterialColor(0xFFEC407A, {
      50: Color(0xFFFCE4EC),
      100: Color(0xFFF8BBD0),
      200: Color(0xFFF48FB1),
      300: Color(0xFFF06292),
      400: Color(0xFFEC407A),
      500: Color(0xFFE91E63), // Sua cor personalizada
      600: Color(0xFFD81B60),
      700: Color(0xFFC2185B),
      800: Color(0xFFAD1457),
      900: Color(0xFF880E4F),
    });
    return MaterialApp(
      home: const MainPage(),
      theme: ThemeData(
          primarySwatch: customColor, textTheme: GoogleFonts.robotoTextTheme()),
      debugShowCheckedModeBanner: false,
    );
  }
}
