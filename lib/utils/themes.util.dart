import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _boxBackground = Color(0xFFFFFFFF);
const Color _textColor = Color(0xFF909090);
const Color _disabledColor = Color(0xFFB5B7BD);
const Color _primaryColor = Color(0xFF232C3A);

const Color _darkBackground = Color(0xFF363636);
const Color _darkPrimaryColor = Colors.white;

class Themes {
  static ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: _darkBackground,
        fontFamily: GoogleFonts.poppins().fontFamily,
        iconTheme: IconThemeData(
          color: _darkPrimaryColor,
        ),
        appBarTheme: AppBarTheme(
          color: _darkBackground,
          elevation: 0,
          iconTheme: IconThemeData(),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _darkBackground,
          unselectedItemColor: _disabledColor,
          selectedItemColor: _darkPrimaryColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          unselectedLabelStyle: TextStyle(
            color: _disabledColor,
            fontWeight: FontWeight.bold,
          ),
          selectedLabelStyle: TextStyle(
            color: _darkPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          elevation: 5,
          color: _darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: _darkPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          bodyText1: TextStyle(
            fontWeight: FontWeight.bold,
            color: _darkPrimaryColor,
          ),
          bodyText2: TextStyle(
            color: _darkPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            primary: _darkPrimaryColor,
          ),
        ),
      );

  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: _boxBackground,
        fontFamily: GoogleFonts.poppins().fontFamily,
        iconTheme: IconThemeData(
          color: _primaryColor,
        ),
        appBarTheme: AppBarTheme(
          color: _boxBackground,
          elevation: 0,
          iconTheme: IconThemeData(),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: _boxBackground,
          unselectedItemColor: _disabledColor,
          selectedItemColor: _primaryColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          unselectedLabelStyle: TextStyle(
            color: _disabledColor,
            fontWeight: FontWeight.bold,
          ),
          selectedLabelStyle: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          elevation: 5,
          color: Themes.boxBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            primary: _primaryColor,
          ),
        ),
      );

  static Color get boxBackground => _boxBackground;
  static Color get textColor => _textColor;
  static Color get primaryColor => _primaryColor;
  static Color get darkPrimaryColor => _darkPrimaryColor;
  static Color get darkBackground => _darkBackground;
}
