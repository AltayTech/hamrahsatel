import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/app_theme.dart';
import '../models/product_cart.dart';
import '../provider/Products.dart';
import '../screens/enter_cheque_screen.dart';
import '../widgets/commission_calculator.dart';
import '../widgets/main_drawer.dart';
import '../widgets/qest_calculation.dart';

class CreditPaymentScreen extends StatefulWidget {
  static const routeName = '/credit_payment_screen';

  @override
  _CreditPaymentScreenState createState() => _CreditPaymentScreenState();
}

class _CreditPaymentScreenState extends State<CreditPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
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
    Provider.of<CommissionCalculator>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: deviceWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'پرداخت اقساطی',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 14,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Card(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: deviceWidth,
                              child: Text(
                                'مراحل خرید اقساطی',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 12,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.arrow_right),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: Text(
                                      'خرید اقساطی تنها از طریق ارائه دسته چک امکان پذیر است.',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.arrow_right),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: Text(
                                      'پس از ارسال شناسه 16 رقمی چک صیادی و تایید آن توسط ما، شما می توانید محصولتان را به صورت اقساطی از ما بخرید.',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.arrow_right),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: Text(
                                      'مشتری در تعیین تعداد اقساط و فاصله ما بین اقساط کاملا آزاد است.',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12,
                                      ),
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.arrow_right),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: Text(
                                      'کارمزد خرید اقساطی به ازای هر ماه 5 درصد است. در صورتی که مقدار پیش پرداخت بیشتر از 50% کل خرید باشد و مدت زمان بازپرداخت اقساط کمتر از 6 ماه باشد، کارمزد خرید اقساطی 4 درصد است.',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12,
                                      ),
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.warning, color: Colors.deepOrange),
                          ),
                          Expanded(
                            child: Text(
                              'در حال حاضر خرید اقساطی تنها برای مشتریان ساکن در شهر تبریز امکان پذیر است. امیدوارم به زودی این امکان را برای سایر شهرها هم میسر سازیم.',
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 12,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    'تعیین اقساط خرید اقساطی',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 15,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 0.2)),
                    child: QestCalculation(0.toString()),
                  ),
                ),
//              QestCalculation(totalPrice.toString()),

                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: deviceHeight * 0.08,
                    decoration: BoxDecoration(
                      color: Color(0xff3F9B12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          print('qest1');

                          if (totalPrice == 0) {
                            print('qest2');

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
                            print('qest');
                            Navigator.pushNamed(
                                context, EnterChequeScreen.routeName);
                            Navigator.of(context).pop();
                          }

                          Navigator.pushNamed(
                              context, EnterChequeScreen.routeName);
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'ادامه',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
