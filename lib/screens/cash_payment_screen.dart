import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/app_theme.dart';
import '../models/customer.dart';
import '../models/product_cart.dart';
import '../provider/Products.dart';
import '../customer_info.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/main_drawer.dart';

class CashPaymentScreen extends StatefulWidget {
  static const routeName = '/cash_payment_screen';

  @override
  _CashPaymentScreenState createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
//      await Provider.of<CustomerInfo>(context, listen: false).getCustomer();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      print(('adasd' + url));

      await launch(url);
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      print(('adasd2' + url));
      throw 'Could not launch $url';
    }
  }

  Future<void> submitCashPayment() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<CustomerInfo>(context, listen: false).sendNaghdOrder();
    int orderId = await Provider.of<CustomerInfo>(context, listen: false).currentOrderId;
    print(orderId);
    await Provider.of<CustomerInfo>(context, listen: false)
        .payCashOrder(orderId);
    String _payUrl = await Provider.of<CustomerInfo>(context, listen: false).payUrl;
    print('1' + _payUrl);
    _launchURL(_payUrl);

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    Customer customer = Provider.of<CustomerInfo>(context, listen: false).customer;
    List<ProductCart> shoppItems = Provider.of<Products>(context, listen: false).cartItems;
    double totalPrice = 0;
    if (shoppItems.isNotEmpty) {
      for (int i = 0; i < shoppItems.length; i++) {
        shoppItems[i].price.isNotEmpty
            ? totalPrice = totalPrice +
                int.parse(shoppItems[i].price) * shoppItems[i].productCount
            : totalPrice = totalPrice;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Builder(
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                height: deviceHeight * 0.35,
                child: Image.asset(
                  'assets/images/cash_pay_header.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: deviceHeight * 0.1,
                left: deviceWidth * 0.1,
                child: Text(
                  'پرداخت نقدی',
                  style: TextStyle(
                      color: AppTheme.bg,
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: deviceHeight * 0.22,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: deviceHeight * 0.5,
                    width: deviceWidth * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              color: AppTheme.primary),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              child: Text(
                                'اطلاعات ارسال محصول',
                                style: TextStyle(
                                  color: AppTheme.bg,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppTheme.h1, width: 0.3),
                              color: AppTheme.bg),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        'نام و نام خانوادگی:    ',
                                        style: TextStyle(
                                          color: AppTheme.secondary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      Text(
                                        customer.personal_data.first_name +
                                            ' ' +
                                            customer.personal_data.last_name,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        'استان:    ',
                                        style: TextStyle(
                                          color: AppTheme.secondary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      Text(
                                        customer.personal_data.ostan,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        'شهر:   ',
                                        style: TextStyle(
                                          color: AppTheme.secondary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      Text(
                                        customer.personal_data.city,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        'آدرس:    ',
                                        style: TextStyle(
                                          color: AppTheme.secondary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      Text(
                                        customer.personal_data.address,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        'کدپستی:    ',
                                        style: TextStyle(
                                          color: AppTheme.secondary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      Text(
                                        customer.personal_data.postcode,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Wrap(
                                    children: <Widget>[
                                      Text(
                                        'همراه:    ',
                                        style: TextStyle(
                                          color: AppTheme.secondary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      Text(
                                        EnArConvertor().replaceArNumber(
                                            (customer.personal_data.phone
                                                    .toString())
                                                .toString()),
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'مبلغ قابل پرداخت (تومان): ',
                                style: TextStyle(
                                  color: AppTheme.secondary,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 14,
                                ),
                              ),
                              Text(
                                EnArConvertor().replaceArNumber(currencyFormat
                                    .format(totalPrice)
                                    .toString()),
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 18,
                                ),
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: deviceHeight * 0.08,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                          // has the effect of softening the shadow
                          spreadRadius: 1.50,
                          // has the effect of extending the shadow
                          offset: Offset(
                            1.0, // horizontal, move right 10
                            1.0, // vertical, move down 10
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (totalPrice == 0) {
                            var _snackBarMessage = 'محصولی وجود ندارد!';
                            final addToCartSnackBar = SnackBar(
                              content: Text(
                                _snackBarMessage,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 14.0,
                                ),
                              ),
                              action: SnackBarAction(
                                label: 'متوجه شدم',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            Scaffold.of(context)
                                .showSnackBar(addToCartSnackBar);
                          } else {
                            submitCashPayment();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'پرداخت نقدی',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                height: deviceHeight * 0.8,
                width: deviceWidth,
                child: Align(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? SpinKitFadingCircle(
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      index.isEven ? Colors.grey : Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container()),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
