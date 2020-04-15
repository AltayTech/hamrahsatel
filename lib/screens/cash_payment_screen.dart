import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../widgets/cash_payment_product_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/app_theme.dart';
import '../models/customer.dart';
import '../models/product_cart.dart';
import '../provider/Products.dart';
import '../provider/customer_info.dart';
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
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    if (_isInit) {
      await Provider.of<CustomerInfo>(context, listen: false).getCustomer();
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
    int orderId = await Provider.of<CustomerInfo>(context).currentOrderId;
    print(orderId);
    await Provider.of<CustomerInfo>(context, listen: false)
        .payCashOrder(orderId);
    String _payUrl = await Provider.of<CustomerInfo>(context).payUrl;
    print('1' + _payUrl);
    _launchURL(_payUrl);

//    Navigator.of(context).pop();

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

    Customer customer = Provider.of<CustomerInfo>(context).customer;
    List<ProductCart> shoppItems = Provider.of<Products>(context).cartItems;
    double totalPrice = 0;
    if (shoppItems.isNotEmpty) {
      for (int i = 0; i < shoppItems.length; i++) {
        shoppItems[i].price_low.isNotEmpty
            ? totalPrice = totalPrice + int.parse(shoppItems[i].price_low)
            : shoppItems[i].price.isNotEmpty
                ? totalPrice = totalPrice + int.parse(shoppItems[i].price)
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
              Container(
                  color: Color(0xffF9F9F9),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: <Widget>[
                          Container(
                            height: deviceHeight * 0.75,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'پرداخت نقدی',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'محصولات',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 12,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          'تعداد: ' +
                                              EnArConvertor().replaceArNumber(
                                                  shoppItems.length.toString()),
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.grey,
                                                width: 0.2)),
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: shoppItems.length,
                                          itemBuilder: (ctx, i) {
                                            return CashPaymentProductItem(
                                              id: shoppItems[i].id,
                                              title: shoppItems[i].title,
                                              color_selected:
                                                  shoppItems[i].color_selected,
                                              price: shoppItems[i].price,
                                              price_low:
                                                  shoppItems[i].price_low,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'اطلاعات ارسال محصول',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 12,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Container(
                                      width: double.infinity,
                                      color: Color(0xffEEF4FE),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    'نام و نام خانوادگی: ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    customer.personal_data
                                                            .first_name +
                                                        ' ' +
                                                        customer.personal_data
                                                            .last_name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
//                                            Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    'استان: ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    customer
                                                        .personal_data.ostan,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    'شهر: ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    customer.personal_data.city,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
//                                            Divider(),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    'آدرس: ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    customer
                                                        .personal_data.address,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
//                                            Divider(),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    'کدپستی: ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    customer
                                                        .personal_data.postcode,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
//                                            Divider(),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Text(
                                                    'همراه: ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    EnArConvertor()
                                                        .replaceArNumber((customer
                                                                .personal_data
                                                                .phone
                                                                .toString())
                                                            .toString()),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor * 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
//                                            Divider(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          'مبلغ قابل پرداخت (تومان): ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 14,
                                          ),
                                        ),
                                        Text(
                                          EnArConvertor().replaceArNumber(
                                              currencyFormat
                                                  .format(totalPrice)
                                                  .toString()),
                                          style: TextStyle(
                                            color: Colors.red,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: deviceHeight * 0.08,
                              decoration: BoxDecoration(
                                color: Color(0xff3F9B12),
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
                                      var _snackBarMessage =
                                          'محصولی وجود ندارد!';
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
                        ],
                      ),
                    ),
                  )),
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
