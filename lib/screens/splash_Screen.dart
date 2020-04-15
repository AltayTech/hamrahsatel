import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Products.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/splashscreen.dart';

import 'navigation_bottom_screen.dart';

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context, listen: false).fetchAndSetHomeData();
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new NavigationBottomScreen(),
      title: new Text(
        ' فروشگاه آنلاین ',
        style: new TextStyle(
          fontFamily: 'BFarnaz',
          fontSize: MediaQuery.of(context).textScaleFactor * 30,
          color: Colors.white,
        ),
      ),
      loadingText: Text(
        EnArConvertor().replaceArNumber('نسخه 1.2'),
        style: new TextStyle(
          fontFamily: 'Iransans',
          fontWeight: FontWeight.w400,
          fontSize: MediaQuery.of(context).textScaleFactor * 18,
          color: Colors.white,
        ),
      ),
      image: new Image.asset(
        'assets/images/logo_splash.png',
        fit: BoxFit.cover,
      ),
      gradientBackground: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xff006DB5),
          Color(0xff008AB5),
          Color(0xff01A89E),
        ],
      ),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 70.0,
      onClick: () => print("Flutter Egypt"),
    );
  }
}