import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../classes/app_theme.dart';
import '../screens/customer_info/customer_favorite_screen.dart';
import '../screens/customer_info/customer_notification_screen.dart';
import '../screens/customer_info/customer_orders_screen.dart';
import '../screens/customer_info/customer_user_info_screen.dart';

import '../models/customer.dart';
import '../provider/auth.dart';
import '../provider/customer_info.dart';
import '../screens/customer_info/login_screen.dart';
import 'en_to_ar_number_convertor.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var _isLoading = false;
  bool _isInit = true;

  Future<void> cashOrder() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<CustomerInfo>(context, listen: false).getCustomer();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cashOrder();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<Auth>(context).isAuth;

    double deviceSizeWidth = MediaQuery.of(context).size.width;
    double deviceSizeHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    Customer customer = Provider.of<CustomerInfo>(context).customer;

    return !isLogin
        ? Container(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('شما وارد نشده اید'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'ورود به اکانت کاربری',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            width: deviceSizeWidth,
            height: deviceSizeHeight,
            child: Align(
              alignment: Alignment.center,
              child: _isLoading
                  ? SpinKitFadingCircle(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index.isEven ? Colors.grey : Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: deviceSizeWidth,
                      height: deviceSizeHeight,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              width: double.infinity,
                              child: Image.asset(
                                'assets/images/login_header1.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            top: deviceSizeHeight * 0.08,
                            width: deviceSizeWidth,
                            child: Icon(
                              Icons.phone_iphone,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          Positioned(
                            top: deviceSizeHeight * 0.14,
                            width: deviceSizeWidth,
                            child: Text(
                              customer.personal_data.phone != null
                                  ? EnArConvertor().replaceArNumber(
                                      (customer.personal_data.phone.toString())
                                          .toString())
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 24.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: deviceSizeHeight * 0.20,
                            width: deviceSizeWidth,
                            child: Center(
                              child: Container(
                                height: deviceSizeHeight * 0.09,
                                width: deviceSizeHeight * 0.09,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff8A81F0),
                                      Color(0xff0BD9F4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Container(
                                  child: Image.asset(
                                    'assets/images/user_Icon.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: deviceSizeHeight * 0.30,
                              height: deviceSizeHeight * 0.52,
                              width: deviceSizeWidth,
                              child: GridView(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          CustomerOrdersScreen.routeName);
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),

                                                  blurRadius: 10.10,
                                                  // has the effect of softening the shadow
                                                  spreadRadius: 10.510,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0, // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/images/orders_list.png',
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'سفارش',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppTheme.primary,
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 24.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          CustomerUserInfoScreen.routeName);
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),

                                                  blurRadius: 10.10,
                                                  // has the effect of softening the shadow
                                                  spreadRadius: 10.510,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0, // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/images/user_Icon.png',
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: FittedBox(
                                                  child: Text(
                                                    'اطلاعات شخصی',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: AppTheme.primary,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor *
                                                              16.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          CustomerNotificationScreen.routeName);
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),

                                                  blurRadius: 10.10,
                                                  // has the effect of softening the shadow
                                                  spreadRadius: 10.510,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0, // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/images/message_icon.png',
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'پیام ها',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppTheme.primary,
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 24.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          CustomerFavoriteScreen.routeName);
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),

                                                  blurRadius: 10.10,
                                                  // has the effect of softening the shadow
                                                  spreadRadius: 10.510,
                                                  // has the effect of extending the shadow
                                                  offset: Offset(
                                                    0, // horizontal, move right 10
                                                    0, // vertical, move down 10
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 35,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'علایق',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppTheme.primary,
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 24.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                              )
//
                              ),
//
                        ],
                      ),
                    ),
            ),
          );
  }
}
