import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hamrahsatel/classes/app_theme.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import 'commission_calculator.dart';
import 'en_to_ar_number_convertor.dart';

class QestCalculation extends StatefulWidget {
  final initialPrice;

  QestCalculation(this.initialPrice);

  @override
  _QestCalculationState createState() => _QestCalculationState();
}

class _QestCalculationState extends State<QestCalculation> {
  final _depositTextFieldController = TextEditingController();
  final _totalPriceTextFieldController = TextEditingController();

//  final lowPrice = //after

  var qestCountValue = '2';
  var monthCountValue = '1';

  final List<String> monthList = ['1', '2', '3', '4', '5', '6'];
  final List<String> qestList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  FocusNode totalPriceDocusNode;
  FocusNode depositDocusNode;

  String totalPrice = '0';
  var _isInit = true;

  @override
  void initState() {
    totalPriceDocusNode = FocusNode();
    depositDocusNode = FocusNode();
    _depositTextFieldController.text = '0';
    _totalPriceTextFieldController.text = '0';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _totalPriceTextFieldController.text =
          Provider.of<CommissionCalculator>(context, listen: false)
                  .totalPrice
                  .toString()
                  .isEmpty
              ? '0'
              : Provider.of<CommissionCalculator>(context, listen: false)
                  .totalPrice
                  .toString();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _depositTextFieldController.dispose();
    _totalPriceTextFieldController.dispose();
    totalPriceDocusNode.dispose();
    depositDocusNode.dispose();

    super.dispose();
  }

  String removeSemicolon(String rawString) {
//    for (int i = 0; i <= rawString.length; i++) {
    print(rawString);

    String newvalue = rawString.replaceAll(',', '');
    print(rawString);

//    }
    return newvalue;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    Provider.of<CommissionCalculator>(context, listen: false);
    List<int> qestTimeList =
        Provider.of<CommissionCalculator>(context).qestTiming;
    double commissionPerQest =
        Provider.of<CommissionCalculator>(context).commissionPerQest;
    double pricePerQest = Provider.of<CommissionCalculator>(context).qest;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    return SingleChildScrollView(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.secondary,
                            width: 0.6,
                          ),
                        ),
                        height: deviceHeight * 0.06,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(depositDocusNode),
                            focusNode: totalPriceDocusNode,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            controller: _totalPriceTextFieldController,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              // Fit the validating format.
                              //fazer o formater para dinheiro
                              new CurrencyInputFormatter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'مقدار کل سفارش (تومان)',
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
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.secondary,
                            width: 0.6,
                          ),
                        ),
                        height: deviceHeight * 0.06,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            focusNode: depositDocusNode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(FocusNode()),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.go,
                            controller: _depositTextFieldController,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              // Fit the validating format.
                              //fazer o formater para dinheiro
                              new CurrencyInputFormatter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'مقدار پیش پرداخت (تومان)',
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
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.secondary,
                            width: 0.6,
                          ),
                        ),
                        height: deviceHeight * 0.06,
                        alignment: Alignment.centerRight,
                        child: DropdownButton<String>(
                          itemHeight: deviceHeight * 0.1,
                          value: qestCountValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: TextStyle(
                            color: AppTheme.primary,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              qestCountValue = newValue;
                            });
                          },
                          items: qestList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'تعداد اقساط',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.secondary,
                            width: 0.6,
                          ),
                        ),
                        height: deviceHeight * 0.06,
                        alignment: Alignment.centerRight,
                        child: DropdownButton<String>(
                          value: monthCountValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: TextStyle(
                            color: AppTheme.primary,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              monthCountValue = newValue;
                            });
                          },
                          items: monthList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'پرداخت قسط هر .. ماه',
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
              Container(
                height: deviceHeight * 0.06,
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Provider.of<CommissionCalculator>(context,
                        listen: false)
                        .calculator(
                        int.parse(double.parse(removeSemicolon(
                            _totalPriceTextFieldController.text))
                            .toStringAsFixed(0)
                            .toString()),
                        double.parse(removeSemicolon(
                            _depositTextFieldController.text)),
                        int.parse(qestCountValue),
                        int.parse(monthCountValue));
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Center(
                    child: Text(
                      'محاسبه',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 16,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: deviceWidth * 0.13,
                          width: deviceWidth * 0.08,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.secondary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'ماه',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 12,
                                ),
                                overflow: TextOverflow.clip,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Consumer<CommissionCalculator>(
                                  builder: (_, commissionData, ch) => Text(
                                    EnArConvertor().replaceArNumber(
                                        commissionData.totalMonth.toString()),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 15,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'مدت زمان کل اقساط',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 12,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Divider(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                builder: (_, commissionData, ch) => FittedBox(
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        currencyFormat
                                            .format(commissionData.finalPrice)
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                builder: (_, commissionData, ch) => FittedBox(
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        currencyFormat
                                            .format(
                                                commissionData.finalCommission)
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              FittedBox(
                                child: Text(
                                  EnArConvertor().replaceArNumber(currencyFormat
                                      .format(int.parse(removeSemicolon(
                                          _totalPriceTextFieldController.text)))
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Text(
                    'جدول اقساط',
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      color: AppTheme.primary,
                      fontSize: textScaleFactor * 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
        ),
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
          color: index.isEven ? Color(0xffF1F5FF) : Color(0xffE2FBFF),
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
                  EnArConvertor().replaceArNumber(timming.toString()),
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
                    EnArConvertor().replaceArNumber(number.toString()),
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

class CurrencyInputFormatter extends TextInputFormatter {
  double totalPricevalue;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);
    totalPricevalue = value;
    final formatter = new intl.NumberFormat.decimalPattern();

    String newText = formatter.format(value / 1);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
