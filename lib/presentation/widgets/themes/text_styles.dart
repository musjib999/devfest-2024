import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTextStyle {
  static TextStyle title = GoogleFonts.poppins(
    fontSize: 29,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle appTitle = GoogleFonts.racingSansOne(
    fontSize: 20,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle headline = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static TextStyle buttonTitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  static TextStyle label = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
}

Widget labelText(String label) {
  return Text(
    label,
    style: AppTextStyle.label,
  );
}
