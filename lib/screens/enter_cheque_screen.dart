import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../provider/customer_info.dart';
import '../widgets/commission_calculator.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/main_drawer.dart';
import 'navigation_bottom_screen.dart';

class EnterChequeScreen extends StatefulWidget {
  static const routeName = '/enter_cheque_screen';

  @override
  _EnterChequeScreenState createState() => _EnterChequeScreenState();
}

class _EnterChequeScreenState extends State<EnterChequeScreen>
    with SingleTickerProviderStateMixin {
  final _bankController = TextEditingController();
  final _branchController = TextEditingController();
  final _ownerController = TextEditingController();
  final _chequeShenasehController = TextEditingController();

  FocusNode bankFocusNode;
  FocusNode branchFocusNode;
  FocusNode ownerFocusNode;
  FocusNode chequeShenasehFocusNode;

  var _isAgree = false;

  var _agreementCheckBox = FocusNode();

  var _checkBox = GlobalKey();

  Color _checkBoxColor = Colors.white;

  bool _isShenaseh = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = false;

  var _isShenasehValide = true;
  var _isownerValide = true;
  var _isBranchValide = true;
  var _isBankValide = true;

  @override
  void initState() {
    bankFocusNode = FocusNode();
    branchFocusNode = FocusNode();
    ownerFocusNode = FocusNode();
    chequeShenasehFocusNode = FocusNode();
    _bankController.text;
    _branchController.text;
    _ownerController.text;
    _chequeShenasehController.text;
    super.initState();
  }

  @override
  void dispose() {
    _bankController.dispose();
    _branchController.dispose();
    _ownerController.dispose();
    _chequeShenasehController.dispose();
    bankFocusNode.dispose();
    branchFocusNode.dispose();
    ownerFocusNode.dispose();
    chequeShenasehFocusNode.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('مشکل در ورود'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('تایید'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showLogindialog_exit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (ctx) => CustomDialog(
          title: 'کاربر گرامی',
          buttonText: 'متوجه شدم ',
          description: 'شما با موفقیت از اکانت کاربری خارج شدید',
        ),
      );
    });
  }

  Future<void> _submit(int qestCount, int monthCount, double deposit) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!

      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isAgree) {
        print(qestCount.toString());
        print(monthCount.toString());
        print(deposit.toString());
        print(_bankController.text.toString());
        print(_branchController.text.toString());
        print(_ownerController.text.toString());
        print(_chequeShenasehController.text.toString());
        await Provider.of<CustomerInfo>(context, listen: false).sendAqsatOrder(
            number_pay: qestCount.toString(),
            month_per_ghest: monthCount.toString(),
            deposit: deposit.toString(),
            bank: _bankController.text,
            branch: _branchController.text,
            owner: _ownerController.text,
            shenaseh: _chequeShenasehController.text);
        Navigator.of(context).pushNamed(NavigationBottomScreen.routeName);
      } else {
        setState(() {
          _checkBoxColor = Colors.red;
        });
        FocusScope.of(context).requestFocus(_agreementCheckBox);
        SnackBar addToCartSnackBar = SnackBar(
          content: Text(
            'ابتدا باید شرایط را تایید نمایید.',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Iransans',
//            fontSize: textScaleFactor * 14.0,
            ),
          ),
          action: SnackBarAction(
            label: 'متوجه شدم',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        Scaffold.of(context).showSnackBar(addToCartSnackBar);
      }
    } catch (error) {
      const errorMessage = 'ارتباط برقرار نشد، لطفا دوباره تلاش کنید.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    List<int> qestTimeList =
        Provider.of<CommissionCalculator>(context).qestTiming;
    double commissionPerQest =
        Provider.of<CommissionCalculator>(context).commissionPerQest;
    double pricePerQest = Provider.of<CommissionCalculator>(context).qest;
    int qestCount = Provider.of<CommissionCalculator>(context).qestCount;
    int monthCount = Provider.of<CommissionCalculator>(context).monthCount;

    double deposit = Provider.of<CommissionCalculator>(context).deposit;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Builder(
        builder: (context) => Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      color: Color(0xffF9F9F9),
                      width: deviceWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'تایید اقساطی',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 14,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.bg,
                          border: Border.all(
                            color: AppTheme.secondary,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'لطفا بار دیگر جدول خرید اقساط را بررسی کنید. سپس شناسه 16 رقمی چک صیادی را وارد نمایید.',
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
                    Wrap(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'زمان پرداخت',
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: Colors.grey,
                                    fontSize: textScaleFactor * 10.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'مبلغ(تومان)',
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: Colors.grey,
                                    fontSize: textScaleFactor * 10.0,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'کارمزد (تومان)',
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: Colors.grey,
                                    fontSize: textScaleFactor * 10.0,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    '#',
                                    style: TextStyle(
                                      fontFamily: 'Iransans',
                                      color: Colors.grey,
                                      fontSize: textScaleFactor * 10.0,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: qestTimeList.length,
                          itemBuilder: (ctx, index) {
                            return QestItem(
                              index: index,
                              number: (index + 1).toString(),
                              qestPrice: pricePerQest,
                              commissionPerQest: commissionPerQest,
                              timming: qestTimeList[index],
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: deviceHeight * 0.13,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.secondary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'مبلغ نهایی \n (تومان)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                    Consumer<CommissionCalculator>(
                                      builder: (_, commissionData, ch) => Text(
                                        EnArConvertor().replaceArNumber(
                                            currencyFormat
                                                .format(
                                                    commissionData.finalPrice)
                                                .toString()),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 15,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.secondary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'کارمزد کل \n (تومان)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                    Consumer<CommissionCalculator>(
                                      builder: (_, commissionData, ch) => Text(
                                        EnArConvertor().replaceArNumber(
                                            currencyFormat
                                                .format(commissionData
                                                    .finalCommission)
                                                .toString()),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 15,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.secondary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'مبلغ سفارش \n (تومان)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                    Consumer<CommissionCalculator>(
                                      builder: (_, commissionData, ch) => Text(
                                        EnArConvertor().replaceArNumber(
                                            currencyFormat
                                                .format(
                                                    commissionData.totalPrice)
                                                .toString()),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppTheme.primary,
                                          fontFamily: 'IransansNonEn',
                                          fontSize: textScaleFactor * 15,
                                        ),
                                        overflow: TextOverflow.clip,
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
                    Divider(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Wrap(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'ورود اطلاعات چک',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'IransansNonEn',
                                fontSize: textScaleFactor * 15,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'در تصویر ذیل محل شناسه 16 رقمی چک صیادی آمده است',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: 'IransansNonEn',
                                fontSize: textScaleFactor * 15,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/cheque.jpg',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppTheme.secondary,
                                                  width: 0.6)),
                                          height: _isBankValide
                                              ? deviceHeight * 0.05
                                              : deviceHeight * 0.07,
                                          child: TextFormField(
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        branchFocusNode),
                                            focusNode: bankFocusNode,
                                            controller: _bankController,
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                _isBankValide = false;
                                                return 'لطفا نام بانک را وارد نمایید';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'بانک',
                                          style: TextStyle(
                                            color: AppTheme.h1,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 12,
                                          ),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppTheme.secondary,
                                                  width: 0.6)),
                                          height: _isBranchValide
                                              ? deviceHeight * 0.05
                                              : deviceHeight * 0.07,
                                          child: TextFormField(
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        ownerFocusNode),
                                            focusNode: branchFocusNode,
                                            controller: _branchController,
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                _isBranchValide = false;
                                                return 'لطفا شعبه را وارد نمایید';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'شعبه',
                                          style: TextStyle(
                                            color: AppTheme.h1,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 12,
                                          ),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppTheme.secondary,
                                                  width: 0.6)),
                                          height: _isownerValide
                                              ? deviceHeight * 0.05
                                              : deviceHeight * 0.07,
                                          child: TextFormField(
                                            onFieldSubmitted: (_) => FocusScope
                                                    .of(context)
                                                .requestFocus(
                                                    chequeShenasehFocusNode),
                                            focusNode: ownerFocusNode,
                                            controller: _ownerController,
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                _isownerValide = false;
                                                return 'لطفا نام صاحب حساب را وارد نمایید';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'صاحب حساب',
                                          style: TextStyle(
                                            color: AppTheme.h1,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 12,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppTheme.secondary,
                                                  width: 0.6)),
                                          height: _isShenasehValide
                                              ? deviceHeight * 0.05
                                              : deviceHeight * 0.07,
                                          child: TextFormField(
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode()),
                                            focusNode: chequeShenasehFocusNode,
                                            keyboardType: TextInputType.number,
                                            controller:
                                                _chequeShenasehController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                _isShenasehValide = false;
                                                return 'لطفا شناسه 16 رقمی را وارد نمایید';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'شناسه 16 رقمی',
                                          style: TextStyle(
                                            color: AppTheme.h1,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 12,
                                          ),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.right,
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
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: _checkBoxColor, width: 1.5)),
                        height: deviceHeight * 0.06,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Checkbox(
                                key: _checkBox,
                                autofocus: true,
                                focusNode: _agreementCheckBox,
                                onChanged: (value) {
                                  _isAgree ? _isAgree = false : _isAgree = true;
                                  setState(() {});
                                },
                                value: _isAgree,
                              ),
                              Text(
                                'شرایط خرید اقساطی را قبول دارم',
                                style: TextStyle(
                                  color: AppTheme.h1,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 12,
                                ),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: deviceHeight * 0.08,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              _submit(qestCount, monthCount, deposit);
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  'تایید نهایی',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Iransans',
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            15.0,
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
            Positioned(
              height: deviceHeight * 0.8,
              left: 0,
              right: 0,
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
                      : Container()),
            ),
          ],
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

class QestItem extends StatelessWidget {
  const QestItem({
    Key key,
    @required this.index,
    @required this.number,
    @required this.qestPrice,
    @required this.commissionPerQest,
    @required this.timming,
  }) : super(key: key);

  final int index;
  final String number;
  final double qestPrice;
  final double commissionPerQest;
  final int timming;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: index.isEven ? Color(0xffF1F5FF) : Color(0xffE6E4E4),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Text(
                  timming.toString(),
                  style: TextStyle(
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  EnArConvertor().replaceArNumber(
                      currencyFormat.format(qestPrice).toString()),
                  style: TextStyle(
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Expanded(
                child: Text(
                  EnArConvertor().replaceArNumber(
                      currencyFormat.format(commissionPerQest).toString()),
                  style: TextStyle(
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 14.0,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    number,
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 11.0,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
