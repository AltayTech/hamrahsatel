import 'package:flutter/material.dart';

class CommissionCalculator with ChangeNotifier {
  double _finalPrice = 0.0;

  var _qestCount = 1;
  var _monthCount = 1;

  int _totalMonth = 1;

  var ratio = 0.04;

  double _finalCommission = 0;
  double _deposit = 0;

  double _commissionPerQest = 0;
  int _totalPrice = 0;

  double _qest;
  List<int> _qestTiming = [];

  Future<void> calculator(
    int totalPrice,
    double deposit,
    int qestCount,
    int monthCount,
  ) async {
    if (monthCount <= 6 && deposit >= (totalPrice / 2)) {
      ratio = 0.04;
    } else {
      ratio = 0.05;
    }
     _totalPrice = totalPrice;
    _totalMonth = qestCount * monthCount;
    _finalPrice = (1 + monthCount * (qestCount + 1) * ratio / 2) *
            (totalPrice - deposit) +
        deposit;

//    _commissionPerQest =double.parse(( _finalCommission /  (qestCount*1000)).toStringAsFixed(0))*1000;
    _qest=
    double.parse(( (totalPrice - deposit)/(qestCount*(1-((1+qestCount)*monthCount*ratio)/2))/1000).toStringAsFixed(0))*1000;
    _finalPrice=_qest*qestCount+deposit;
    _finalCommission = _finalPrice - totalPrice;
    _commissionPerQest=_finalCommission/qestCount;
    _monthCount = monthCount;
    _deposit = deposit;
    _qestCount=qestCount;
    _monthCount=monthCount;
//    _qest =double.parse(( _finalPrice / (qestCount*1000)).toStringAsFixed(0))*1000;
    _qestTiming.clear();
    for (int i = 1; i <= qestCount; i++) {
      _qestTiming.add(monthCount * i);
    }
    print(_finalPrice.toString());

    print(_finalCommission.toString());

    print(_commissionPerQest.toString());

    print(finalPrice.toString());
    notifyListeners();
  }

  get finalPrice => _finalPrice;

  get finalCommission => _finalCommission;

  get commissionPerQest => _commissionPerQest;

  int get totalPrice => _totalPrice;

  int get totalMonth => _totalMonth;

  double get qest => _qest;

  List<int> get qestTiming => _qestTiming;

  get qestCount => _qestCount;
  get monthCount => _monthCount;

  double get deposit => _deposit;

  set totalPrice(int value) {
    _totalPrice = value;
  }

  notifyListeners();

}
