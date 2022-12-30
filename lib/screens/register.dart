import 'package:cuwit/models/api_response.dart';
import 'package:cuwit/models/user.dart';
import 'package:cuwit/screens/home.dart';
import 'package:cuwit/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cuwit/constant.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 24,
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: ThemeColorBlack,
            size: 20.0,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Register',
          style: ThemeStyleFontHeader,
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            Center(
              child: ClipRRect(
                child: Image.asset(
                  "lib/images/cuwit.png",
                  width: 60.0,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            TextFormField(
                controller: nameController,
                validator: (val) => val!.isEmpty ? 'Nama tidak valid' : null,
                decoration: kInputDecoration('Nama')),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val!.isEmpty ? 'Alamat email salah' : null,
                decoration: kInputDecoration('Email')),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Diperlukan setidaknya 6 karakter' : null,
                decoration: kInputDecoration('Password')),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: passwordConfirmController,
                obscureText: true,
                validator: (val) => val != passwordController.text
                    ? 'Konfirmasi password tidak cocok'
                    : null,
                decoration: kInputDecoration('Konfirmasi password')),
            SizedBox(
              height: 20,
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : kTextButton(
                    'Daftar',
                    () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = !loading;
                          _registerUser();
                        });
                      }
                    },
                  ),
            SizedBox(
              height: 20.0,
            ),
            kLoginRegisterHint('Sudah memiliki akun? ', 'Log in', () {
              Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Login();
                }));
            })
          ],
        ),
      ),
    );
  }
}
