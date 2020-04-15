import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../provider/auth.dart';
import '../provider/customer_info.dart';
import '../widgets/custom_dialog_enter.dart';
import '../widgets/custom_dialog_profile.dart';

import '../classes/app_theme.dart';
import '../models/product_cart.dart';
import '../provider/Products.dart';
import '../screens/cash_payment_screen.dart';
import '../screens/credit_payment_screen.dart';
import '../widgets/card_item.dart';
import '../widgets/commission_calculator.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/main_drawer.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart_screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProductCart> shoppItems = [];
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  bool _isInit = true;

  var _isLoading = true;
  Customer customer;

  void _showLogindialog() {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialogEnter(
        title: 'ورود',
        buttonText: 'صفحه ورود ',
        description: 'برای ادامه باید وارد شوید',
      ),
    );
  }

  void _showCompletedialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogProfile(
              title: 'اطلاعات کاربری',
              buttonText: 'صفحه پروفایل ',
              description: 'برای ادامه باید اطلاعات کاربری تکمیل کنید',
            ));
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      Provider.of<CustomerInfo>(context, listen: false).getCustomer().then((_) {
        bool isLogin = Provider.of<Auth>(context).isAuth;
        if (isLogin) {
          customer = Provider.of<CustomerInfo>(context).customer;
          print(customer.personal_data.personal_data_complete.toString());
        }
      });
      _isLoading = false;
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    bool isLogin = Provider.of<Auth>(context).isAuth;

    shoppItems = Provider.of<Products>(context).cartItems;
    int totalPrice = 0;
    int transportCost = 10000;
    if (shoppItems.isNotEmpty) {
      for (int i = 0; i < shoppItems.length; i++) {
        shoppItems[i].price_low.isNotEmpty
            ? totalPrice = totalPrice + int.parse(shoppItems[i].price_low)
            : shoppItems[i].price.isNotEmpty
                ? totalPrice = totalPrice + int.parse(shoppItems[i].price)
                : totalPrice = totalPrice;
      }
    }
    int totalPricePure = totalPrice + transportCost;

    Provider.of<CommissionCalculator>(context).totalPrice = totalPrice;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Builder(builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: deviceHeight * 0.07,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.grey, width: 0.2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.shopping_cart,
                                  color: AppTheme.primary,
                                ),
                                Text(
                                  'تعداد: ' +
                                      EnArConvertor()
                                          .replaceArNumber(
                                              shoppItems.length.toString())
                                          .toString(),
                                  style: TextStyle(
                                    color: AppTheme.h1,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 12,
                                  ),
                                ),
                                VerticalDivider(
                                  color: AppTheme.h1,
                                  thickness: 1,
                                  indent: 4,
                                  endIndent: 4,
                                ),
                                Text(
                                  'مبلغ قابل پرداخت (تومان)',
                                  style: TextStyle(
                                    color: AppTheme.h1,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 12,
                                  ),
                                ),
                                Text(
                                  totalPrice.toString().isNotEmpty
                                      ? EnArConvertor().replaceArNumber(
                                          currencyFormat
                                              .format(totalPrice)
                                              .toString())
                                      : EnArConvertor().replaceArNumber('0'),
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: (shoppItems.length != 0)
                              ? Container(
                                  child: ListView.builder(
                                    key: listKey,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: shoppItems.length,
                                    itemBuilder: (ctx, i) => CardItem(
                                      index: i,
                                      shoppItems: shoppItems,
                                    ),
                                  ),
                                )
                              : Center(child: Text('محصولی اضافه نشده است')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'فاکتور فروش ',
                                    style: TextStyle(
                                      color: AppTheme.h1,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 12,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'مبلغ (تومان)',
                                    style: TextStyle(
                                      color: AppTheme.h1,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2)),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'هزینه محصولات ',
                                            style: TextStyle(
                                              color: AppTheme.h1,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 12,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            totalPrice.toString().isNotEmpty
                                                ? EnArConvertor()
                                                    .replaceArNumber(
                                                        currencyFormat
                                                            .format(totalPrice)
                                                            .toString())
                                                : EnArConvertor()
                                                    .replaceArNumber('0'),
                                            style: TextStyle(
                                              color: AppTheme.h1,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'حمل و نقل ',
                                            style: TextStyle(
                                              color: AppTheme.h1,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 12,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            transportCost.toString().isNotEmpty
                                                ? EnArConvertor()
                                                    .replaceArNumber(
                                                        currencyFormat
                                                            .format(
                                                                transportCost)
                                                            .toString())
                                                : EnArConvertor()
                                                    .replaceArNumber('0'),
                                            style: TextStyle(
                                              color: AppTheme.h1,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'هزینه کل ',
                                            style: TextStyle(
                                              color: AppTheme.h1,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 12,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            totalPricePure.toString().isNotEmpty
                                                ? EnArConvertor()
                                                    .replaceArNumber(
                                                        currencyFormat
                                                            .format(
                                                                totalPricePure)
                                                            .toString())
                                                : EnArConvertor()
                                                    .replaceArNumber('0'),
                                            style: TextStyle(
                                              color: AppTheme.primary,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: deviceHeight * 0.07,
                      decoration: BoxDecoration(
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
                        color: shoppItems.isEmpty
                            ? AppTheme.text
                            : AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                SnackBar addToCartSnackBar = SnackBar(
                                  content: Text(
                                    'سبد خرید خالی می باشد!',
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
                                if (shoppItems.isEmpty) {
                                  Scaffold.of(context)
                                      .showSnackBar(addToCartSnackBar);
                                } else if (!isLogin) {
                                  _showLogindialog();
                                } else {
                                  if (customer
                                      .personal_data.personal_data_complete) {
                                    Navigator.of(context)
                                        .pushNamed(CashPaymentScreen.routeName);
                                  } else {
                                    _showCompletedialog();
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'پرداخت نقدی',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 2,
                            indent: 6,
                            endIndent: 6,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                SnackBar addToCartSnackBar = SnackBar(
                                  content: Text(
                                    'سبد خرید خالی میباشد!',
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
                                if (shoppItems.isEmpty) {
                                  Scaffold.of(context)
                                      .showSnackBar(addToCartSnackBar);
                                } else if (!isLogin) {
                                  _showLogindialog();
                                } else {
                                  if (customer
                                      .personal_data.personal_data_complete) {
                                    Navigator.of(context).pushNamed(
                                        CreditPaymentScreen.routeName);
                                  } else {
                                    _showCompletedialog();
                                  }
                                }
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Icon(
                                        Icons.credit_card,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'پرداخت اقساطی',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 13.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                          alignment: Alignment.center,
                          child: _isLoading
                              ? SpinKitFadingCircle(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index.isEven
                                            ? Colors.grey
                                            : Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container()))
                ],
              ),
            ),
          ),
        );
      }),
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