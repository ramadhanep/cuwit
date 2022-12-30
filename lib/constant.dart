// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const baseURL = 'https://cuwit.dyvue.com/api';
// const baseURL = 'http://192.168.0.102:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// ----- Colors -----
const ThemeColorPrimary = Color(0xFF4B7BEC);
const ThemeColorWhite = Color(0xFFF5F6FA);
const ThemeColorBlack = Color(0xFF000000);
const ThemeColorRed = Color(0xFFFF3F34);
const ThemeColorGray = Color(0xFF9AA0A6);
const ThemeColorOverlay = Color(0xFFEEEEEE);

// ----- Fonts -----
TextStyle ThemeStyleFontHeader = GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), color: ThemeColorBlack);
TextStyle ThemeStyleFontTitle = GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700), color: ThemeColorBlack);
TextStyle ThemeStyleFontSubtitle = GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700), color: ThemeColorBlack);
TextStyle ThemeStyleFontParagraph = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12), color: ThemeColorBlack);
TextStyle ThemeStyleFontParagraphDisable = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12), color: ThemeColorGray);
TextStyle ThemeStyleFontLink = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12), color: ThemeColorPrimary);
TextStyle ThemeStyleFontBtn = GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700), color: ThemeColorWhite);
TextStyle ThemeStyleFontCardTitle = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), color: ThemeColorBlack);
TextStyle ThemeStyleFontCardOption = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400), color: ThemeColorBlack);
TextStyle ThemeStyleFontAvatar = GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700), color: ThemeColorPrimary);
TextStyle ThemeStyleFontAvatarProfile = GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700), color: ThemeColorPrimary);
TextStyle ThemeStyleFontFormName = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600), color: ThemeColorBlack);
TextStyle ThemeStyleFontLogout = GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), color: ThemeColorRed);

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
      filled: true,
      fillColor: ThemeColorOverlay,
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: ThemeColorPrimary)),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0));
}
InputDecoration kInputCuwitDecoration(String label) {
  return InputDecoration(
      hintText: label,
      border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      filled: true,
      fillColor: ThemeColorOverlay,
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: ThemeColorPrimary)),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0));
}

// button

ElevatedButton kTextButton(String label, Function onPressed) {
  return ElevatedButton(
    child: Text(
      label,
      style: ThemeStyleFontBtn,
    ),
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)
          )
        ),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => ThemeColorPrimary),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0))),
    onPressed: () => onPressed(),
  );
}

ElevatedButton kIconButton(Icon icon, String label, Function onPressed) {
  return ElevatedButton.icon(
    icon: icon,
    label: Text(
      label,
      style: ThemeStyleFontBtn,
    ),
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)
          )
        ),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => ThemeColorPrimary),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0))),
    onPressed: () => onPressed(),
  );
}

// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text, style: ThemeStyleFontParagraph),
      GestureDetector(
          child: Text(label, style: ThemeStyleFontLink),
          onTap: () => onTap())
    ],
  );
}

// welcomeHint
Row kWelcomeHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(text, style: ThemeStyleFontParagraph),
      GestureDetector(
          child: Text(label, style: ThemeStyleFontLink),
          onTap: () => onTap())
    ],
  );
}

// likes and comment btn

Container kLikeAndComment(
    int value, IconData icon, Color color, Function onTap) {
  return Container(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.0,
                color: color,
              ),
              SizedBox(width: 4.0),
              Text('$value', style: ThemeStyleFontCardOption)
            ],
          ),
        ),
      ),
    ),
  );
}
