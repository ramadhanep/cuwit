import 'dart:io';

import 'package:cuwit/models/api_response.dart';
import 'package:cuwit/models/user.dart';
import 'package:cuwit/screens/welcome.dart';
import 'package:cuwit/services/user_service.dart';
import 'package:flutter/material.dart';

import 'package:cuwit/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  TextEditingController txtNameController = TextEditingController();

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Welcome();
            }))
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  //update profile
  void updateProfile() async {
    ApiResponse response = await updateUser(txtNameController.text);
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Welcome();
            }))
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: new BoxDecoration(
                          color: ThemeColorOverlay,
                          borderRadius: new BorderRadius.all(Radius.circular(100.0))
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${user!.name!.substring(0,2)!.toUpperCase()}', style: ThemeStyleFontAvatarProfile)
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text('${user!.name}', style: ThemeStyleFontSubtitle),
                      SizedBox(height: 5.0),
                      Text('${user!.email}', style: ThemeStyleFontParagraph)
                    ],
                  )
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.5,
                  color: ThemeColorOverlay,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Informasi Akun', style: ThemeStyleFontFormName),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: kInputDecoration('Nama'),
                    controller: txtNameController,
                    validator: (val) => val!.isEmpty ? 'Nama tidak valid' : null,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                kTextButton('Update', () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    updateProfile();
                  }
                }),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.5,
                  color: ThemeColorOverlay,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: InkWell(
                    child: Text('Log out', style: ThemeStyleFontLogout),
                    onTap: () {
                      logout().then((value) => {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Welcome();
                        }))
                      });
                    },
                  ),
                ),
                )
              ],
            ),
          );
  }
}
