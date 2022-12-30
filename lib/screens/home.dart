import 'package:cuwit/constant.dart';
import 'package:cuwit/screens/post_form.dart';
import 'package:cuwit/screens/post_screen.dart';
import 'package:cuwit/screens/profile.dart';
import 'package:cuwit/screens/welcome.dart';
import 'package:cuwit/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: Column(
          children: [
            SizedBox(height: 8.0),
            ClipRRect(
              child: Image.asset(
                "lib/images/cuwit.png",
                width: 35.0,
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: Text(
          'Cuwit',
          style: ThemeStyleFontHeader,
        ),
        shape: Border(
          bottom: BorderSide(
            color: ThemeColorOverlay,
            width: 0.5
          )
        ),
      ),
      body: currentIndex == 0 ? PostScreen() : Profile(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PostForm(
                    title: 'Add new cuwit',
                  )));
        },
        child: Icon(FontAwesomeIcons.feather),
        backgroundColor: ThemeColorPrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          fixedColor: ThemeColorPrimary,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.home,
                  size: 20.0,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.userAlt,
                  size: 20.0,
                ),
                label: '')
          ],
          currentIndex: currentIndex,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
