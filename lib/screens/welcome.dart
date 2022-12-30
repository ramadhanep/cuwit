import 'package:cuwit/constant.dart';
import 'package:cuwit/screens/login.dart';
import 'package:cuwit/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          title: Text(
            'Selamat Datang',
            style: ThemeStyleFontHeader,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              ClipRRect(
                child: Image.asset(
                  "lib/images/cuwit.png",
                  width: 60.0,
                ),
              ),
              SizedBox(height: 40.0),
              Text('"Kebebasan berbicara itu gratis, Bukan bayar subscription!"',
                  style: ThemeStyleFontTitle),
              SizedBox(height: 25.0),
              Text("Ceo of Cuwit",
                  style: ThemeStyleFontParagraphDisable),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  kTextButton('Daftar sekarang', () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return Register();
                    }));
                  }),
                ],
              ),
              Spacer(),
              kWelcomeHint('Sudah memiliki akun? ', 'Log in', () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return Login();
                }));
              }),
              SizedBox(height: 15.0),
            ],
          ),
        ));
  }
}
